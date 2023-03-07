import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/currency_withdraw/model/address_validation_union.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/enum.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';
import 'package:simple_networking/modules/wallet_api/models/validate_address/validate_address_request_model.dart';

import 'withdrawal_amount_store.dart';

part 'withdrawal_address_store.g.dart';

class WithdrawalAddressStore extends _WithdrawalAddressStoreBase
    with _$WithdrawalAddressStore {
  WithdrawalAddressStore() : super();

  static _WithdrawalAddressStoreBase of(BuildContext context) =>
      Provider.of<WithdrawalAddressStore>(context, listen: false);
}

abstract class _WithdrawalAddressStoreBase with Store {
  static final _logger = Logger('WithdrawalAddressStore');

  @observable
  bool addressError = false;
  @action
  bool setAddressError(bool value) => addressError = value;

  @observable
  bool tagError = false;
  @action
  bool setTagError(bool value) => tagError = value;

  WithdrawalModel? withdrawal;

  @observable
  CurrencyModel? currency;

  CurrencyModel? currencyModel;
  NftMarket? nftModel;

  @observable
  QRViewController? qrController;

  @observable
  bool addressIsInternal = false;

  @observable
  String tag = '';

  @observable
  String address = '';

  @observable
  BlockchainModel network = const BlockchainModel();

  @observable
  AddressValidationUnion addressValidation = const Hide();

  @observable
  AddressValidationUnion tagValidation = const Hide();

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

  @computed
  bool get showAddressErase => address.isNotEmpty;

  @computed
  bool get showTagErase => tag.isNotEmpty;

  @computed
  bool get credentialsValid {
    return currency != null
        ? currency!.hasTag
            ? addressValidation is Valid && tagValidation is Valid
            : addressValidation is Valid
        : addressValidation is Valid;
  }

  @computed
  String get header => currencyModel != null
      ? '${withdrawal!.dictionary.verb} ${currencyModel!.description}'
      : '${intl.nft_send} ${nftModel!.name}';

  @action
  void clearData() {
    currencyModel = null;
    nftModel = null;

    addressValidation = const Hide();
    tagValidation = const Hide();

    networkController.text = '';
    addressController.text = '';
    tagController.text = '';

    isReadyToContinue = false;
  }

  @action
  void clearDataAndInit(WithdrawalModel wtd) {
    currencyModel = null;
    nftModel = null;

    addressValidation = const Hide();
    tagValidation = const Hide();

    networkController.text = '';
    addressController.text = '';
    tagController.text = '';

    isReadyToContinue = false;

    withdrawal = wtd;

    if (wtd.currency != null) {
      currencyModel = wtd.currency;

      if (currencyModel!.isSingleNetwork) {
        updateNetwork(currencyModel!.withdrawalBlockchains[0]);
      }

      currency = currencyModel;
    } else if (wtd.nft != null) {
      nftModel = wtd.nft;

      networkController.text = nftModel!.blockchain!;

      //addressController.text = '0xADc38bd99Ed01bAF0a10645aa7A96015C645bf6C';
      //updateAddress('0xADc38bd99Ed01bAF0a10645aa7A96015C645bf6C',);
    }
  }

  @action
  void setIsReadyToContinue() {
    if (currencyModel != null) {
      if (currency == null) return;

      final condition1 =
          addressValidation is Hide || addressValidation is Valid;
      final condition2 = tagValidation is Hide || tagValidation is Valid;
      final condition3 = addressController.text.isNotEmpty;
      final condition4 = tag.isNotEmpty || networkController.text == earnRipple;

      isReadyToContinue = tag.isNotEmpty
          ? condition1 && condition2 && condition3 && condition4
          : condition1 && condition3;
    } else if (nftModel != null) {
      isReadyToContinue =
          networkController.text.isNotEmpty && addressValidation is Valid;
    }
  }

  /*
    @computed
    bool get isReadyToContinue {
      final condition1 = addressValidation is Hide || addressValidation is Valid;
      final condition2 = tagValidation is Hide || tagValidation is Valid;
      final condition3 = address.isNotEmpty;
      final condition4 = tag.isNotEmpty || networkController.text == earnRipple;

      return currency!.hasTag
          ? condition1 && condition2 && condition3 && condition4
          : condition1 && condition3;
    }
  */

  @computed
  bool get requirementLoading {
    return currency != null
        ? currency!.hasTag
            ? addressValidation is Loading || tagValidation is Loading
            : addressValidation is Loading
        : addressValidation is Loading;
  }

  @computed
  bool get isRequirementError {
    return currency != null
        ? currency!.hasTag
            ? addressValidation is Invalid || tagValidation is Invalid
            : addressValidation is Invalid
        : addressValidation is Invalid;
  }

  @action
  void updateQrController(QRViewController controller) {
    _logger.log(notifier, 'updateQrController');

    controller.resumeCamera();

    qrController = controller;
  }

