import 'package:decimal/decimal.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/features/send_gift/model/send_gift_info_model.dart';
import 'package:jetwallet/features/send_gift/store/receiver_datails_store.dart';
import 'package:jetwallet/utils/helpers/decompose_phone_number.dart';
import 'package:jetwallet/utils/helpers/rate_up/show_rate_up_popup.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/simple_networking.dart';
import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/simple_networking/simple_networking.dart';
import '../../../utils/formatting/base/volume_format.dart';
import '../../../utils/models/currency_model.dart';
import '../widgets/share_gift_result_bottom_sheet.dart';

part 'general_send_gift_store.g.dart';

class GeneralSendGiftStore = GeneralSendGiftStoreBase with _$GeneralSendGiftStore;

abstract class GeneralSendGiftStoreBase with Store {
  StackLoaderStore loader = StackLoaderStore();

  @observable
  CurrencyModel currency = CurrencyModel.empty();

  @observable
  Decimal amount = Decimal.zero;

  ReceiverContacrType selectedContactType = ReceiverContacrType.email;
  String _email = '';

  @observable
  String _phoneBody = '';

  @observable
  String _phoneCountryCode = '';

  @observable
  String receiverContact = '';

  @action
  void init(SendGiftInfoModel sendGiftInfo) {
    _setCurrency(sendGiftInfo.currency ?? CurrencyModel.empty());
    _setReceiverInformation(
      newSelectedContactType: sendGiftInfo.selectedContactType ?? ReceiverContacrType.email,
      email: sendGiftInfo.email,
      newPhoneBody: sendGiftInfo.phoneBody,
      newPhoneCountryCode: sendGiftInfo.phoneCountryCode,
    );
    _updateAmount(sendGiftInfo.amount ?? Decimal.zero);
  }

  @action
  void _setReceiverInformation({
    required ReceiverContacrType newSelectedContactType,
    String? email,
    String? newPhoneBody,
    String? newPhoneCountryCode,
  }) {
    selectedContactType = newSelectedContactType;
    _email = email!;
    _phoneBody = newPhoneBody!;
    _phoneCountryCode = newPhoneCountryCode!;
    switch (selectedContactType) {
      case ReceiverContacrType.email:
        receiverContact = email;
      case ReceiverContacrType.phone:
        receiverContact = _phoneCountryCode + _phoneBody;
    }
  }

  @action
  void _setCurrency(CurrencyModel newCurrency) {
    currency = newCurrency;
    final storageService = getIt.get<LocalStorageService>();
    storageService.setString(
      lastAssetSend,
      newCurrency.symbol,
    );
  }

  @action
  void _updateAmount(Decimal value) {
    amount = value;
  }

  Future<void> confirmSendGift({required String newPin}) async {
    loader.startLoadingImmediately();
    sAnalytics.processingSendScreenView(
      asset: currency.symbol,
      giftSubmethod: selectedContactType.name,
    );

    if (selectedContactType == ReceiverContacrType.email) {
      final model = SendGiftByEmailRequestModel(
        pin: newPin,
        amount: amount,
        assetSymbol: currency.symbol,
        toEmailAddress: _email,
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
      );
      try {
        await getIt.get<SNetwork>().simpleNetworking.getWalletModule().sendGiftByEmail(model);
        await showSuccessScreen();
      } catch (e) {
        loader.finishLoadingImmediately();
        await showFailureScreen(intl.something_went_wrong_try_again);
      }
    } else {
      final number = await decomposePhoneNumber(
        _phoneCountryCode + _phoneBody,
      );

      final model = SendGiftByPhoneRequestModel(
        pin: newPin,
        amount: amount,
        assetSymbol: currency.symbol,
        toPhoneBody: _phoneBody,
        toPhoneCode: _phoneCountryCode,
        toPhoneIso: number.isoCode,
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
      );

      try {
        await getIt.get<SNetwork>().simpleNetworking.getWalletModule().sendGiftByPhone(model);
        await showSuccessScreen();
      } catch (e) {
        loader.finishLoadingImmediately();
        await showFailureScreen(intl.something_went_wrong_try_again);
      }
    }

    loader.finishLoading();
  }

  @action
  Future<void> showFailureScreen(String error) {
    sAnalytics.failedSendScreenView(
      asset: currency.symbol,
      giftSubmethod: selectedContactType.name,
      failedReason: error,
    );

    return sRouter.push(
      FailureScreenRouter(
        primaryText: intl.failed,
        secondaryText: error,
      ),
    );
  }

  @action
  Future<void> showSuccessScreen() {
    sAnalytics.successSendScreenView(
      asset: currency.symbol,
      giftSubmethod: selectedContactType.name,
    );

    return sRouter.push(
      SuccessScreenRouter(
        secondaryText: '${intl.send_gift_you_sent} ${volumeFormat(
          decimal: amount,
          accuracy: currency.accuracy,
          symbol: currency.symbol,
        )}\n${intl.send_gift_success_message_2}',
        onSuccess: (p0) async {
          await sRouter.replaceAll([
            const HomeRouter(
              children: [
                MyWalletsRouter(),
              ],
            ),
          ]);

          await Future.delayed(const Duration(milliseconds: 300), () {
            final context = sRouter.navigatorKey.currentContext!;
            shareGiftResultBottomSheet(
              context: context,
              currency: currency,
              amount: amount,
              email: selectedContactType == ReceiverContacrType.email ? _email : null,
              phoneNumber: selectedContactType == ReceiverContacrType.phone ? (_phoneCountryCode + _phoneBody) : null,
              onClose: () {
                sAnalytics.tapOnTheButtonCloseOrTapInEmptyPlaceForClosingShareSheet();
              },
            );
          });

          await Future.delayed(const Duration(milliseconds: 300), () {
            shopRateUpPopup(sRouter.navigatorKey.currentContext!);
          });
        },
      ),
    );
  }
}
