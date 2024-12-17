import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/buy_flow/store/buy_confirmation_store.dart';
import 'package:jetwallet/features/buy_flow/ui/buy_tab_body.dart';
import 'package:jetwallet/utils/formatting/base/decimal_extension.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/confirm_timer/simple_confirm_action_timer.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';

class ConfirmationInfoGrid extends StatefulObserverWidget {
  const ConfirmationInfoGrid({
    super.key,
    this.paymentFee,
    this.ourFee,
    required this.totalValue,
    required this.paymentCurrency,
    required this.asset,
  });

  final String? paymentFee;
  final String? ourFee;

  final String totalValue;
  final CurrencyModel paymentCurrency;
  final CurrencyModel asset;

  @override
  State<ConfirmationInfoGrid> createState() => _ConfirmationInfoGridState();
}

class _ConfirmationInfoGridState extends State<ConfirmationInfoGrid> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);

    final store = BuyConfirmationStore.of(context);

    store.updateTimerAnimation(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget textPreloader() {
    return Baseline(
      baseline: 19.0,
      baselineType: TextBaseline.alphabetic,
      child: SSkeletonLoader(
        height: 24,
        width: 120,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = BuyConfirmationStore.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SDivider(),
        const SizedBox(height: 19),
        SizedBox(
          height: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                intl.buy_confirmation_paid_with,
                style: STStyles.body2Medium.copyWith(color: SColorsLight().gray10),
              ),
              const SpaceW8(),
              if (store.isDataLoaded) ...[
                if (store.category == PaymentMethodCategory.cards) ...[
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 32,
                          height: 20,
                          child: getNetworkIcon(store.card?.network),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  store.card?.cardLabel ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  style: STStyles.subtitle2,
                                ),
                              ),
                              Text(
                                ' •• ${store.card?.last4 ?? ''}',
                                overflow: TextOverflow.ellipsis,
                                style: STStyles.subtitle2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (store.category == PaymentMethodCategory.account) ...[
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SpaceW19(),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: SColorsLight().blue,
                            shape: BoxShape.circle,
                          ),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: SBankMediumIcon(color: SColorsLight().white),
                          ),
                        ),
                        const SpaceW8(),
                        Flexible(
                          child: Text(
                            store.account?.label ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: STStyles.subtitle2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ] else ...[
                textPreloader(),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              intl.buy_confirmation_price,
              style: STStyles.body2Medium.copyWith(color: SColorsLight().gray10),
            ),
            const Spacer(),
            if (store.isDataLoaded) ...[
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Baseline(
                  baseline: 16,
                  baselineType: TextBaseline.alphabetic,
                  child: SConfirmActionTimer(
                    animation: store.timerAnimation!,
                    loading: store.timerLoading,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${Decimal.one.toFormatCount(
                  accuracy: widget.asset.accuracy,
                  symbol: widget.asset.symbol,
                )} = ${(store.rate ?? Decimal.zero).toFormatPrice(
                  accuracy: store.rate?.scale ?? 0,
                  prefix: widget.paymentCurrency.prefixSymbol,
                )}',
                style: STStyles.subtitle2,
              ),
            ] else ...[
              textPreloader(),
            ],
          ],
        ),
        const SizedBox(height: 16),
        if (widget.paymentFee != null) ...[
          PaymentFeeRowWidget(
            fee: widget.paymentFee ?? '',
            onTabListener: () {
              sAnalytics.tapOnTheButtonPaymentFeeInfoOnBuyCheckout();
              sAnalytics.paymentProcessingFeePopupView(
                pmType: store.pmType,
                buyPM: store.buyPM,
                sourceCurrency: 'EUR',
                destinationWallet: store.buyAsset ?? '',
                sourceBuyAmount: store.paymentAmount.toString(),
                destinationBuyAmount: store.buyAmount.toString(),
                feeType: FeeType.payment,
              );
            },
            isLoaded: store.isDataLoaded,
            onBotomSheetClose: (_) {},
          ),
        ],
        const SizedBox(height: 16),
        if (widget.ourFee != null) ...[
          ProcessingFeeRowWidget(
            fee: widget.ourFee ?? '',
            onTabListener: () {
              sAnalytics.tapOnTheButtonPaymentFeeInfoOnBuyCheckout();
              sAnalytics.paymentProcessingFeePopupView(
                pmType: store.pmType,
                buyPM: store.buyPM,
                sourceCurrency: 'EUR',
                destinationWallet: store.buyAsset ?? '',
                sourceBuyAmount: store.paymentAmount.toString(),
                destinationBuyAmount: store.buyAmount.toString(),
                feeType: FeeType.processing,
              );
            },
            isLoaded: store.isDataLoaded,
            onBotomSheetClose: (_) {},
          ),
        ],
      ],
    );
  }
}
