import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/buy_flow/store/buy_confirmation_store.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/widgets/payment_method_card.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/capitalize_text.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
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

class _ConfirmationInfoGridState extends State<ConfirmationInfoGrid>
    with SingleTickerProviderStateMixin {
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
            children: [
              Text(
                intl.buy_confirmation_payment_method,
                style: sBodyText2Style.copyWith(color: sKit.colors.grey1),
              ),
              if (store.category == PaymentMethodCategory.cards) ...[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 32,
                        height: 20,
                        child: getNetworkIcon(store.card?.network),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          store.card?.cardLabel ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: sSubtitle3Style,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Row(
                  children: [
                    const SpaceW19(),
                    SNetworkCachedSvg(
                      url: iconForPaymentMethod(
                        methodId: store.method?.id.name ?? '',
                      ),
                      width: 20,
                      height: 20,
                      placeholder: MethodPlaceholder(
                        name: capitalizeText(
                          store.method?.id.name ?? '  ',
                        ),
                      ),
                    ),
                    const SpaceW8(),
                    Text(
                      capitalizeText(
                        store.method?.id.name ?? '  ',
                      ),
                      overflow: TextOverflow.ellipsis,
                      style: sSubtitle3Style,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (store.price != Decimal.zero) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                intl.buy_confirmation_buy_confirmation,
                style: sBodyText2Style.copyWith(color: sKit.colors.grey1),
              ),
              const Spacer(),
              if (store.category == PaymentMethodCategory.cards) ...[
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
              ],
              Text(
                '${volumeFormat(
                  prefix: widget.asset.prefixSymbol,
                  accuracy: widget.asset.accuracy,
                  decimal: Decimal.one,
                  symbol: widget.asset.symbol,
                )} = ${volumeFormat(
                  prefix: widget.paymentCurrency.prefixSymbol,
                  accuracy: widget.paymentCurrency.accuracy,
                  decimal: store.price ?? Decimal.zero,
                  symbol: widget.paymentCurrency.symbol,
                )}',
                style: sSubtitle3Style,
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        if (widget.paymentFee != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                intl.buy_confirmation_payment_fee,
                style: sBodyText2Style.copyWith(color: sKit.colors.grey1),
              ),
              if (store.category == PaymentMethodCategory.cards) ...[
                const SpaceW5(),
                GestureDetector(
                  onTap: () {
                    buyConfirmationShowLimit(
                      context,
                      widget.paymentFee ?? '',
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: SInfoIcon(color: sKit.colors.grey1),
                    ),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                widget.paymentFee ?? '',
                style: sSubtitle3Style,
              ),
            ],
          ),
        ],
        const SizedBox(height: 16),
        if (widget.ourFee != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                intl.buy_confirmation_out_fee,
                style: sBodyText2Style.copyWith(color: sKit.colors.grey1),
              ),
              Text(
                widget.ourFee ?? '',
                style: sSubtitle3Style,
              ),
            ],
          ),
        ],
        if (store.category != PaymentMethodCategory.cards) ...[
          const SizedBox(height: 16),
          Text(
            intl.buy_confirmation_local_info,
            maxLines: 5,
            style: sCaptionTextStyle.copyWith(
              color: sKit.colors.grey2,
            ),
          ),
        ],
        const SizedBox(height: 19),
        const SDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                intl.withdrawalPreview_total,
                style: sBodyText2Style.copyWith(color: sKit.colors.grey1),
              ),
              Text(
                widget.totalValue,
                style: sSubtitle3Style.copyWith(color: sKit.colors.blue),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void buyConfirmationShowLimit(BuildContext context, String fee) {
  sShowBasicModalBottomSheet(
    context: context,
    removePinnedPadding: true,
    horizontalPinnedPadding: 0,
    scrollable: true,
    children: [
      SPaddingH24(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  intl.buy_confirmation_transaction_fee,
                  style: sTextH4Style,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const SErasePressedIcon(),
                ),
              ],
            ),
            const SpaceH24(),
            Text(
              fee,
              style: sTextH4Style,
            ),
            const SpaceH4(),
            Text(
              intl.buy_confirmation_third_party_fee,
              style: sBodyText2Style.copyWith(
                color: sKit.colors.grey1,
              ),
            ),
            const SpaceH12(),
            const SDivider(),
            const SpaceH12(),
            Text(
              intl.buy_confirmation_third_fee_descr,
              maxLines: 3,
              style: sCaptionTextStyle.copyWith(
                color: sKit.colors.grey3,
              ),
            ),
            const SpaceH40(),
          ],
        ),
      ),
    ],
  );
}
