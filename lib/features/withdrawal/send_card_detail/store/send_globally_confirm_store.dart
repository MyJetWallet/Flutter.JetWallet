import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/rate_up/show_rate_up_popup.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/global_send_methods_model.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_card_response.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_request_model.dart';

part 'send_globally_confirm_store.g.dart';

class ReceiverDetailModel {
  ReceiverDetailModel(
    this.info,
    this.value,
  );

  final FieldInfo info;
  final String value;
}

class SendGloballyConfirmStore extends _SendGloballyConfirmStoreBase with _$SendGloballyConfirmStore {
  SendGloballyConfirmStore() : super();

  static SendGloballyConfirmStore of(BuildContext context) =>
      Provider.of<SendGloballyConfirmStore>(context, listen: false);
}

abstract class _SendGloballyConfirmStoreBase with Store {
  StackLoaderStore loader = StackLoaderStore();

  SendToBankCardResponse? data;
  GlobalSendMethodsModelMethods? method;

  @observable
  ObservableList<ReceiverDetailModel> receiverDetails = ObservableList.of([]);

  @observable
  String? sendCurrencyAsset;
  @computed
  CurrencyModel? get sendCurrency => sendCurrencyAsset != null
      ? currencyFrom(
          sSignalRModules.currenciesList,
          sendCurrencyAsset!,
        )
      : null;

  @action
  void init(SendToBankCardResponse val, GlobalSendMethodsModelMethods m) {
    sAnalytics.globalSendOrderSV(
      asset: val.asset ?? '',
      sendMethodType: '1',
      destCountry: val.countryCode ?? '',
      paymentMethod: m.name ?? '',
      globalSendType: m.methodId ?? '',
      totalSendAmount: (val.amount ?? Decimal.zero).toString(),
    );

    data = val;
    method = m;

    sendCurrencyAsset = val.asset;

    final obj = sSignalRModules.globalSendMethods!.descriptions!.firstWhere(
      (element) => element.type == m.type,
    );

    for (var i = 0; i < obj.fields!.length; i++) {
      receiverDetails.add(
        ReceiverDetailModel(
          obj.fields![i],
          getValueFromData(val, obj.fields![i].fieldId!),
        ),
      );
    }
  }

  String getValueFromData(SendToBankCardResponse val, FieldInfoId id) {
    switch (id) {
      case FieldInfoId.cardNumber:
        return val.cardNumber ?? '';
      case FieldInfoId.iban:
        return val.iban ?? '';
      case FieldInfoId.phoneNumber:
        return val.phoneNumber ?? '';
      case FieldInfoId.recipientName:
        return val.recipientName ?? '';
      case FieldInfoId.panNumber:
        return val.panNumber ?? '';
      case FieldInfoId.upiAddress:
        return val.upiAddress ?? '';
      case FieldInfoId.accountNumber:
        return val.accountNumber ?? '';
      case FieldInfoId.beneficiaryName:
        return val.beneficiaryName ?? '';
      case FieldInfoId.bankName:
        return val.bankName ?? '';
      case FieldInfoId.bankAccount:
        return val.bankAccount ?? '';
      case FieldInfoId.ifscCode:
        return val.ifscCode ?? '';
      case FieldInfoId.wise:
        return val.wise ?? '';
      case FieldInfoId.tin:
        return val.tin ?? '';
      default:
        return '';
    }
  }

  Future<void> confirmSendGlobally({required String newPin}) async {
    loader.startLoadingImmediately();

    sAnalytics.globalSendLoadingSV(
      asset: data?.asset ?? '',
      sendMethodType: '1',
      destCountry: data?.countryCode ?? '',
      paymentMethod: method?.name ?? '',
      globalSendType: method?.methodId ?? '',
      totalSendAmount: (data?.amount ?? Decimal.zero).toString(),
    );

    Future.delayed(
      const Duration(seconds: 40),
      () {
        loader.finishLoadingImmediately();
      },
    );

    final model = SendToBankRequestModel(
      countryCode: data?.countryCode,
      asset: data?.asset,
      amount: data?.amount,
      methodId: method!.methodId ?? '',
      cardNumber: data?.cardNumber,
      iban: data?.iban,
      phoneNumber: data?.phoneNumber,
      recipientName: data?.recipientName,
      panNumber: data?.panNumber,
      upiAddress: data?.upiAddress,
      accountNumber: data?.accountNumber,
      beneficiaryName: data?.beneficiaryName,
      bankName: data?.bankName,
      ifscCode: data?.ifscCode,
      bankAccount: data?.bankAccount,
      wise: data?.wise,
      tin: data?.tin,
      pin: newPin,
    );

    try {
      final response = await getIt.get<SNetwork>().simpleNetworking.getWalletModule().sendToBankCard(
            model,
          );

      loader.finishLoadingImmediately();

      if (response.hasError) {
        loader.finishLoadingImmediately();
        await showFailureScreen(response.error?.cause ?? '');
      } else {
        await showSuccessScreen(model);
      }
    } catch (e) {
      loader.finishLoadingImmediately();
      await showFailureScreen(intl.something_went_wrong_try_again);
    } finally {
      loader.finishLoadingImmediately();
    }

    loader.finishLoadingImmediately();
  }

  @action
  Future<void> showFailureScreen(String error) {
    sAnalytics.globalSendFailedSV(
      asset: data?.asset ?? '',
      sendMethodType: '1',
      destCountry: data?.countryCode ?? '',
      paymentMethod: method?.name ?? '',
      globalSendType: method?.methodId ?? '',
      totalSendAmount: (data?.amount ?? Decimal.zero).toString(),
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
  Future<void> showSuccessScreen(SendToBankRequestModel model) {
    sAnalytics.globalSendSuccessSV(
      asset: data?.asset ?? '',
      sendMethodType: '1',
      destCountry: data?.countryCode ?? '',
      paymentMethod: method?.name ?? '',
      globalSendType: method?.methodId ?? '',
      totalSendAmount: (data?.amount ?? Decimal.zero).toString(),
    );

    return sRouter
        .push(
      SuccessScreenRouter(
        primaryText: intl.send_globally_success,
        secondaryText: '${intl.send_globally_success_secondary} ${(model.amount ?? Decimal.zero).toFormatCount(
          accuracy: sendCurrency!.accuracy,
          symbol: sendCurrency!.symbol,
        )}'
            '\n${intl.send_globally_success_secondary_2}',
        bottomWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: SAccountWaitingIcon(
                color: sKit.colors.grey2,
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                intl.send_globally_success_info,
                style: sBodyText1Style.copyWith(
                  fontSize: 12,
                  color: sKit.colors.grey2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .then((value) {
      sRouter.replaceAll([
        const HomeRouter(
          children: [
            MyWalletsRouter(),
          ],
        ),
      ]);

      shopRateUpPopup(sRouter.navigatorKey.currentContext!);
    });
  }
}
