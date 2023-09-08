import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/withdrawal/helper/user_will_receive.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';

@RoutePage(name: 'WithdrawalAmmountRouter')
class WithdrawalAmmountScreen extends StatefulObserverWidget {
  const WithdrawalAmmountScreen({super.key});

  @override
  State<WithdrawalAmmountScreen> createState() =>
      _WithdrawalAmmountScreenState();
}

class _WithdrawalAmmountScreenState extends State<WithdrawalAmmountScreen> {
  @override
  void initState() {
    final store = WithdrawalStore.of(context);

    sAnalytics.cryptoSendAssetNameAmountScreenView(
      asset: store.withdrawalInputModel!.currency!.symbol,
      network: store.network.description,
      sendMethodType: '0',
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final store = WithdrawalStore.of(context);

    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    var availableCurrency = currencyFrom(
      sSignalRModules.currenciesList,
      store.withdrawalInputModel!.currency!.symbol,
    );

    final availableBalance = Decimal.parse(
      //availableCurrency.assetBalance.toString(),
      '${availableCurrency.assetBalance.toDouble() - availableCurrency.cardReserve.toDouble()}',
      //'${store.withdrawalInputModel!.currency!.assetBalance.toDouble() - store.withdrawalInputModel!.currency!.cardReserve.toDouble()}',
    );

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title:
              '${intl.withdrawal_send_verb} ${store.withdrawalInputModel!.currency!.description}',
        ),
      ),
      child: Column(
        children: [
          deviceSize.when(
            small: () => const SizedBox(),
            medium: () => const Spacer(),
          ),
          SizedBox(
            height: deviceSize.when(
              small: () => 116,
              medium: () => 152,
            ),
            child: Column(
              children: [
                Baseline(
                  baseline: deviceSize.when(
                    small: () => 20,
                    medium: () => 48,
                  ),
                  baselineType: TextBaseline.alphabetic,
                  child: SActionPriceField(
                    widgetSize: widgetSizeFrom(deviceSize),
                    price: formatCurrencyStringAmount(
                      prefix:
                          store.withdrawalInputModel?.currency?.prefixSymbol,
                      value: store.withAmount,
                      symbol: store.withdrawalInputModel!.currency!.symbol,
                    ),
                    helper: '≈ ${marketFormat(
                      accuracy: store.baseCurrency.accuracy,
                      prefix: store.baseCurrency.prefix,
                      decimal: Decimal.parse(store.baseConversionValue),
                      symbol: store.baseCurrency.symbol,
                    )}',
                    error: store.withAmmountInputError ==
                            InputError.enterHigherAmount
                        ? '${intl.withdrawalAmount_enterMoreThan} '
                            '${store.withdrawalInputModel!.currency!.withdrawalFeeWithSymbol(store.networkController.text)}'
                        : store.withAmmountInputError.value(),
                    isErrorActive: store.withAmmountInputError.isActive,
                  ),
                ),
                Baseline(
                  baseline: deviceSize.when(
                    small: () => -36,
                    medium: () => 20,
                  ),
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    '${intl.withdrawalAmount_available}: '
                    '${volumeFormat(
                      decimal: availableBalance,
                      accuracy: store.withdrawalInputModel!.currency!.accuracy,
                      symbol: store.withdrawalInputModel!.currency!.symbol,
                    )}',
                    style: sSubtitle3Style.copyWith(
                      color: colors.grey2,
                    ),
                  ),
                ),
                Baseline(
                  baseline: deviceSize.when(
                    small: () => -6,
                    medium: () => 30,
                  ),
                  baselineType: TextBaseline.alphabetic,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SFeeAlertIcon(),
                      const SpaceW10(),
                      Text(
                        _feeDescription(
                          store.addressIsInternal,
                          store.withAmount,
                          context,
                        ),
                        style: sCaptionTextStyle.copyWith(
                          color: colors.grey2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          SPaymentSelectAsset(
            widgetSize: widgetSizeFrom(deviceSize),
            icon: SWalletIcon(
              color: colors.black,
            ),
            name: shortAddressForm(store.address),
            description:
                '${store.withdrawalInputModel!.currency!.symbol} ${intl.withdrawalAmount_wallet}',
          ),
          deviceSize.when(
            small: () => const Spacer(),
            medium: () => const SpaceH20(),
          ),
          SNumericKeyboardAmount(
            widgetSize: widgetSizeFrom(deviceSize),
            preset1Name: '25%',
            preset2Name: '50%',
            preset3Name: intl.max,
            selectedPreset: store.selectedPreset,
            onPresetChanged: (preset) {
              store.tapPreset(
                preset.index == 0
                    ? '25%'
                    : preset.index == 1
                        ? '50%'
                        : 'Max',
              );
              store.selectPercentFromBalance(preset);
            },
            onKeyPressed: (value) {
              store.updateAmount(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: store.withValid,
            submitButtonName: intl.withdraw_continue,
            onSubmitPressed: () {
              sAnalytics.cryptoSendTapContinueAmountScreen(
                asset: store.withdrawalInputModel!.currency!.symbol,
                network: store.network.description,
                sendMethodType: '0',
                totalSendAmount: store.withAmount,
                preset: store.selectedPreset != null
                    ? store.tappedPreset ?? ''
                    : 'false',
              );

              store.withdrawalPush(WithdrawStep.preview);
            },
          ),
        ],
      ),
    );
  }

  String _feeDescription(
    bool isInternal,
    String amount,
    BuildContext context,
  ) {
    final store = WithdrawalStore.of(context);

    final currency = store.withdrawalInputModel!.currency!;

    final result = userWillreceive(
      amount: amount,
      currency: store.withdrawalInputModel!.currency!,
      addressIsInternal: isInternal,
      network: store.networkController.text,
    );

    final youWillSend = '${intl.withdrawalAmount_youWillSend}: $result';

    return isInternal
        ? '${intl.noFee} / $youWillSend'
        : '${intl.fee}: '
            '${currency.withdrawalFeeWithSymbol(store.networkController.text)} / $youWillSend';
  }
}