  @action
  void updateNetwork(BlockchainModel net) {
    _logger.log(notifier, 'updateNetwork');

    network = net;
    networkController.text = net.description;

    setIsReadyToContinue();
  }

  @action
  void updateAddress(String _address, {bool validate = false}) {
    if (address != _address) {
      _logger.log(notifier, 'updateAddress');

      _updateAddressValidation(const Hide());
      tagError = false;
      addressError = false;
      address = _address;

      if (validate && (_address.length >= 5)) {
        _validateAddressOrTag(
          _updateAddressValidation,
          _triggerErrorOfAddressField,
        );
      }

      setIsReadyToContinue();
    }
  }

  @action
  void updateTag(String _tag) {
    if (tag != _tag) {
      _logger.log(notifier, 'updateTag');

      _updateTagValidation(const Hide());
      tag = _tag;

      setIsReadyToContinue();
    }
  }

  @action
  void eraseAddress() {
    _logger.log(notifier, 'eraseAddress');

    addressController.text = '';
    updateAddress('');

    addressFocus.unfocus();
    _updateAddressValidation(const Hide());

    setIsReadyToContinue();
  }

  @action
  void eraseTag() {
    _logger.log(notifier, 'eraseTag');

    tagController.text = '';
    updateTag('');

    tagFocus.unfocus();
    _updateTagValidation(const Hide());

    setIsReadyToContinue();
  }

  @action
  Future<void> pasteAddress(ScrollController scrollController) async {
    _logger.log(notifier, 'pasteAddress');

    final copiedText = await _copiedText();

    addressController.text = copiedText;
    _moveCursorAtTheEnd(addressController);
    addressFocus.requestFocus();

    updateAddress(copiedText);

    await _validateAddressOrTag(
      _updateAddressValidation,
      _triggerErrorOfAddressField,
    );

    scrollToBottom(scrollController);
    setIsReadyToContinue();
  }

