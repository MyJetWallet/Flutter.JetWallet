import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/currency_withdraw/model/address_validation_union.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_confirm_union.dart' as confirm;
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/withdrawal/model/withdrawal_confirm_model.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/enum.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/rate_up/show_rate_up_popup.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';
import 'package:simple_networking/modules/validation_api/models/validation/verify_withdrawal_verification_code_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/validate_address/validate_address_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdraw/withdraw_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdrawal_info/withdrawal_info_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdrawal_info/withdrawal_info_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdrawal_resend/withdrawal_resend_request.dart';

part 'withdrawal_store.g.dart';

enum WithdrawalType { asset, nft, jar }

enum WithdrawStep { address, ammount, preview, confirm }

// TODO: Split

class WithdrawalStore extends _WithdrawalStoreBase with _$WithdrawalStore {
  WithdrawalStore() : super();

  static _WithdrawalStoreBase of(BuildContext context) => Provider.of<WithdrawalStore>(context, listen: false);
}

abstract class _WithdrawalStoreBase with Store {
  @observable
  WithdrawStep withdrawStep = WithdrawStep.address;
  @observable
  PageController withdrawStepController = PageController();

  @observable
  WithdrawalType withdrawalType = WithdrawalType.asset;

  @observable
  WithdrawalModel? withdrawalInputModel;

  @computed
  SendMethodDto get _sendBlockchainMethod => sSignalRModules.sendMethods.firstWhere(
        (element) => element.id == WithdrawalMethods.blockchainSend,
      );

  @computed
  List<BlockchainModel> get networks => withdrawalInputModel?.currency?.networksForBlockchainSend ?? [];

  @observable
  bool addressError = false;

  @action
  bool setAddressError(bool value) => addressError = value;

  @action
  void _triggerErrorOfAddressField() => addressError = true;

  @observable
  bool tagError = false;

  @action
  bool setTagError(bool value) => tagError = value;

  @action
  void _triggerErrorOfTagField() => tagError = true;

  @observable
  AddressValidationUnion addressValidation = const Hide();

  @action
  void _updateAddressValidation(AddressValidationUnion value) {
    addressValidation = value;
  }

  @observable
  AddressValidationUnion tagValidation = const Hide();

  @action
  void _updateTagValidation(AddressValidationUnion value) {
    tagValidation = value;
  }

  @observable
  BlockchainModel network = const BlockchainModel();

  @observable
  TextEditingController networkController = TextEditingController();

  @observable
  TextEditingController addressController = TextEditingController();

  @observable
  TextEditingController tagController = TextEditingController();

  @observable
  FocusNode addressFocus = FocusNode();

  @observable
  FocusNode tagFocus = FocusNode();

  @observable
  Key qrKey = GlobalKey();

  @observable
  bool isReadyToContinue = false;

  //@observable
  //QRViewController? qrController;

  @observable
  bool addressIsInternal = false;

  @action
  void _updateAddressIsInternal(bool value) {
    addressIsInternal = value;
  }

  @observable
  String tag = '';

  @observable
  String address = '';

  /// Ammount

  @observable
  String withAmount = '0';

  @observable
  String baseConversionValue = '0';

  @computed
  BaseCurrencyModel get baseCurrency => sSignalRModules.baseCurrency;

  @observable
  InputError withAmmountInputError = InputError.none;

  @observable
  bool withValid = false;

  @observable
  BlockchainModel blockchain = const BlockchainModel();

  @observable
  String limitError = '';

  /// Confirm

  @observable
  bool isResending = false;

  @observable
  bool confirmIsProcessing = false;

  @observable
  confirm.WithdrawalConfirmUnion confirmUnion = const confirm.WithdrawalConfirmUnion.input();

  @observable
  TextEditingController confirmController = TextEditingController();

  StandardFieldErrorNotifier pinError = StandardFieldErrorNotifier();
  StackLoaderStore confirmLoader = StackLoaderStore();
  FocusNode confirmFocusNode = FocusNode();

  /// Preview

  final previewLoader = StackLoaderStore();

  @observable
  bool previewIsProcessing = false;

  @observable
  bool previewLoading = false;

  @observable
  String operationId = '';

  @observable
  WithdrawalInfoResponseModel? nftInfo;

  ///

