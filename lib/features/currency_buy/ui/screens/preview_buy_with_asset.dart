import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_asset_input.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_asset_union.dart';
import 'package:jetwallet/features/currency_buy/store/preview_buy_with_asset_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/price_accuracy.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'PreviewBuyWithAssetRouter')
class PreviewBuyWithAsset extends StatelessWidget {
  const PreviewBuyWithAsset({
    super.key,
    this.onBackButtonTap,
    required this.input,
  });

  final PreviewBuyWithAssetInput input;
  final void Function()? onBackButtonTap;

  @override
  Widget build(BuildContext context) {
    return Provider<PreviewBuyWithAssetStore>(
      create: (context) => PreviewBuyWithAssetStore(input),
      builder: (context, child) => _PreviewBuyWithAssetBody(
        input: input,
        onBackButtonTap: onBackButtonTap,
      ),
      dispose: (context, store) => store.dispose(),
    );
  }
}

class _PreviewBuyWithAssetBody extends StatefulObserverWidget {
  const _PreviewBuyWithAssetBody({
    this.onBackButtonTap,
    required this.input,
  });

  final PreviewBuyWithAssetInput input;
  final void Function()? onBackButtonTap;

  @override
  State<_PreviewBuyWithAssetBody> createState() => __PreviewBuyWithAssetBodyState();
}

class __PreviewBuyWithAssetBodyState extends State<_PreviewBuyWithAssetBody> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);

    final notifier = PreviewBuyWithAssetStore.of(context);

    notifier.updateTimerAnimation(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;

    final state = PreviewBuyWithAssetStore.of(context);

    final from = widget.input.fromCurrency;
    final to = widget.input.toCurrency;

    final accuracy = priceAccuracy(from.symbol, to.symbol);

    return ReactionBuilder(
      builder: (context) {
        return reaction<PreviewBuyWithAssetUnion>(
          (_) => state.union,
          (result) {
            if (result is ExecuteLoading) {
              state.loader.startLoading();
            } else {
              if (state.loader.loading) {
                state.loader.finishLoading();
              }
            }
          },
          fireImmediately: true,
        );
      },
      child: SPageFrameWithPadding(
        loaderText: intl.register_pleaseWait,
        loading: state.loader,
        header: deviceSize.when(
          small: () {
            return SSmallHeader(
              title: state.previewHeader,
              onBackButtonTap: widget.onBackButtonTap ??
                  () {
                    state.cancelTimer();
                    Navigator.pop(context);
                  },
            );
          },
          medium: () {
            return SMegaHeader(
              title: state.previewHeader,
              onBackButtonTap: widget.onBackButtonTap ??
                  () {
                    state.cancelTimer();
                    Navigator.pop(context);
                  },
            );
          },
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  deviceSize.when(
                    small: () => const SpaceH8(),
                    medium: () => const SpaceH3(),
                  ),
                  Center(
                    child: SActionConfirmIconWithAnimation(
                      iconUrl: widget.input.toCurrency.iconUrl,
                    ),
                  ),
                  const Spacer(),
                  SActionConfirmText(
                    name: intl.previewBuyWithAsset_youPay,
                    value: volumeFormat(
                      accuracy: from.accuracy,
                      decimal: state.fromAssetAmount ?? Decimal.zero,
                      symbol: from.symbol,
                    ),
                  ),
                  if (!state.recurring)
                    SActionConfirmText(
                      name: intl.previewBuyWithAsset_youGet,
                      baseline: 35.0,
                      contentLoading: state.union is QuoteLoading,
                      value: '≈ ${volumeFormat(
                        accuracy: to.accuracy,
                        decimal: state.toAssetAmount ?? Decimal.zero,
                        symbol: to.symbol,
                      )}',
                    ),
                  SActionConfirmText(
                    name: intl.fee,
                    baseline: 35.0,
                    contentLoading: state.union is QuoteLoading,
                    value: '${state.feePercent}%',
                  ),
                  if (!state.recurring)
                    SActionConfirmText(
                      name: intl.previewBuyWithAsset_exchangeRate,
                      baseline: 34.0,
                      contentLoading: state.union is QuoteLoading,
                      timerLoading: state.union is QuoteLoading,
                      animation: state.timerAnimation,
                      value: '${volumeFormat(
                        accuracy: from.accuracy,
                        decimal: Decimal.one,
                        symbol: from.symbol,
                      )} = \n'
                          '${volumeFormat(
                        accuracy: accuracy,
                        decimal: state.price ?? Decimal.zero,
                        symbol: to.symbol,
                      )}',
                    ),
                  const SpaceH36(),
                  if (state.connectingToServer) ...[
                    const SActionConfirmAlert(),
                    const SpaceH20(),
                  ],
                  SPrimaryButton2(
                    active: state.union is QuoteSuccess,
                    name: intl.previewBuyWithAsset_confirm,
                    onTap: () {
                      state.executeQuote();
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
