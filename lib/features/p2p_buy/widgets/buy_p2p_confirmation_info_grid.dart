import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/p2p_buy/store/buy_p2p_confirmation_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

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
      child: SSkeletonTextLoader(
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
                style: sBodyText2Style.copyWith(color: sKit.colors.grey1),
              ),
              if (store.isDataLoaded) ...[
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SpaceW19(),
                      SNetworkCachedSvg(
                        url: iconForPaymentMethod(
                          methodId: store.p2pMethod?.methodId ?? '',
                        ),
                        width: 24,
                        height: 24,
                        placeholder: const SizedBox(),
                      ),
                      const SpaceW8(),
                      Flexible(
                        child: Text(
                          store.p2pMethod?.name ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: sSubtitle3Style.copyWith(height: 1.5),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              intl.p2p_buy_conversion_rate,
              style: sBodyText2Style.copyWith(color: sKit.colors.grey1),
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
                )} = ${(store.rate ?? Decimal.zero).toFormatCount(
                  symbol: store.paymentAsset?.asset ?? '',
                )}',
                style: sSubtitle3Style,
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

void buyConfirmationFeeExplanation({
  required BuildContext context,
  required String title,
  required String fee,
  required String description,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    horizontalPinnedPadding: 24,
    scrollable: true,
    pinned: SBottomSheetHeader(
      name: title,
    ),
    children: [
      SPaddingH24(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceH16(),
            Text(
              fee,
              style: sTextH4Style,
            ),
            const SpaceH12(),
            const SDivider(),
            const SpaceH12(),
            Text(
              description,
              maxLines: 3,
              style: sCaptionTextStyle.copyWith(
                color: sKit.colors.grey3,
              ),
            ),
            const SpaceH64(),
          ],
        ),
      ),
    ],
  );
}
