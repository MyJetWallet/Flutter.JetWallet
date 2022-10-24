import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/market/market_details/store/operation_history.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/balance_block/balance_block.dart';
import 'package:jetwallet/features/market/market_details/ui/widgets/balance_block/components/balance_action_buttons.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/reccurring/store/recurring_buys_store.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/primary_button/simple_base_primary_button.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/secondary_button/light/simple_light_secondary_button_1.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

import '../../../helper/currency_from.dart';
import '../../../helper/swap_words.dart';

class NFTDetailBottomBar extends StatelessObserverWidget {
  const NFTDetailBottomBar({
    super.key,
    required this.userNFT,
    required this.nft,
    required this.onTap,
  });

  final bool userNFT;
  final NftMarket nft;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;

    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      nft.sellAsset ?? '',
    );

    final languageCode = Localizations.localeOf(context).languageCode;

    return SizedBox(
      height: userNFT ? 104 : 156,
      child: Column(
        children: [
          const SDivider(),
          if (!userNFT) ...[
            SWalletItem(
              decline: false,
              icon: SNetworkSvg24(
                url: iconUrlFrom(assetSymbol: nft.sellAsset ?? ''),
              ),
              primaryText: sortWordDependingLang(
                text: currency.description,
                swappedText: intl.balanceBlock_wallet,
                languageCode: languageCode,
                isCapitalize: true,
              ),
              amount: volumeFormat(
                prefix: baseCurrency.prefix,
                decimal: currency.baseBalance,
                symbol: baseCurrency.symbol,
                accuracy: baseCurrency.accuracy,
              ),
              amountDecimal: currency.baseBalance.toDouble(),
              secondaryText: volumeFormat(
                prefix: currency.prefixSymbol,
                decimal: currency.assetBalance,
                symbol: currency.symbol,
                accuracy: currency.accuracy,
              ),
              onTap: () {
                sAnalytics.walletAssetView(
                  Source.assetScreen,
                  currency.description,
                );

                navigateToWallet(context, currency);
              },
              removeDivider: true,
              leftBlockTopPadding: 16,
              balanceTopMargin: 16,
              height: 75,
              rightBlockTopPadding: 16,
            ),
          ] else ...[
            const SpaceH20(),
          ],
          SPaddingH24(
            child: SPrimaryButton1(
              active: true,
              name: userNFT ? intl.nft_detail_action : intl.nft_detail_buy,
              onTap: onTap,
            ),
          ),
          const SpaceH24(),
        ],
      ),
    );
  }
}