  @computed
  bool get requirementLoading {
    return withdrawalType == WithdrawalType.asset
        ? withdrawalInputModel?.currency?.hasTag ?? false
            ? addressValidation is Loading || tagValidation is Loading
            : addressValidation is Loading
        : addressValidation is Loading;
  }

  @computed
  bool get isRequirementError {
    return withdrawalType == WithdrawalType.asset
        ? withdrawalInputModel?.currency?.hasTag ?? false
            ? addressValidation is Invalid || tagValidation is Invalid
            : addressValidation is Invalid
        : addressValidation is Invalid;
  }

  @computed
  String get header => '''${intl.withdrawal_send_verb} ${withdrawalInputModel!.currency!.description}''';

  @computed
  String get bassAsset {
    if (withdrawalType == WithdrawalType.asset) {
      return withdrawalInputModel!.currency!.symbol;
    } else if (withdrawalType == WithdrawalType.jar) {
      return withdrawalInputModel!.jar!.assetSymbol;
    } else {
      return 'MATIC';
    }
  }

  @computed
  String get validationResult {
    if (addressValidation is Loading || tagValidation is Loading) {
      return '${intl.withdrawalAddress_checking}...';
    } else if (addressValidation is Invalid) {
      return '${intl.withdrawalAddress_invalid} $bassAsset'
          ' ${intl.withdrawalAddress_address}';
    } else if (tagValidation is Invalid) {
      return '${intl.withdrawalAddress_invalid} $bassAsset'
          ' ${intl.tag}';
    } else if (addressValidation is Invalid && tagValidation is Invalid) {
      return '${intl.withdrawalAddress_invalid} $bassAsset'
          ' ${intl.withdrawalAddress_address} & ${intl.tag}';
    } else if (addressValidation is Valid && tagValidation is Valid) {
      return '${intl.valid} $bassAsset'
          ' ${intl.withdrawalAddress_address} & ${intl.tag}';
    } else if (addressValidation is Valid) {
      return '${intl.valid} $bassAsset'
          ' ${intl.withdrawalAddress_address}';
    } else if (tagValidation is Valid) {
      return '${intl.valid} $bassAsset ${intl.tag}';
    } else {
      return intl.withdrawalAddress_error;
    }
  }

  @computed
  String get withdrawHint {
    return isReadyToContinue ? '${intl.withdrawHint_text1}.' : '${intl.withdrawHint_text2}.';
  }

  @computed
  bool get credentialsValid {
    return withdrawalType == WithdrawalType.asset
        ? withdrawalInputModel?.currency?.hasTag ?? false
            ? addressValidation is Valid && tagValidation is Valid
            : addressValidation is Valid
        : addressValidation is Valid;
  }

  @computed
  SendMethodDto get _sendWithdrawalMethod => sSignalRModules.sendMethods.firstWhere(
        (element) => element.id == WithdrawalMethods.blockchainSend,
      );

  @computed
  Decimal? get minLimit => _sendWithdrawalMethod.symbolNetworkDetails?.firstWhere(
        (element) => element.network == network.id && element.symbol == withdrawalInputModel?.currency?.symbol,
        orElse: () {
          return const SymbolNetworkDetails();
        },
      ).minAmount;

  @computed
  Decimal? get maxLimit => _sendWithdrawalMethod.symbolNetworkDetails?.firstWhere(
        (element) => element.network == network.id && element.symbol == withdrawalInputModel?.currency?.symbol,
        orElse: () {
          return const SymbolNetworkDetails();
        },
      ).maxAmount;

  ///

  late StreamSubscription withdrawSubscription;

  @action
  void init(WithdrawalModel input) {
    withdrawalInputModel = input;

    if (withdrawalInputModel!.jar != null) {
      withdrawalType = WithdrawalType.jar;

      if (withdrawalInputModel!.currency!.isSingleNetworkForBlockchainSend) {
        updateNetwork(networks[0]);
      }
    } else if (withdrawalInputModel!.currency != null) {
      withdrawalType = WithdrawalType.asset;

      if (withdrawalInputModel!.currency!.isSingleNetworkForBlockchainSend) {
        updateNetwork(networks[0]);
      }

      //addressController.text = '0x71C7656EC7ab88b098defB751B7401B5f6d8976F';
    } else {
      withdrawalType = WithdrawalType.nft;

      networkController.text = withdrawalInputModel!.nft!.blockchain!;

      //addressController.text = '0x9fCD3018a923B5BD3488bBA507e2ceb002AECe1D';
    }

    withdrawSubscription = getIt<EventBus>().on<WithdrawalConfirmModel>().listen(updateCode);
  }

