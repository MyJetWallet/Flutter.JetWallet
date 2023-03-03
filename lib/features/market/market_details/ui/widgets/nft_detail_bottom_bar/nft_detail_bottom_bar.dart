import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:simple_analytics/simple_analytics.dart';
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
              currencyPrefix: baseCurrency.prefix,
              currencySymbol: baseCurrency.symbol,
              decline: false,
              icon: SNetworkSvg24(
                url: iconUrlFrom(assetSymbol: nft.sellAsset ?? ''),
              ),
              primaryText: sortWordDependingLang(
                text: currency.description,
                swappedText: intl.balanceBlock_balance,
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

                navigateToWallet(context, currency);
              },
              removeDivider: true,
              leftBlockTopPadding: 16,
              balanceTopMargin: 16,
              height: 75,
              rightBlockTopPadding: 16,
            ),
          ] else ...[
            const SpaceH13(),
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
