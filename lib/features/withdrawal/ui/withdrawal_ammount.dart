import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';

import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/di/di.dart';
import '../../app/store/app_store.dart';

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
    final colors = sKit.colors;

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
      header: SPaddingH24(
        child: SSmallHeader(
          title: '''${intl.withdrawal_send_verb} ${store.withdrawalInputModel!.currency!.description}''',
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
                      value: store.withAmount,
                      symbol: store.withdrawalInputModel!.currency!.symbol,
                    ),
                    helper: '≈ ${Decimal.parse(store.baseConversionValue).toFormatSum(
                      accuracy: store.baseCurrency.accuracy,
                      symbol: store.baseCurrency.symbol,
                    )}',
                    error: error,
                    isErrorActive: store.withAmmountInputError.isActive,
                    errorMaxLines: deviceSize.when(
                      small: () => 1,
                      medium: () => 2,
                    ),
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
                ),
                if (store.withAmmountInputError != InputError.notEnoughBalanceToCoverFee)
                  Baseline(
                    baseline: deviceSize.when(
                      small: () => -36,
                      medium: () => 20,
                    ),
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      '${intl.withdrawalAmount_available}: '
                      '${getIt<AppStore>().isBalanceHide ? '**** ${store.withdrawalInputModel!.currency!.symbol}' : (store.availableBalance < Decimal.zero ? Decimal.zero : store.availableBalance).toFormatCount(
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
                          context: context,
                          feeAmount: store.feeAmount,
                          youWillSendAmount: store.youWillSendAmount,
                          currency: store.currency,
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
            description: '''${store.withdrawalInputModel!.currency!.symbol} ${intl.withdrawalAmount_wallet}''',
          ),
          deviceSize.when(
            small: () => const Spacer(),
            medium: () => const SpaceH20(),
          ),
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

  String _feeDescription({
    required BuildContext context,
    required Decimal feeAmount,
    required Decimal youWillSendAmount,
    required CurrencyModel currency,
  }) {
    final feeAmountFormated = feeAmount.toFormatCount(
      symbol: currency.symbol,
      accuracy: currency.accuracy,
    );

    final youWillSend = '${intl.withdrawalAmount_youWillSend}: ${youWillSendAmount.toFormatCount(
      symbol: currency.symbol,
      accuracy: currency.accuracy,
    )}';

    return '${intl.fee}: $feeAmountFormated / $youWillSend';
  }
}