  @action
  void withdrawalPush(
    WithdrawStep step, {
    bool isReplace = false,
  }) {
    switch (step) {
      case WithdrawStep.address:
        if (isReplace) {
          sRouter.popUntil((route) => route.settings is WithdrawalAddressRouter);
        } else {
          sRouter.push(const WithdrawalAddressRouter());
        }

      case WithdrawStep.ammount:
        if (isReplace) {
          sRouter.popUntil((route) => route.settings is WithdrawalAmmountRouter);
        } else {
          sRouter.push(const WithdrawalAmmountRouter());
        }

      case WithdrawStep.preview:
        if (isReplace) {
          sRouter.popUntil((route) => route.settings is WithdrawalPreviewRouter);
        } else {
          sRouter.push(const WithdrawalPreviewRouter());
        }

      case WithdrawStep.confirm:
        if (isReplace) {
          sRouter.popUntil((route) => route.settings is WithdrawalConfirmRouter);
        } else {
          sRouter.push(const WithdrawalConfirmRouter());
        }

      default:
    }
  }

  @action
  void setIsReadyToContinue() {
    if (withdrawalType == WithdrawalType.asset) {
      if (withdrawalInputModel?.currency == null) return;

      final condition1 = addressValidation is Hide || addressValidation is Valid;
      final condition2 = tagValidation is Hide || tagValidation is Valid;
      final condition3 = addressController.text.isNotEmpty;
      final condition4 = tag.isNotEmpty || networkController.text == earnRipple;

      isReadyToContinue =
          tag.isNotEmpty ? condition1 && condition2 && condition3 && condition4 : condition1 && condition3;
    } else if (withdrawalInputModel?.nft != null) {
      isReadyToContinue = networkController.text.isNotEmpty && addressValidation is Valid;
    } else if (withdrawalInputModel?.jar != null) {
      final condition1 = addressValidation is Hide || addressValidation is Valid;
      final condition2 = tagValidation is Hide || tagValidation is Valid;
      final condition3 = addressController.text.isNotEmpty;
      final condition4 = tag.isNotEmpty || networkController.text == earnRipple;

      isReadyToContinue =
          tag.isNotEmpty ? condition1 && condition2 && condition3 && condition4 : condition1 && condition3;
    }
  }

  @action
  Future<void> validateOnContinue(BuildContext context) async {
    if (credentialsValid) {
      if (withdrawalType == WithdrawalType.nft) {
        await withdrawNFT();
      }
      if (context.mounted) {
        return _pushWithdrawalAmount(context);
      }
    }

    _updateValidationOfBothFields(const Loading());

    try {
      final model = ValidateAddressRequestModel(
        assetSymbol: withdrawalInputModel!.currency!.symbol,
        toAddress: addressController.text,
        toTag: tag,
        assetNetwork: network.id,
      );

      final response = await sNetwork.getWalletModule().postValidateAddress(model);

      response.pick(
        onData: (data) {
          _updateAddressIsInternal(data.isInternal);

          if (data.isValid) {
            _updateValidationOfBothFields(const Valid());
          } else {
            _updateValidationOfBothFields(const Invalid());
            _triggerErrorOfBothFields();
          }

          if (credentialsValid) {
            _pushWithdrawalAmount(context);
          }
        },
        onError: (error) {
          _updateValidationOfBothFields(const Invalid());
          _triggerErrorOfBothFields();
        },
      );
    } catch (error) {
      _updateValidationOfBothFields(const Invalid());
      _triggerErrorOfBothFields();
    }

    setIsReadyToContinue();
  }

