import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../helpers/formatting/formatting.dart';
import '../../wallet/helper/format_date_to_hm.dart';
import '../model/preview_high_yield_buy_input.dart';
import '../notifier/preview_high_yield_buy_notifier/preview_high_yield_buy_notipod.dart';
import '../notifier/preview_high_yield_buy_notifier/preview_high_yield_buy_state.dart';
import '../notifier/preview_high_yield_buy_notifier/preview_high_yield_buy_union.dart';

class PreviewHighYieldBuy extends StatefulHookWidget {
  const PreviewHighYieldBuy({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewHighYieldBuyInput input;

  @override
  State<PreviewHighYieldBuy> createState() => _PreviewHighYieldBuy();
}

class _PreviewHighYieldBuy extends State<PreviewHighYieldBuy> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = useProvider(deviceSizePod);
    final colors = useProvider(sColorPod);
    final state = useProvider(previewHighYieldBuyNotipod(widget.input));
    final notifier =
        useProvider(previewHighYieldBuyNotipod(widget.input).notifier);
    final loader = useValueNotifier(StackLoaderNotifier());

    final from = widget.input.fromCurrency;

    return ProviderListener<PreviewHighYieldBuyState>(
      provider: previewHighYieldBuyNotipod(widget.input),
      onChange: (_, value) {
        if (value.union is ExecuteLoading) {
          loader.value.startLoading();
        } else {
          if (loader.value.value) {
            loader.value.finishLoading();
          }
        }
      },
      child: SPageFrameWithPadding(
        loading: loader.value,
        header: deviceSize.when(
          small: () {
            return SSmallHeader(
              title: 'Confirm ${widget.input.earnOffer.title}',
            );
          },
          medium: () {
            return SMegaHeader(
              title: 'Confirm ${widget.input.earnOffer.title}',
              crossAxisAlignment: CrossAxisAlignment.center,
            );
          },
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  deviceSize.when(
                    small: () => const SpaceH24(),
                    medium: () => const SpaceH8(),
                  ),
                  Center(
                    child: SActionConfirmIconWithAnimation(
                      iconUrl: widget.input.fromCurrency.iconUrl,
                    ),
                  ),
                  const Spacer(),
                  SActionConfirmText(
                    name: 'Subscription amount',
                    value: volumeFormat(
                      prefix: from.prefixSymbol,
                      accuracy: from.accuracy,
                      decimal: state.fromAssetAmount ?? Decimal.zero,
                      symbol: from.symbol,
                    ),
                  ),
                  SActionConfirmText(
                    contentLoading: state.union is QuoteLoading,
                    name: 'APY',
                    baseline: 35.0,
                    value: '${state.apy}%',
                  ),
                  if (widget.input.earnOffer.endDate != null)
                    SActionConfirmText(
                      name: 'Expiry date',
                      baseline: 35.0,
                      value: formatDateToDMonthYFromDate(
                        widget.input.earnOffer.endDate!,
                      ),
                    )
                  else
                    SActionConfirmText(
                      name: 'Term',
                      baseline: 35.0,
                      value: widget.input.earnOffer.title,
                    ),
                  deviceSize.when(
                    small: () => const SpaceH6(),
                    medium: () => const SpaceH34(),
                  ),
                  const SDivider(),
                  SActionConfirmText(
                    name: 'Expected yearly profit',
                    contentLoading: state.union is QuoteLoading,
                    baseline: 40,
                    maxValueWidth: 170,
                    minValueWidth: 170,
                    value: marketFormat(
                      prefix: widget.input.fromCurrency.prefixSymbol,
                      decimal: state.expectedYearlyProfit ?? Decimal.zero,
                      accuracy: widget.input.fromCurrency.accuracy,
                      symbol: widget.input.fromCurrency.symbol,
                    ),
                  ),
                  if (state.union is QuoteLoading) const SpaceH6(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: state.union is QuoteLoading
                        ? Container(
                            padding: const EdgeInsets.only(
                              top: 2,
                            ),
                            margin: const EdgeInsets.only(
                              bottom: 4,
                            ),
                            child: const SSkeletonTextLoader(
                              height: 8,
                              width: 100,
                            ),
                          )
                        : Text(
                            'approx. ${marketFormat(
                              prefix: '\$',
                              decimal: state.expectedYearlyProfitBase ??
                                  Decimal.zero,
                              accuracy: 2,
                              symbol: 'USD',
                            )}',
                            style: sBodyText2Style.copyWith(
                              color: colors.grey1,
                            ),
                          ),
                  ),
                  const SpaceH12(),
                  Text(
                    'You can return funds to your wallet at any time. '
                    '\nIt normally takes up to 24 hours.',
                    textAlign: TextAlign.start,
                    style: sCaptionTextStyle.copyWith(color: colors.grey1),
                    maxLines: 4,
                  ),
                  const SpaceH36(),
                  SPrimaryButton2(
                    active: true,
                    name: 'Confirm',
                    onTap: () {
                      notifier.earnOfferDeposit(widget.input.earnOffer.offerId);
                    },
                  ),
                  const SpaceH24(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
