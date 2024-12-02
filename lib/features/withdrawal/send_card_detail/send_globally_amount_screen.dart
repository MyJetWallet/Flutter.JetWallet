import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/suggestion_button_widget.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/store/send_globally_amount_store.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/global_send_methods_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_request_model.dart';

import '../../../core/di/di.dart';
import '../../app/store/app_store.dart';

@RoutePage(name: 'SendGloballyAmountRouter')
class SendGloballyAmountScreen extends StatelessWidget {
  const SendGloballyAmountScreen({
    super.key,
    required this.data,
    required this.method,
  });

  final SendToBankRequestModel data;
  final GlobalSendMethodsModelMethods method;

  @override
  Widget build(BuildContext context) {
    return Provider<SendGloballyAmountStore>(
      create: (context) => SendGloballyAmountStore()..setCardNumber(data, method),
      builder: (context, child) => SendGloballyAmountScreenBody(
        data: data,
        method: method,
      ),
    );
  }
}

class SendGloballyAmountScreenBody extends StatefulObserverWidget {
  const SendGloballyAmountScreenBody({
    super.key,
    required this.data,
    required this.method,
  });

  final SendToBankRequestModel data;
  final GlobalSendMethodsModelMethods method;

  @override
  State<SendGloballyAmountScreenBody> createState() => _SendGloballyAmountScreenBodyState();
}

class _SendGloballyAmountScreenBodyState extends State<SendGloballyAmountScreenBody> {
  @override
  void initState() {
    super.initState();

    final store = SendGloballyAmountStore.of(context);

    sAnalytics.globalSendAmountScreenView(
      asset: widget.data.asset ?? '',
      sendMethodType: '1',
      destCountry: widget.data.countryCode ?? '',
      paymentMethod: store.method?.name ?? '',
      globalSendType: widget.method.methodId ?? '',
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = SendGloballyAmountStore.of(context);

    final balance = store.sendCurrency!.symbol == 'EUR'
        ? (sSignalRModules.bankingProfileData?.simple?.account?.balance ?? Decimal.zero)
        : store.availableBalabce;

    return SPageFrame(
      loading: store.loader,
      loaderText: intl.register_pleaseWait,
      header: GlobalBasicAppBar(
        title: intl.send_globally,
        subtitle: '${intl.withdrawalAmount_available}: '
            '${getIt<AppStore>().isBalanceHide ? '**** ${store.sendCurrency!.symbol}' : balance.toFormatCount(
                accuracy: store.sendCurrency!.accuracy,
                symbol: store.sendCurrency!.symbol,
              )}',
        hasRightIcon: false,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 8,
                  children: [
                    STagButton(
                      lable: intl.withdrawal_you_send,
                      state: store.inputMode == WithdrawalInputMode.youSend
                          ? TagButtonState.selected
                          : TagButtonState.defaultt,
                      onTap: () {
                        if (store.inputMode == WithdrawalInputMode.recepientGets) {
                          store.setInputMode(WithdrawalInputMode.youSend);
                        }
                      },
                    ),
                    STagButton(
                      lable: intl.withdrawal_recipient_gets,
                      state: store.inputMode == WithdrawalInputMode.recepientGets
                          ? TagButtonState.selected
                          : TagButtonState.defaultt,
                      onTap: () {
                        if (store.inputMode == WithdrawalInputMode.youSend) {
                          store.setInputMode(WithdrawalInputMode.recepientGets);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          SNumericLargeInput(
            primaryAmount: formatCurrencyStringAmount(
              value: store.withAmount,
            ),
            primarySymbol: store.inputMode == WithdrawalInputMode.youSend
                ? store.sendCurrency!.symbol
                : store.receiveCurrencyAsset ?? '',
            onSwap: () {},
            showSwopButton: false,
            showMaxButton: true,
            onMaxTap: store.onSendAll,
            errorText: store.withAmmountInputError.isActive
                ? store.withAmmountInputError == InputError.limitError
                    ? store.limitError
                    : store.withAmmountInputError.value()
                : null,
            pasteLabel: intl.paste,
            onPaste: () async {
              final data = await Clipboard.getData('text/plain');
              if (data?.text != null) {
                final n = double.tryParse(data!.text!);
                if (n != null) {
                  store.pasteAmount(n.toString().trim());
                }
              }
            },
          ),
          const Spacer(),
          SuggestionButtonWidget(
            title: widget.method.name ?? '',
            subTitle: intl.iban_out_sent_to,
            icon: NetworkIconWidget(
              iconForPaymentMethod(
                methodId: store.method?.methodId ?? '',
              ),
              placeholder: const SizedBox(),
            ),
            showArrow: false,
            onTap: () {},
          ),
          SNumericKeyboard(
            onKeyPressed: (value) {
              store.updateAmount(value);
            },
            button: SButton.black(
              text: intl.addCircleCard_continue,
              callback: (store.withValid && store.withAmmountInputError == InputError.none)
                  ? () {
                      sAnalytics.globalSendContinueAmountSc(
                        asset: widget.data.asset ?? '',
                        sendMethodType: '1',
                        destCountry: widget.data.countryCode ?? '',
                        paymentMethod: store.method?.name ?? '',
                        globalSendType: widget.method.methodId ?? '',
                        totalSendAmount: store.withAmount,
                      );

                      store.loadPreview();
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget getNetworkIcon(BuildContext context) {
    switch (SendGloballyAmountStore.of(context).cardNetwork) {
      case CircleCardNetwork.VISA:
        return const SVisaCardIcon(
          width: 40,
          height: 25,
        );
      case CircleCardNetwork.MASTERCARD:
        return const SMasterCardIcon(
          width: 40,
          height: 25,
        );
      default:
        return SizedBox(
          width: 40,
          height: 25,
          child: Center(
            child: SActionDepositIcon(
              color: SColorsLight().blue,
            ),
          ),
        );
    }
  }
}