  @action
  Future<void> _validateAddressOrTag(
    void Function(AddressValidationUnion) updateValidation,
    void Function() triggerErrorOfField,
  ) async {
    updateValidation(const Loading());

    try {
      ValidateAddressRequestModel? model;

      if (withdrawalType == WithdrawalType.asset) {
        model = ValidateAddressRequestModel(
          assetSymbol: withdrawalInputModel!.currency!.symbol,
          toAddress: addressController.text,
          toTag: tag,
          assetNetwork: network.id,
        );
      } else if (withdrawalType == WithdrawalType.jar) {
        model = ValidateAddressRequestModel(
          assetSymbol: withdrawalInputModel!.jar!.assetSymbol,
          toAddress: addressController.text,
          toTag: tag,
          assetNetwork: withdrawalInputModel!.jar!.addresses.first.blockchain,
        );
      } else {
        model = ValidateAddressRequestModel(
          assetSymbol: withdrawalInputModel!.nft!.symbol!,
          toAddress: addressController.text,
          toTag: tag,
          assetNetwork: withdrawalInputModel!.nft!.blockchain!,
        );
      }

      final response = await sNetwork.getWalletModule().postValidateAddress(model);

      response.pick(
        onData: (data) {
          _updateAddressIsInternal(data.isInternal);

          if (data.isValid) {
            updateValidation(const Valid());
          } else {
            updateValidation(const Invalid());
            triggerErrorOfField();
          }
        },
        onError: (error) {
          updateValidation(const Invalid());
          triggerErrorOfField();
        },
      );
    } catch (error) {
      updateValidation(const Invalid());
      triggerErrorOfField();
    }

    setIsReadyToContinue();
  }

  ///

  @action
  void updateNetwork(BlockchainModel net) {
    network = net;
    networkController.text = net.description;
    blockchain = net;

    setIsReadyToContinue();
  }

  @action
  Future<void> pasteAddress(ScrollController scrollController) async {
    final copiedText = await _copiedText();

    addressController.text = copiedText;
    _moveCursorAtTheEnd(addressController);
    addressFocus.requestFocus();

    updateAddress(copiedText);

    await _validateAddressOrTag(
      _updateAddressValidation,
      _triggerErrorOfTagField,
    );

    scrollToBottom(scrollController);
    setIsReadyToContinue();
  }

  @action
  Future<void> scanAddressQr(
    BuildContext context,
    ScrollController scrollController,
  ) async {
    final status = await _checkCameraStatusAction();

    if (status == CameraStatus.permanentlyDenied) {
      if (context.mounted) {
        _pushAllowCamera(context);
      }
    } else if (status == CameraStatus.granted) {
      if (context.mounted) {
        final result = await _pushQrView(
          context: context,
        );

        if (result is Barcode) {
          addressController.text = result.rawValue ?? '';
          _moveCursorAtTheEnd(addressController);
          addressFocus.requestFocus();
          updateAddress(result.rawValue ?? '');
          await _validateAddressOrTag(
            _updateAddressValidation,
            _triggerErrorOfAddressField,
          );
          scrollToBottom(scrollController);
        }
      }
    }

    setIsReadyToContinue();
  }

  @action
  void updateAddress(String value, {bool validate = false}) {
    if (address != value) {
      _updateAddressValidation(const Hide());
      tagError = false;
      addressError = false;
      address = value;

      if (validate && (value.length >= 5)) {
        _validateAddressOrTag(
          _updateAddressValidation,
          _triggerErrorOfAddressField,
        );
      }

      setIsReadyToContinue();
    }
  }

  @action
  void eraseAddress() {
    addressController.text = '';
    updateAddress('');

    addressFocus.unfocus();
    _updateAddressValidation(const Hide());

    setIsReadyToContinue();
  }

  @action
  void updateTag(String val) {
    if (tag != val) {
      _updateTagValidation(const Hide());
      tag = val;

      setIsReadyToContinue();
    }
  }

  @action
  void eraseTag() {
    tagController.text = '';
    updateTag('');

    tagFocus.unfocus();
    _updateTagValidation(const Hide());

    setIsReadyToContinue();
  }

  @action
  Future<void> pasteTag(ScrollController scrollController) async {
    final copiedText = await _copiedText();
    tagController.text = copiedText;

    _moveCursorAtTheEnd(tagController);

    tagFocus.requestFocus();

    updateTag(copiedText);

    await _validateAddressOrTag(
      _updateTagValidation,
      _triggerErrorOfTagField,
    );

    scrollToBottom(scrollController);
    setIsReadyToContinue();
  }

