import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/nft/nft_sell/model/nft_sell_input.dart';
import 'package:jetwallet/features/nft/nft_sell/store/nft_preview_sell_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

class NFTPreviewSellScreen extends StatelessWidget {
  const NFTPreviewSellScreen({
    super.key,
    required this.input,
  });

  final NftSellInput input;

  @override
  Widget build(BuildContext context) {
    return Provider<NFTPreviewSellStore>(
      create: (context) => NFTPreviewSellStore()..init(input),
      builder: (context, child) => _NFTPreviewSellScreenBody(
        input: input,
      ),
    );
  }
}

class _NFTPreviewSellScreenBody extends StatefulObserverWidget {
  const _NFTPreviewSellScreenBody({
    super.key,
    required this.input,
  });

  final NftSellInput input;

  @override
  State<_NFTPreviewSellScreenBody> createState() =>
      _NFTPreviewSellScreenBodyState();
}

class _NFTPreviewSellScreenBodyState extends State<_NFTPreviewSellScreenBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);

    //final notifier = PreviewSellStore.of(context);

    //notifier.updateTimerAnimation(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final deviceSize = sDeviceSize;

    final baseCurrency = sSignalRModules.baseCurrency;

    final store = NFTPreviewSellStore.of(context);

    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      widget.input.nft.tradingAsset ?? '',
    );

    return SPageFrameWithPadding(
      loaderText: intl.register_pleaseWait,
      loading: store.loader,
      customLoader: store.isProcessing
          ? WaitingScreen(
              onSkip: () {},
            )
          : null,
      header: deviceSize.when(
        small: () {
          return SSmallHeader(
            titleAlign: TextAlign.center,
            title: store.previewHeader,
            onBackButtonTap: () {
              //store.cancelTimer();
              Navigator.pop(context);
            },
          );
        },
        medium: () {
          return SMegaHeader(
            crossAxisAlignment: CrossAxisAlignment.center,
            title: store.previewHeader,
            onBackButtonTap: () {
              //store.cancelTimer();
              Navigator.pop(context);
            },
          );
        },
      ),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    '$fullUrl${widget.input.nft.fImage}',
                    width: 160,
                    height: 160,
                    fit: BoxFit.fill,
                  ),
                ),
                const Spacer(),
                SActionConfirmText(
                  name: intl.nft_confirm_sell_price,
                  value: volumeFormat(
                    accuracy: currency.accuracy,
                    decimal: store.price,
                    symbol: currency.symbol,
                  ),
                ),
                Observer(
                  builder: (context) {
                    return SActionConfirmText(
                      name: intl.nft_confirm_sell_fee,
                      baseline: 35.0,
                      contentLoading: store.isLoading,
                      value: '${store.feePercentage}%',
                    );
                  },
                ),
                const SpaceH32(),
                const SDivider(),
                SActionConfirmText(
                  name: intl.nft_confirm_sell_you_will_get,
                  baseline: 35.0,
                  contentLoading: store.isLoading,
                  value: volumeFormat(
                    accuracy: currency.accuracy,
                    decimal: store.priceWithFee,
                    symbol: currency.symbol,
                  ),
                  valueColor: colors.blue,
                  valueDescription: volumeFormat(
                    prefix: baseCurrency.prefix,
                    decimal: currency.currentPrice * store.priceWithFee,
                    symbol: baseCurrency.symbol,
                    accuracy: baseCurrency.accuracy,
                  ),
                ),
                const SpaceH36(),
                if (store.connectingToServer) ...[
                  const SActionConfirmAlert(),
                  const SpaceH20(),
                ],
                SPrimaryButton2(
                  active: !store.isLoading && !store.connectingToServer,
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
    );
  }
}
