import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/nft/nft_confirm/store/nft_confirm_store.dart';
import 'package:jetwallet/features/nft/nft_confirm/store/nft_promo_code_store.dart';
import 'package:jetwallet/features/nft/nft_confirm/ui/components/nft_promo_button.dart';
import 'package:jetwallet/features/nft/nft_confirm/ui/show_nft_promo_code.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

class NFTConfirmScreen extends StatelessWidget {
  const NFTConfirmScreen({
    super.key,
    required this.nft,
  });

  final NftMarket nft;

  @override
  Widget build(BuildContext context) {
    return Provider<NFTConfirmStore>(
      create: (context) => NFTConfirmStore()..init(nft),
      builder: (context, child) => _NFTConfirmScreenBody(
        nft: nft,
      ),
    );
  }
}

class _NFTConfirmScreenBody extends StatelessObserverWidget {
  const _NFTConfirmScreenBody({
    super.key,
    required this.nft,
  });

  final NftMarket nft;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;

    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      nft.tradingAsset ?? '',
    );

    return SPageFrameWithPadding(
      loading: NFTConfirmStore.of(context).loader,
      customLoader: NFTConfirmStore.of(context).isProcessing
          ? WaitingScreen(
              onSkip: () {},
            )
          : null,
      header: SMegaHeader(
        title: '${intl.nft_detail_confirm_buy} \n ${nft.name}',
        crossAxisAlignment: CrossAxisAlignment.center,
        onBackButtonTap: () {
          Navigator.pop(context);
        },
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              '$fullUrl${nft.fImage}',
              height: 160.0,
              width: 160.0,
              fit: BoxFit.fill,
            ),
          ),
          const Spacer(),
          if (getIt.get<NFTPromoCodeStore>().saved &&
              NFTConfirmStore.of(context).discountPercentage !=
                  Decimal.zero) ...[
            Row(
              children: [
                Baseline(
                  baseline: 21,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    intl.nft_detail_promo_discount,
                    style: sBodyText2Style.copyWith(
                      color: colors.grey1,
                    ),
                  ),
                ),
                const Spacer(),
                Baseline(
                  baseline: 24,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    volumeFormat(
                      decimal: NFTConfirmStore.of(context).discountPercentage,
                      symbol: '%',
                      accuracy: 3,
                    ),
                    style: sSubtitle3Style,
                  ),
                ),
              ],
            ),
          ],
          const SpaceH19(),
          Row(
            children: [
              Baseline(
                baseline: 21,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  intl.nft_detail_confirm_price,
                  style: sBodyText2Style.copyWith(
                    color: colors.grey1,
                  ),
                ),
              ),
              const Spacer(),
              Baseline(
                baseline: 24,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  volumeFormat(
                    decimal: nft.sellPrice!,
                    symbol: nft.tradingAsset!,
                    accuracy: currency.accuracy,
                  ),
                  style: sSubtitle3Style,
                ),
              ),
            ],
          ),
          const SpaceH32(),
          const SDivider(),
          const SpaceH16(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                intl.nft_detail_confirm_you_will_pay,
                style: sBodyText2Style.copyWith(
                  color: colors.grey1,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    volumeFormat(
                      decimal: NFTConfirmStore.of(context).totalPay,
                      accuracy: currency.accuracy,
                      symbol: nft.tradingAsset!,
                    ),
                    style: sSubtitle3Style.copyWith(
                      color: colors.blue,
                    ),
                  ),
                  Text(
                    volumeFormat(
                      prefix: baseCurrency.prefix,
                      decimal: currency.currentPrice *
                          NFTConfirmStore.of(context).totalPay,
                      symbol: baseCurrency.symbol,
                      accuracy: baseCurrency.accuracy,
                    ),
                    style: sBodyText2Style.copyWith(
                      color: colors.grey1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SpaceH23(),
          SPrimaryButton2(
            active: true,
            name: intl.nft_detail_confirm_confirm,
            onTap: () {
              NFTConfirmStore.of(context).confirm();
            },
          ),
          const SpaceH10(),
          const NFTPromoButton(),
          const SpaceH24(),
        ],
      ),
    );
  }
}