  @action
  Future<void> scanTagQr(
    BuildContext context,
    ScrollController scrollController,
  ) async {
    final status = await _checkCameraStatusAction();

    if (status == CameraStatus.permanentlyDenied) {
      if (context.mounted) {
        _pushAllowCamera(context);
      }
    } else if (status == CameraStatus.granted) {
      if (context.mounted) {
        final result = await _pushQrView(
          context: context,
        );

        if (result is Barcode) {
          tagController.text = result.rawValue ?? '';
          _moveCursorAtTheEnd(tagController);
          tagFocus.requestFocus();
          updateTag(result.rawValue ?? '');
          await _validateAddressOrTag(
            _updateTagValidation,
            _triggerErrorOfTagField,
          );
          scrollToBottom(scrollController);
        }
      }
    }

    setIsReadyToContinue();
  }

  @action
  void scrollToBottom(ScrollController scrollController) {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @action
  void _pushWithdrawalAmount(BuildContext context) {
    if (withdrawalType == WithdrawalType.asset || withdrawalType == WithdrawalType.jar) {
      withdrawalPush(WithdrawStep.ammount);
    } else {
      withdrawalPush(WithdrawStep.preview);
    }
  }

  @action
  void _updateValidationOfBothFields(AddressValidationUnion value) {
    _updateAddressValidation(value);

    if (withdrawalInputModel?.currency?.hasTag ?? false) {
      _updateTagValidation(value);
    }
  }

  @action
  void _triggerErrorOfBothFields() {
    _triggerErrorOfAddressField();

    if (withdrawalInputModel?.currency?.hasTag ?? false) {
      _triggerErrorOfTagField();
    }
  }

  @action
  Future<String> _copiedText() async {
    final data = await Clipboard.getData('text/plain');

    return (data?.text ?? '').replaceAll(' ', '');
  }

  @action
  void _moveCursorAtTheEnd(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  @action
  Future<CameraStatus> _checkCameraStatusAction() async {
    final storage = sLocalStorageService;
    final storageStatus = await storage.getValue(cameraStatusKey);
    final permissionStatus = await Permission.camera.request();

    if (permissionStatus == PermissionStatus.denied || permissionStatus == PermissionStatus.permanentlyDenied) {
      if (storageStatus != null) {
        return CameraStatus.permanentlyDenied;
      }
    } else if (permissionStatus == PermissionStatus.granted) {
      return CameraStatus.granted;
    }

    await sLocalStorageService.setString(
      cameraStatusKey,
      'triggered',
    );

    return CameraStatus.denied;
  }

  @action
  void _pushAllowCamera(BuildContext context) {
    sRouter.push(
      AllowCameraRoute(
        permissionDescription: intl.withdrawalAddress_pushAllowCamera,
        then: () async {
          Future.delayed(const Duration(microseconds: 100), () async {
            await _pushQrView(context: context);
          });
        },
      ),
    );
  }

  @action
  Future _pushQrView({
    bool fromSettings = false,
    required BuildContext context,
  }) {
    isRedirectedFromQr = false;

    //return fromSettings ? Navigator.push(context, qrPageRoute) : Navigator.push(context, qrPageRoute);
    return fromSettings
        ? sRouter.popAndPush(
            ScannerRoute(
              qrKey: qrKey,
              onQRScanned: (c, context) => _onQRScanned(c, context),
            ),
          )
        : sRouter.push(
            ScannerRoute(
              qrKey: qrKey,
              onQRScanned: (c, context) => _onQRScanned(c, context),
            ),
          );
  }

  /*
  @action
  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    controller.resumeCamera();

    qrController = controller;

    controller.scannedDataStream.listen(
      (event) {
        controller.dispose();
        Navigator.pop(context, event);
      },
    );
  }
  */

  var isRedirectedFromQr = false;

  @action
  void _onQRScanned(BarcodeCapture capture, BuildContext context) {
    if (isRedirectedFromQr) return;

    isRedirectedFromQr = true;
    Navigator.pop(context, capture.barcodes.first);
  }

  @action
  void updateAmount(String value) {
    withAmount = responseOnInputAction(
      oldInput: withAmount,
      newInput: value,
      accuracy: withdrawalInputModel!.currency!.accuracy,
    );

    _validateAmount();
    _calculateBaseConversion();
  }

  @action
  void pasteAmount(String value) {
    withAmount = value;

    _validateAmount();
    _calculateBaseConversion();
  }

  @action
  void _validateAmount() {
    InputError error;
    if (withdrawalType == WithdrawalType.jar) {
      error = onWithdrawJarInputErrorHandler(
        withAmount,
        blockchain.description,
        withdrawalInputModel!.jar!.balance,
        withdrawalInputModel!.currency!,
        addressIsInternal: addressIsInternal,
      );
    } else {
      error = onWithdrawInputErrorHandler(
        withAmount,
        blockchain.description,
        withdrawalInputModel!.currency!,
        addressIsInternal: addressIsInternal,
      );
    }

    final value = Decimal.parse(withAmount);

    if (error != InputError.none) {
      sAnalytics.cryptoSendErrorLimit(
        asset: withdrawalInputModel!.currency!.symbol,
        network: network.description,
        sendMethodType: '0',
        errorCode: withAmmountInputError.name,
      );
    }
    if (minLimit != null && minLimit! > value) {
      limitError = '${intl.currencyBuy_paymentInputErrorText1} ${minLimit?.toFormatCount(
        accuracy: withdrawalInputModel?.currency?.accuracy ?? 0,
        symbol: withdrawalInputModel?.currency?.symbol ?? '',
      )}';
    } else if (maxLimit != null && maxLimit! < value) {
      limitError = '${intl.currencyBuy_paymentInputErrorText2} ${maxLimit?.toFormatCount(
        accuracy: withdrawalInputModel?.currency?.accuracy ?? 0,
      )}';
    } else {
      limitError = '';
    }

    withAmmountInputError = double.parse(withAmount) != 0
        ? error == InputError.none
            ? limitError.isEmpty
                ? InputError.none
                : InputError.limitError
            : error
        : InputError.none;

    withValid = withAmmountInputError == InputError.none && isInputValid(withAmount);
  }

  @action
  void _calculateBaseConversion() {
    if (withAmount.isNotEmpty) {
      final baseValue = calculateBaseBalanceWithReader(
        assetSymbol: withdrawalInputModel!.currency!.symbol,
        assetBalance: Decimal.parse(withAmount),
      );

      baseConversionValue = truncateZerosFrom(baseValue.toString());
    } else {
      baseConversionValue = zero;
    }
  }

  ///

  @action
  Future<void> withdraw({required String newPin}) async {
    previewLoader.startLoadingImmediately();

    sAnalytics.cryptoSenLoadingOrderSummary(
      asset: withdrawalInputModel!.currency!.symbol,
      network: network.description,
      sendMethodType: '0',
      totalSendAmount: withAmount,
      paymentFee: addressIsInternal
          ? 'No fee'
          : withdrawalInputModel!.currency!.withdrawalFeeWithSymbol(
              network: networkController.text,
              amount: Decimal.parse(withAmount),
            ),
    );

    previewLoading = true;
    final storageService = getIt.get<LocalStorageService>();
    if (withdrawalInputModel != null && withdrawalInputModel?.currency != null) {
      await storageService.setString(
        lastAssetSend,
        withdrawalInputModel!.currency!.symbol,
      );
    }

    try {
      final model = WithdrawRequestModel(
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        assetSymbol: withdrawalInputModel!.currency!.symbol,
        amount: Decimal.parse(withAmount),
        toAddress: address,
        toTag: tag,
        blockchain: blockchain.id,
        lang: intl.localeName,
        pin: newPin,
      );

      final response = await sNetwork.getWalletModule().postWithdraw(model);

      response.pick(
        onData: (data) {
          operationId = data.operationId;

          previewConfirm();
        },
        onError: (error) {
          _showFailureScreen(error);
        },
      );
    } on ServerRejectException catch (error) {
      _showFailureScreen(error);
    } catch (error) {
      _showNoResponseScreen(error.toString());
    }

    previewLoading = false;
    previewLoader.finishLoadingImmediately();
  }

  @action
  Future<void> withdrawNFT() async {
    previewLoading = true;
    previewLoader.startLoadingImmediately();

    try {
      final model = WithdrawRequestModel(
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        assetSymbol: withdrawalInputModel!.nft!.symbol!,
        amount: withdrawalInputModel!.nft!.buyPrice!,
        toAddress: address,
        blockchain: withdrawalInputModel!.nft!.blockchain!,
        lang: intl.localeName,
        pin: '',
      );

      final response = await sNetwork.getWalletModule().postWithdraw(model);

      response.pick(
        onData: (data) {
          operationId = data.operationId;

          //_previewConfirm();

          getWithdrawalInfo();
        },
        onError: (error) {
          _showFailureScreen(error);
        },
      );
    } on ServerRejectException catch (error) {
      _showFailureScreen(error);
    } catch (error) {
      _showNoResponseScreen(error.toString());
    }

    previewLoading = false;
    previewLoader.finishLoadingImmediately();
  }

  @action
  Future<void> withdrawJar({required String newPin}) async {
    previewLoader.startLoadingImmediately();
    previewLoading = true;

    try {
      final model = WithdrawJarRequestModel(
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        assetSymbol: withdrawalInputModel!.jar!.addresses.first.assetSymbol,
        amount: Decimal.parse(withAmount),
        toAddress: address,
        toTag: tag,
        blockchain: withdrawalInputModel!.jar!.addresses.first.blockchain,
        lang: intl.localeName,
        pin: newPin,
        jarId: withdrawalInputModel!.jar!.id,
      );

      final response = await sNetwork.getWalletModule().postWithdrawJar(model);

      response.pick(
        onData: (data) {
          operationId = data.operationId;

          previewConfirm();
        },
        onError: (error) {
          _showFailureScreen(error);
        },
      );
    } on ServerRejectException catch (error) {
      _showFailureScreen(error);
    } catch (error) {
      _showNoResponseScreen(error.toString());
    }

    previewLoading = false;
    previewLoader.finishLoadingImmediately();
  }

  @action
  void _showNoResponseScreen(String error) {
    sAnalytics.cryptoSendFailedSend(
      asset: withdrawalInputModel!.currency!.symbol,
      network: network.description,
      sendMethodType: '0',
      totalSendAmount: withAmount,
      paymentFee: addressIsInternal
          ? 'No fee'
          : withdrawalInputModel!.currency!.withdrawalFeeWithSymbol(
              network: networkController.text,
              amount: Decimal.parse(withAmount),
            ),
      failedReason: error,
    );

    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.showNoResponseScreen_text,
        secondaryText: intl.showNoResponseScreen_text2,
        secondaryButtonName: intl.withdraw_failure_screen_secondary_button_name,
        onSecondaryButtonTap: () {
          sRouter.push(
            WithdrawRouter(
              withdrawal: withdrawalInputModel!,
            ),
          );
        },
      ),
    );
  }

  @action
  void previewConfirm() {
    previewLoading = false;
    previewLoader.finishLoadingImmediately();

    _confirmSuccessScreen();
  }

  @action
  void _showFailureScreen(ServerRejectException error) {
    sAnalytics.cryptoSendFailedSend(
      asset: withdrawalInputModel!.currency!.symbol,
      network: network.description,
      sendMethodType: '0',
      totalSendAmount: withAmount,
      paymentFee: addressIsInternal
          ? 'No fee'
          : withdrawalInputModel!.currency!.withdrawalFeeWithSymbol(
              network: networkController.text,
              amount: Decimal.parse(withAmount),
            ),
      failedReason: error.cause,
    );

    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.withdrawalPreview_failure,
        secondaryText: error.cause,
        secondaryButtonName: intl.withdrawalPreview_editOrder,
        onSecondaryButtonTap: () {
          sRouter.push(
            WithdrawRouter(
              withdrawal: withdrawalInputModel!,
            ),
          );
        },
      ),
    );
  }

  ///

  @action
  Future<void> verifyCode() async {
    if (confirmUnion is confirm.Loading) {
      return;
    }

    confirmUnion = const confirm.WithdrawalConfirmUnion.loading();

    confirmLoader.startLoadingImmediately();

    try {
      final model = VerifyWithdrawalVerificationCodeRequestModel(
        operationId: operationId,
        code: confirmController.text,
        brand: 'simple',
      );

      final resp = await sNetwork.getValidationModule().postVerifyWithdrawalVerificationCode(model);

      if (resp.hasError) {
        confirmUnion = confirm.WithdrawalConfirmUnion.error(resp.error!.cause);

        pinError.enableError();

        await Future.delayed(
          const Duration(seconds: 2),
          () => confirmController.clear(),
        );

        //_confirmFailureScreen();
      } else {
        confirmUnion = const confirm.WithdrawalConfirmUnion.input();

        _confirmSuccessScreen();
      }
    } on ServerRejectException catch (error) {
      confirmUnion = confirm.WithdrawalConfirmUnion.error(error.cause);
    } catch (error) {
      confirmUnion = confirm.WithdrawalConfirmUnion.error(error);

      _confirmFailureScreen();
    }
  }

  @action
  Future<void> withdrawalResend({required Function() onSuccess}) async {
    confirmUnion = const confirm.WithdrawalConfirmUnion.loading();

    isResending = true;

    try {
      final model = WithdrawalResendRequestModel(
        operationId: operationId,
      );

      final _ = await sNetwork.getWalletModule().postWithdrawalResend(model);
      confirmUnion = const confirm.WithdrawalConfirmUnion.input();

      isResending = false;
      onSuccess();
    } catch (error) {
      isResending = false;
      confirmUnion = const confirm.WithdrawalConfirmUnion.input();

      sNotification.showError(
        '${intl.withdrawalConfirm_failedToResend}!',
        id: 1,
      );
    }
  }

  @action
  void _confirmFailureScreen() {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.withdrawalConfirm_failure,
        secondaryText: '''${intl.withdrawalConfirm_failedTo} ${intl.withdrawal_send_verb.toLowerCase()}''',
        secondaryButtonName:
            withdrawalType == WithdrawalType.asset ? intl.withdrawalConfirm_editOrder : intl.send_timer_alert_ok,
        onSecondaryButtonTap: () {
          if (withdrawalType == WithdrawalType.asset) {
            sRouter.replaceAll([
              const HomeRouter(
                children: [
                  MyWalletsRouter(),
                ],
              ),
              WithdrawRouter(withdrawal: withdrawalInputModel!),
            ]);
          } else {
            sRouter.popUntilRoot();
          }
        },
      ),
    );
  }

  @action
  void _confirmSuccessScreen() {
    sAnalytics.cryptoSendSuccessSend(
      asset: withdrawalInputModel!.currency!.symbol,
      network: network.description,
      sendMethodType: '0',
      totalSendAmount: withAmount,
      paymentFee: addressIsInternal
          ? 'No fee'
          : withdrawalInputModel!.currency!.withdrawalFeeWithSymbol(
              network: networkController.text,
              amount: Decimal.parse(withAmount),
            ),
    );

    sRouter
        .push(
      SuccessScreenRouter(
        secondaryText: '${intl.withdrawal_successRequest} ${Decimal.parse(withAmount)}'
            ' ${withdrawalInputModel!.currency!.symbol}'
            ' ${intl.withdrawal_successPlaced}',
        onSuccess: (context) {
          if (withdrawalType == WithdrawalType.jar) {
            sRouter.replaceAll(
              [
                JarRouter(hasLeftIcon: true),
              ],
            );
          } else {
            sRouter.replaceAll([
              const HomeRouter(
                children: [
                  MyWalletsRouter(),
                ],
              ),
            ]);
          }
        },
      ),
    )
        .then((value) {
      shopRateUpPopup(sRouter.navigatorKey.currentContext!);
    });
  }

  @action
  Future<void> updateCode(WithdrawalConfirmModel data) async {
    if (data.code.isEmpty) {
      return;
    }

    confirmController.text = data.code;

    if (operationId == data.operationID) {
      await verifyCode();
    } else {
      sNotification.showError(
        intl.showError_youHaveConfirmed,
        id: 1,
      );

      pinError.enableError();

      await Future.delayed(
        const Duration(seconds: 2),
        () => confirmController.clear(),
      );
    }
  }

  @action
  Future<void> getWithdrawalInfo() async {
    final model = WithdrawalInfoRequestModel(operationId: operationId);

    final resp = await sNetwork.getWalletModule().postWithdrawalInfo(model);

    resp.pick(
      onData: (data) {
        nftInfo = data;
      },
    );
  }

  @action
  void dispose() {
    withdrawSubscription.cancel();
  }
}

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()..addRect(scanWindow);

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    canvas.drawPath(backgroundWithCutout, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
