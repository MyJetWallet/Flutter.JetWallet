import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/features/p2p_buy/store/buy_p2p_confirmation_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/confirm_timer/simple_confirm_action_timer.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class BuyP2PConfirmationInfoGrid extends StatefulObserverWidget {
  const BuyP2PConfirmationInfoGrid({
    super.key,
    this.paymentFee,
    this.ourFee,
    required this.asset,
  });

  final String? paymentFee;
  final String? ourFee;

  final CurrencyModel asset;

  @override
  State<BuyP2PConfirmationInfoGrid> createState() => _ConfirmationInfoGridState();
}

class _ConfirmationInfoGridState extends State<BuyP2PConfirmationInfoGrid> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);

    final store = BuyP2PConfirmationStore.of(context);

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
    final store = BuyP2PConfirmationStore.of(context);

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
              if (store.isDataLoaded) ...[
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SpaceW19(),
                      NetworkIconWidget(
                        iconForPaymentMethod(
                          methodId: store.p2pMethod?.methodId ?? '',
                        ),
                      ),
                      const SpaceW8(),
                      Flexible(
                        child: Text(
                          store.p2pMethod?.name ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: STStyles.subtitle2,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                textPreloader(),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Builder(
          builder: (context) {
            final paymentCurrency = getIt.get<FormatService>().findCurrency(
                  findInHideTerminalList: true,
                  assetSymbol: store.paymentAsset?.asset ?? '',
                );

            final prefix = paymentCurrency.prefixSymbol;
            final sumbol = store.paymentAsset?.asset;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  intl.p2p_buy_conversion_rate,
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
                    )} = ${prefix != null ? (store.rate ?? Decimal.zero).toFormatPrice(
                        prefix: prefix,
                      ) : (store.rate ?? Decimal.zero).toFormatCount(
                        symbol: sumbol,
                      )}',
                    style: STStyles.subtitle2,
                  ),
                ] else ...[
                  textPreloader(),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        if (widget.paymentFee != null) ...[
          PaymentFeeRowWidget(
            fee: widget.paymentFee ?? '',
            isLoaded: store.isDataLoaded,
            onTabListener: () {
              sAnalytics.tapOnTheButtonPaymentFeeInfoOnBuyCheckout();
              sAnalytics.paymentProcessingFeePopupView(
                feeType: FeeType.payment,
                pmType: PaymenthMethodType.ptp,
                buyPM: 'PTP',
                sourceCurrency: store.paymentAsset?.asset ?? '',
                destinationWallet: store.buyAsset ?? '',
                sourceBuyAmount: store.paymentAmount.toString(),
                destinationBuyAmount: store.buyAmount.toString(),
              );
            },
          ),
        ],
        const SizedBox(height: 16),
        if (widget.ourFee != null) ...[
          ProcessingFeeRowWidget(
            fee: widget.ourFee ?? '',
            isLoaded: store.isDataLoaded,
            onTabListener: () {
              sAnalytics.tapOnTheButtonPaymentFeeInfoOnBuyCheckout();
              sAnalytics.paymentProcessingFeePopupView(
                feeType: FeeType.processing,
                pmType: PaymenthMethodType.ptp,
                buyPM: 'PTP',
                sourceCurrency: store.paymentAsset?.asset ?? '',
                destinationWallet: store.buyAsset ?? '',
                sourceBuyAmount: store.paymentAmount.toString(),
                destinationBuyAmount: store.buyAmount.toString(),
              );
            },
          ),
        ],
      ],
    );
  }
}
