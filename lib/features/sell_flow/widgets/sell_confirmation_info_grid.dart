import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/sell_flow/store/sell_confirmation_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

class SellConfirmationInfoGrid extends StatefulObserverWidget {
  const SellConfirmationInfoGrid({
    super.key,
    this.paymentFee,
    this.ourFee,
    required this.totalValue,
    required this.paymentCurrency,
    required this.asset,
    this.account,
    this.simpleCard,
  });

  final String? paymentFee;
  final String? ourFee;

  final String totalValue;
  final CurrencyModel paymentCurrency;
  final CurrencyModel asset;
  final SimpleBankingAccount? account;
  final CardDataModel? simpleCard;

  @override
  State<SellConfirmationInfoGrid> createState() => _ConfirmationInfoGridState();
}

class _ConfirmationInfoGridState extends State<SellConfirmationInfoGrid> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);

    final store = SellConfirmationStore.of(context);

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
    final store = SellConfirmationStore.of(context);

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
                intl.sell_confirmation_sell_to,
                style: sBodyText2Style.copyWith(color: sKit.colors.grey1),
              ),
              if (store.isDataLoaded) ...[
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SpaceW19(),
                      if (widget.simpleCard != null)
                        Assets.svg.assets.fiat.cardAlt.simpleSvg(
                          width: 24,
                        )
                      else
                        Assets.svg.other.medium.bankAccount.simpleSvg(
                          width: 24,
                        ),
                      const SpaceW8(),
                      Flexible(
                        child: Text(
                          widget.account?.label ?? widget.simpleCard?.label ?? '',
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
              intl.buy_confirmation_price,
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
                  symbol: widget.paymentCurrency.symbol,
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
              sAnalytics.paymentProcessingFeeSellPopupView(
                feeType: FeeType.payment,
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
              sAnalytics.paymentProcessingFeeSellPopupView(
                feeType: FeeType.processing,
              );
            },
          ),
        ],
        const SizedBox(height: 19),
        const SDivider(),
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
