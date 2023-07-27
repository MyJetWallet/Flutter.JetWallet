import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/convert/model/preview_convert_input.dart';
import 'package:jetwallet/features/convert/model/preview_convert_union.dart';
import 'package:jetwallet/features/convert/store/preview_convert_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/price_accuracy.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'PreviewConvertRouter')
class PreviewConvert extends StatelessWidget {
  const PreviewConvert({
    super.key,
    required this.input,
  });

  final PreviewConvertInput input;

  @override
  Widget build(BuildContext context) {
    return Provider<PreviewConvertStore>(
      create: (context) => PreviewConvertStore(input),
      builder: (context, child) => PreviewConvertBody(
        input: input,
      ),
      dispose: (context, value) {
        value.cancelTimer();
        value.dispose();
      },
    );
  }
}

class PreviewConvertBody extends StatefulObserverWidget {
  const PreviewConvertBody({
    super.key,
    required this.input,
  });

  final PreviewConvertInput input;

  @override
  State<PreviewConvertBody> createState() => _PreviewConvertBodyState();
}

class _PreviewConvertBodyState extends State<PreviewConvertBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);

    final store = PreviewConvertStore.of(context);

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
    final loader = StackLoaderStore();

    final store = PreviewConvertStore.of(context);

    final from = widget.input.fromCurrency;
    final to = widget.input.toCurrency;

    final accuracy = priceAccuracy(from.symbol, to.symbol);

    if (store.union is ExecuteLoading) {
      loader.startLoading();
    } else {
      if (loader.loading) {
        loader.finishLoading();
      }
    }

    return SPageFrameWithPadding(
      loaderText: intl.register_pleaseWait,
      loading: loader,
      header: SSmallHeader(
        title: intl.buy_confirmation_title,
        onBackButtonTap: () {
          store.cancelTimer();
          sRouter.pop();
        },
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Text(
                  intl.previewBuyWithCircle_youWillGet,
                  textAlign: TextAlign.center,
                  style: sBodyText1Style.copyWith(
                    color: sKit.colors.grey1,
                  ),
                ),
                Text(
                  volumeFormat(
                    prefix: to.prefixSymbol,
                    accuracy: to.accuracy,
                    decimal: store.toAssetAmount ?? Decimal.zero,
                    symbol: to.symbol,
                  ),
                  textAlign: TextAlign.center,
                  style: sTextH4Style.copyWith(
                    color: sKit.colors.blue,
                  ),
                ),
                const SizedBox(height: 25),
                const SDivider(),
                const SizedBox(height: 19),
                SActionConfirmText(
                  baseline: 24,
                  name: intl.previewConvert_youSpend,
                  contentLoading: store.union is QuoteLoading &&
                      widget.input.toAssetEnabled,
                  value: volumeFormat(
                    prefix: from.prefixSymbol,
                    accuracy: from.accuracy,
                    decimal: store.fromAssetAmount ?? Decimal.zero,
                    symbol: from.symbol,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        intl.previewConvert_exchangeRate,
                        style:
                            sBodyText2Style.copyWith(color: sKit.colors.grey1),
                      ),
                      const Spacer(),
                      if (store.union is QuoteSuccess) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Baseline(
                            baseline: 16,
                            baselineType: TextBaseline.alphabetic,
                            child: SConfirmActionTimer(
                              animation: store.timerAnimation!,
                              loading: store.union is QuoteLoading,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${volumeFormat(
                            prefix: from.prefixSymbol,
                            accuracy: from.accuracy,
                            decimal: Decimal.one,
                            symbol: from.symbol,
                          )} = ${volumeFormat(
                            prefix: to.prefixSymbol,
                            accuracy: accuracy,
                            decimal: store.price ?? Decimal.zero,
                            symbol: to.symbol,
                          )}',
                          style: sSubtitle3Style,
                        ),
                      ] else ...[
                        const Baseline(
                          baseline: 19.0,
                          baselineType: TextBaseline.alphabetic,
                          child: SSkeletonTextLoader(
                            height: 16,
                            width: 80,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 11),
                SActionConfirmText(
                  name: intl.fee,
                  baseline: 24,
                  contentLoading: store.union is QuoteLoading &&
                      !widget.input.toAssetEnabled,
                  value: '${store.feePercent}%',
                ),
                const SizedBox(height: 19),
                const SDivider(),
                const SpaceH36(),
                if (store.connectingToServer) ...[
                  const SActionConfirmAlert(),
                  const SpaceH20(),
                ],
                SPrimaryButton2(
                  active: store.union is QuoteSuccess,
                  name: intl.previewConvert_confirm,
                  onTap: () {
                    loader.startLoadingImmediately();
                    store.executeQuote();
                  },
                ),
                const SpaceH24(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
