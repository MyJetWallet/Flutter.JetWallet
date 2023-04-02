import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/currency_sell/model/preview_sell_input.dart';
import 'package:jetwallet/features/currency_sell/model/preview_sell_union.dart';
import 'package:jetwallet/features/currency_sell/store/preview_sell_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/price_accuracy.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'PreviewSellRouter')
class PreviewSell extends StatelessWidget {
  const PreviewSell({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewSellInput input;

  @override
  Widget build(BuildContext context) {
    return Provider<PreviewSellStore>(
      create: (context) => PreviewSellStore(input),
      builder: (context, child) => PreviewSellBody(
        input: input,
      ),
      dispose: (context, value) => value.dispose(),
    );
  }
}

class PreviewSellBody extends StatefulObserverWidget {
  const PreviewSellBody({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewSellInput input;

  @override
  State<PreviewSellBody> createState() => _PreviewSellBodyState();
}

class _PreviewSellBodyState extends State<PreviewSellBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);

    final notifier = PreviewSellStore.of(context);

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

    final store = PreviewSellStore.of(context);

    final from = widget.input.fromCurrency;
    final to = widget.input.toCurrency;

    final accuracy = priceAccuracy(from.symbol, to.symbol);

    return ReactionBuilder(
      builder: (context) {
        return reaction<PreviewSellUnion>(
          (_) => store.union,
          (result) {
            if (result is ExecuteLoading) {
              store.loader.startLoadingImmediately();
            } else {
              if (store.loader.loading) {
                store.loader.finishLoadingImmediately();
              }
            }
          },
          fireImmediately: true,
        );
      },
      child: SPageFrameWithPadding(
        loaderText: intl.register_pleaseWait,
        loading: store.loader,
        header: deviceSize.when(
          small: () {
            return SSmallHeader(
              title: store.previewHeader,
              onBackButtonTap: () {
                store.cancelTimer();
                Navigator.pop(context);
              },
            );
          },
          medium: () {
            return SMegaHeader(
              title: store.previewHeader,
              onBackButtonTap: () {
                store.cancelTimer();
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
                  SActionConfirmIconWithAnimation(
                    iconUrl: widget.input.fromCurrency.iconUrl,
                  ),
                  const Spacer(),
                  SActionConfirmText(
                    name: intl.previewSell_youPay,
                    value: volumeFormat(
                      prefix: from.prefixSymbol,
                      accuracy: from.accuracy,
                      decimal: store.fromAssetAmount ?? Decimal.zero,
                      symbol: from.symbol,
                    ),
                  ),
                  SActionConfirmText(
                    name: intl.previewSell_youGet,
                    baseline: 35.0,
                    contentLoading: store.union is QuoteLoading,
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
                    contentLoading: store.union is QuoteLoading,
                    value: '${store.feePercent}%',
                  ),
                  SActionConfirmText(
                    name: intl.previewSell_exchangeRate,
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
                    name: intl.previewSell_confirm,
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
      ),
    );
  }
}