  @action
  Future<void> pasteTag(ScrollController scrollController) async {
    _logger.log(notifier, 'pasteTag');

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
  Future<void> scanAddressQr(
    BuildContext context,
    ScrollController scrollController,
  ) async {
    _logger.log(notifier, 'scanAddressQr');

    final status = await _checkCameraStatusAction();

    if (status == CameraStatus.permanentlyDenied) {
      _pushAllowCamera(context);
    } else if (status == CameraStatus.granted) {
      final result = await _pushQrView(
        context: context,
      );

      if (result is Barcode) {
        addressController.text = result.code ?? '';
        _moveCursorAtTheEnd(addressController);
        addressFocus.requestFocus();
        updateAddress(result.code ?? '');
        await _validateAddressOrTag(
          _updateAddressValidation,
          _triggerErrorOfAddressField,
        );
        scrollToBottom(scrollController);
      }
    }

    setIsReadyToContinue();
  }

  @action
  void scrollToBottom(ScrollController scrollController) {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @action
  Future<void> scanTagQr(
    BuildContext context,
    ScrollController scrollController,
  ) async {
    _logger.log(notifier, 'scanTagQr');

    final status = await _checkCameraStatusAction();

    if (status == CameraStatus.permanentlyDenied) {
      _pushAllowCamera(context);
    } else if (status == CameraStatus.granted) {
      final result = await _pushQrView(
        context: context,
      );

      if (result is Barcode) {
        tagController.text = result.code ?? '';
        _moveCursorAtTheEnd(tagController);
        tagFocus.requestFocus();
        updateTag(result.code ?? '');
        await _validateAddressOrTag(
          _updateTagValidation,
          _triggerErrorOfTagField,
        );
        scrollToBottom(scrollController);
      }
    }

    setIsReadyToContinue();
  }

  @action
  Future<CameraStatus> _checkCameraStatusAction() async {
    final storage = sLocalStorageService;
    final storageStatus = await storage.getValue(cameraStatusKey);
    final permissionStatus = await Permission.camera.request();

    if (permissionStatus == PermissionStatus.denied ||
        permissionStatus == PermissionStatus.permanentlyDenied) {
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
  Future _pushQrView({
    bool fromSettings = false,
    required BuildContext context,
  }) {
    final colors = sKit.colors;

    final qrPageRoute = MaterialPageRoute(
      builder: (context) {
        return Stack(
          children: [
            QRView(
              key: qrKey,
              onQRViewCreated: (c) => _onQRViewCreated(c, context),
              overlay: QrScannerOverlayShape(),
            ),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 28.0,
                    top: 68.0,
                  ),
                  width: 24,
                  height: 24,
                  child: SCloseIcon(
                    color: colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    return fromSettings
        ? Navigator.pushReplacement(context, qrPageRoute)
        : Navigator.push(context, qrPageRoute);
  }

  @action
  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    updateQrController(controller);

    controller.scannedDataStream.listen(
      (event) {
        controller.dispose();
        Navigator.pop(context, event);
      },
    );
  }

  @action
  Future<void> _validateAddressOrTag(
    void Function(AddressValidationUnion) updateValidation,
    void Function() triggerErrorOfField,
  ) async {
    updateValidation(const Loading());

    try {
      ValidateAddressRequestModel? model;

      model = currencyModel != null
          ? ValidateAddressRequestModel(
              assetSymbol: currencyModel!.symbol,
              toAddress: addressController.text,
              toTag: tag,
              assetNetwork: network.id,
            )
          : ValidateAddressRequestModel(
              assetSymbol: nftModel!.symbol!,
              toAddress: addressController.text,
              toTag: tag,
              assetNetwork: nftModel!.blockchain!,
            );

      final response =
          await sNetwork.getWalletModule().postValidateAddress(model);

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
          _logger.log(stateFlow, '_validateAddressOrTag', error);
          updateValidation(const Invalid());
          triggerErrorOfField();
        },
      );
    } catch (error) {
      _logger.log(stateFlow, '_validateAddressOrTag', error);
      updateValidation(const Invalid());
      triggerErrorOfField();
    }

    setIsReadyToContinue();
  }

  @action
  Future<void> validateOnContinue(BuildContext context) async {
    _logger.log(notifier, 'validateAddressAndTag');

    if (credentialsValid) {
      if (nftModel != null) {
        final matic = currencyFrom(
          sSignalRModules.currenciesList,
          'MATIC',
        );

      }
      _pushWithdrawalAmount(context);

      return;
    }

    _updateValidationOfBothFields(const Loading());

    try {
      final model = ValidateAddressRequestModel(
        assetSymbol: currencyModel!.symbol,
        toAddress: addressController.text,
        toTag: tag,
        assetNetwork: network.id,
      );

      final response =
          await sNetwork.getWalletModule().postValidateAddress(model);

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
            if (nftModel != null) {
              final matic = currencyFrom(
                sSignalRModules.currenciesList,
                'MATIC',
              );
            }

            _pushWithdrawalAmount(context);
          }
        },
        onError: (error) {
          _logger.log(stateFlow, 'validateAddressAndTag', error);
          _updateValidationOfBothFields(const Invalid());
          _triggerErrorOfBothFields();
        },
      );
    } catch (error) {
      _logger.log(stateFlow, 'validateAddressAndTag', error);
      _updateValidationOfBothFields(const Invalid());
      _triggerErrorOfBothFields();
    }

    setIsReadyToContinue();
  }

  @action
  void _updateValidationOfBothFields(AddressValidationUnion value) {
    _updateAddressValidation(value);
    if (currencyModel!.hasTag) {
      _updateTagValidation(value);
    }
  }

  @action
  void _triggerErrorOfBothFields() {
    _triggerErrorOfAddressField();
    if (currencyModel!.hasTag) {
      _triggerErrorOfTagField();
    }
  }

  @action
  void _triggerErrorOfAddressField() {
    addressError = true;
  }

  @action
  void _triggerErrorOfTagField() {
    tagError = true;
  }

  @action
  void _updateAddressValidation(AddressValidationUnion value) {
    addressValidation = value;
  }

  @action
  void _updateTagValidation(AddressValidationUnion value) {
    tagValidation = value;
  }

  @action
  void _updateAddressIsInternal(bool value) {
    addressIsInternal = value;
  }

  @action
  void _pushWithdrawalAmount(BuildContext context) {
    if (currencyModel != null) {
      /*
      sRouter.push(
        WithdrawalAmountRouter(
          withdrawal: withdrawal!,
          network: networkController.text,
          addressStore: this as WithdrawalAddressStore,
        ),
      );
      */
    } else {
      /*
      sRouter.push(
        WithdrawalPreviewRouter(
          withdrawal: withdrawal!,
          network: networkController.text,
          amountStore: WithdrawalAmountStore(
              withdrawal!, this as WithdrawalAddressStore),
          addressStore: this as WithdrawalAddressStore,
        ),
      );
      */
    }
  }

  @action
  void _pushAllowCamera(BuildContext context) {
    sRouter.push(
      AllowCameraRoute(
        permissionDescription: intl.withdrawalAddress_pushAllowCamera,
        then: () {
          _pushQrView(context: context, fromSettings: true);
        },
      ),
    );
  }

  @computed
  String get bassAsset =>
      currencyModel != null ? currencyModel!.symbol : 'MATIC';

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
    return isReadyToContinue
        ? '${intl.withdrawHint_text1}.'
        : '${intl.withdrawHint_text2}.';
  }

  @action
  void dispose() {
    print('WithdrawalAddressStore DISPOSE');

    addressFocus.dispose();
    tagFocus.dispose();
    addressController.dispose();
    tagController.dispose();
    qrController?.dispose();
  }
}
