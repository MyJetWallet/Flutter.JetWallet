import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_address_store.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_amount_store.dart';
import 'package:jetwallet/utils/formatting/base/market_format.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../helper/user_will_receive.dart';
import '../../model/withdrawal_model.dart';

class WithdrawalAmount extends StatelessWidget {
  const WithdrawalAmount({
    super.key,
    required this.withdrawal,
    required this.network,
    required this.addressStore,
  });

  final WithdrawalModel withdrawal;
  final String network;
  final WithdrawalAddressStore addressStore;

  @override
  Widget build(BuildContext context) {
    return Provider<WithdrawalAmountStore>(
      create: (context) => WithdrawalAmountStore(withdrawal, addressStore),
      builder: (context, child) => _WithdrawalAmountBody(
        withdrawal: withdrawal,
        network: network,
        addressStore: addressStore,
      ),
    );
  }
}

class _WithdrawalAmountBody extends StatelessObserverWidget {
  const _WithdrawalAmountBody({
    Key? key,
    required this.withdrawal,
    required this.network,
    required this.addressStore,
  }) : super(key: key);

  final WithdrawalModel withdrawal;
  final String network;
  final WithdrawalAddressStore addressStore;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    final store = WithdrawalAmountStore.of(context);

    final currency = withdrawal.currency;

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: '${withdrawal.dictionary.verb} ${currency!.description}',
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
                      prefix: currency.prefixSymbol,
                      value: store.amount,
                      symbol: currency.symbol,
                    ),
                    helper: '≈ ${marketFormat(
                      accuracy: store.baseCurrency!.accuracy,
                      prefix: store.baseCurrency!.prefix,
                      decimal: Decimal.parse(store.baseConversionValue),
                      symbol: store.baseCurrency!.symbol,
                    )}',
                    error: store.inputError == InputError.enterHigherAmount
                        ? '${intl.withdrawalAmount_enterMoreThan} '
                            '${currency.withdrawalFeeWithSymbol(network)}'
                        : store.inputError.value(),
                    isErrorActive: store.inputError.isActive,
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
                      decimal: Decimal.parse(
                        '${currency.assetBalance.toDouble() - currency.cardReserve.toDouble()}',
                      ),
                      accuracy: currency.accuracy,
                      symbol: currency.symbol,
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
                          store.amount,
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
            description: '${currency.symbol} ${intl.withdrawalAmount_wallet}',
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
            submitButtonActive: store.valid,
            submitButtonName: '${intl.withdrawalAmount_preview}'
                ' ${withdrawal.dictionary.verb}',
            onSubmitPressed: () {
              sAnalytics.sendTapPreview(
                currency: currency.symbol,
                amount: store.amount,
                type: 'By wallet',
                percentage: store.tappedPreset ?? '',
              );

              /*
              sRouter.push(
                WithdrawalPreviewRouter(
                  withdrawal: withdrawal,
                  network: network,
                  amountStore: store as WithdrawalAmountStore,
                  addressStore: addressStore,
                ),
              );
              */
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
    final currency = withdrawal.currency;

    final result = userWillreceive(
      amount: amount,
      currency: currency!,
      addressIsInternal: isInternal,
      network: network,
    );

    final youWillSend = '${intl.withdrawalAmount_youWillSend}: $result';

    return isInternal
        ? '${intl.noFee} / $youWillSend'
        : '${intl.fee}: '
            '${currency.withdrawalFeeWithSymbol(network)} / $youWillSend';
  }
}
