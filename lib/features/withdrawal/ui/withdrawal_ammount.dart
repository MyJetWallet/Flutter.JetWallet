import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/suggestion_button_widget.dart';

import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'WithdrawalAmmountRouter')
class WithdrawalAmmountScreen extends StatefulObserverWidget {
  const WithdrawalAmmountScreen({super.key});

  @override
  State<WithdrawalAmmountScreen> createState() => _WithdrawalAmmountScreenState();
}

class _WithdrawalAmmountScreenState extends State<WithdrawalAmmountScreen> {
  bool isLoading = false;

  @override
  void initState() {
    final store = WithdrawalStore.of(context);

    if (store.withdrawalType != WithdrawalType.jar) {
      sAnalytics.cryptoSendAssetNameAmountScreenView(
        asset: store.withdrawalInputModel!.currency!.symbol,
        network: store.network.description,
        sendMethodType: '0',
      );
    }

    store.initWithdrawalAmountScreen();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final store = WithdrawalStore.of(context);

    final deviceSize = sDeviceSize;
    final colors = SColorsLight();

    final String error;

    switch (store.withAmmountInputError) {
      case InputError.enterHigherAmount:
        error =
            '''${intl.withdrawalAmount_enterMoreThan} ${store.withdrawalInputModel!.currency!.withdrawalFeeWithSymbol(network: store.networkController.text, amount: store.maxLimit ?? Decimal.zero)}''';
      case InputError.limitError:
        error = store.limitError;
      default:
        error = store.withAmmountInputError.value();
    }

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: GlobalBasicAppBar(
        title: '''${intl.withdrawal_send_verb} ${store.withdrawalInputModel!.currency!.description}''',
        hasRightIcon: false,
        subtitle:
            '${intl.withdrawalAmount_available}: ${getIt<AppStore>().isBalanceHide ? '**** ${store.withdrawalInputModel!.currency!.symbol}' : (store.availableBalance < Decimal.zero ? Decimal.zero : store.availableBalance).toFormatCount(
                accuracy: store.withdrawalInputModel!.currency!.accuracy,
                symbol: store.withdrawalInputModel!.currency!.symbol,
              )}',
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
                        store.setInputMode(WithdrawalInputMode.youSend);
                      },
                    ),
                    STagButton(
                      lable: intl.withdrawal_recipient_gets,
                      state: store.inputMode == WithdrawalInputMode.recepientGets
                          ? TagButtonState.selected
                          : TagButtonState.defaultt,
                      onTap: () {
                        store.setInputMode(WithdrawalInputMode.recepientGets);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          deviceSize.when(
            small: () => const SizedBox(),
            medium: () => const Spacer(),
          ),
          SNumericLargeInput(
            primaryAmount: formatCurrencyStringAmount(
              value: store.primaryAmount,
            ),
            primarySymbol: store.primarySymbol,
            secondaryAmount: '${intl.earn_est} ${Decimal.parse(store.secondaryAmount).toFormatSum(
              accuracy: store.secondaryAccuracy,
            )}',
            secondarySymbol: store.secondarySymbol,
            showSwopButton: false,
            onSwap: store.onSwap,
            errorText: store.withAmmountInputError.isActive ? error : null,
            showMaxButton: true,
            onMaxTap: store.onSendAll,
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
            subTitle: intl.withdrawOptions_sendTo,
            trailing: shortAddressFormThree(store.address),
            title: '${store.currency.symbol} ${intl.withdrawal_wallet}',
            icon: Assets.svg.other.medium.bankAccount.simpleSvg(),
            onTap: () {},
            showArrow: false,
          ),
          const SpaceH12(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  padding: const EdgeInsets.all(4),
                  decoration: ShapeDecoration(
                    color: colors.gray2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: store.inputMode == WithdrawalInputMode.youSend
                      ? Assets.svg.medium.remove.simpleSvg()
                      : Assets.svg.medium.add.simpleSvg(),
                ),
                const SpaceW12(),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: store.feeAmount.toFormatCount(
                          symbol: store.currency.symbol,
                          accuracy: store.currency.accuracy,
                        ),
                        style: STStyles.body2Semibold,
                      ),
                      TextSpan(
                        text: ' ${intl.buy_confirmation_processing_fee}',
                        style: STStyles.body2Semibold.copyWith(
                          color: colors.gray10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SpaceH8(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Row(
              children: [
                NetworkIconWidget(
                  width: 20,
                  height: 20,
                  store.currency.iconUrl,
                ),
                const SpaceW12(),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: store.inputMode == WithdrawalInputMode.youSend
                            ? store.recepientGetsAmount.toFormatCount(
                                symbol: store.currency.symbol,
                                accuracy: store.currency.accuracy,
                              )
                            : store.youSendAmount.toFormatCount(
                                symbol: store.currency.symbol,
                                accuracy: store.currency.accuracy,
                              ),
                        style: STStyles.body2Semibold,
                      ),
                      TextSpan(
                        text:
                            ' ${store.inputMode == WithdrawalInputMode.youSend ? intl.withdrawal_recipient_gets : intl.withdrawal_you_send}',
                        style: STStyles.body2Semibold.copyWith(
                          color: colors.gray10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SpaceH8(),
          SNumericKeyboardAmount(
            widgetSize: widgetSizeFrom(deviceSize),
            onKeyPressed: (value) {
              store.updateAmount(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: store.withValid,
            submitButtonName: intl.withdraw_continue,
            isLoading: isLoading,
            onSubmitPressed: () async {
              setState(() {
                isLoading = true;
              });
              if (store.withdrawalType != WithdrawalType.jar) {
                sAnalytics.cryptoSendTapContinueAmountScreen(
                  asset: store.withdrawalInputModel!.currency!.symbol,
                  network: store.network.description,
                  sendMethodType: '0',
                  totalSendAmount: store.withAmount,
                );
              }

              await store.getWithdrawalFeeByPreview();

              store.withdrawalPush(WithdrawStep.preview);
              setState(() {
                isLoading = false;
              });
            },
          ),
        ],
      ),
    );
  }
}
