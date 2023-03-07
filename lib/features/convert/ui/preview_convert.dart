import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/convert/model/preview_convert_input.dart';
import 'package:jetwallet/features/convert/model/preview_convert_union.dart';
import 'package:jetwallet/features/convert/store/preview_convert_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/price_accuracy.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

class PreviewConvert extends StatefulObserverWidget {
  const PreviewConvert({
    super.key,
    required this.input,
  });

  final PreviewConvertInput input;

  @override
  State<PreviewConvert> createState() => _PreviewConvertState();
}

class _PreviewConvertState extends State<PreviewConvert>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late final PreviewConvertStore store;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);

    store = PreviewConvertStore(widget.input);
    store.updateTimerAnimation(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loader = StackLoaderStore();

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
      header: SMegaHeader(
        crossAxisAlignment: CrossAxisAlignment.center,
        title: store.previewHeader,
        onBackButtonTap: () {
          store.cancelTimer();
          Navigator.pop(context);
        },
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                SActionConfirmIconWithAnimation(
                  iconUrl: widget.input.toCurrency.iconUrl,
                ),
                const Spacer(),
                SActionConfirmText(
                  name: intl.previewConvert_youPay,
                  contentLoading: store.union is QuoteLoading &&
                      widget.input.toAssetEnabled,
                  value: volumeFormat(
                    prefix: from.prefixSymbol,
                    accuracy: from.accuracy,
                    decimal: store.fromAssetAmount ?? Decimal.zero,
                    symbol: from.symbol,
                  ),
                ),
                SActionConfirmText(
                  name: intl.previewConvert_youGet,
                  baseline: 35.0,
                  contentLoading: store.union is QuoteLoading &&
                      !widget.input.toAssetEnabled,
                  value: '≈ ${volumeFormat(
                    prefix: to.prefixSymbol,
                    accuracy: to.accuracy,
                    decimal: store.toAssetAmount ?? Decimal.zero,
                    symbol: to.symbol,
                  )}',
                ),
                SActionConfirmText(
                  name: intl.fee,
                  baseline: 35.0,
                  contentLoading: store.union is QuoteLoading &&
                      !widget.input.toAssetEnabled,
                  value: '${store.feePercent}%',
                ),
                SActionConfirmText(
                  name: intl.previewConvert_exchangeRate,
                  baseline: 34.0,
                  contentLoading: store.union is QuoteLoading,
                  timerLoading: store.union is QuoteLoading,
                  animation: store.timerAnimation,
                  value: '${volumeFormat(
                    prefix: from.prefixSymbol,
                    accuracy: from.accuracy,
                    decimal: Decimal.one,
                    symbol: from.symbol,
                  )} = \n'
                      '${volumeFormat(
                    prefix: to.prefixSymbol,
                    accuracy: accuracy,
                    decimal: store.price ?? Decimal.zero,
                    symbol: to.symbol,
                  )}',
                ),
                const SpaceH36(),
                if (store.connectingToServer) ...[
                  const SActionConfirmAlert(),
                  const SpaceH20(),
                ],
                SPrimaryButton2(
                  active: store.union is QuoteSuccess,
                  name: intl.previewConvert_confirm,
                  onTap: () {
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
