import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'dart:io' show Platform;

import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

void showBuyNFTNotEnougn(CurrencyModel currency, NftMarket? nft) {
  final colors = sKit.colors;

  sShowBasicModalBottomSheet(
    context: sRouter.navigatorKey.currentContext!,
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    onDissmis: () {},
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            nftGradient,
            width: 80,
            height: 80,
          ),
          SNetworkSvg(
            url: iconUrlFrom(
              assetSymbol: currency.symbol,
            ),
            color: Colors.white,
            width: 48,
            height: 48,
          ),
        ],
      ),
      const SpaceH31(),
      Align(
        child: Baseline(
          baseline: 24,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            '${intl.nft_collection_not_enougn} ${currency.description}',
            textAlign: TextAlign.center,
            style: sTextH3Style,
          ),
        ),
      ),
      const SpaceH15(),
      SPaddingH24(
        child: Baseline(
          baseline: 24,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            '${intl.nft_collection_not_enougn_descr_1} ${currency.description} ${intl.nft_collection_not_enougn_descr_2}',
            maxLines: 3,
            textAlign: TextAlign.center,
            style: sBodyText1Style.copyWith(color: colors.grey1),
          ),
        ),
      ),
      const SpaceH33(),
      SPaddingH24(
        child: SPrimaryButton1(
          active: true,
          name:
              '${intl.nft_collection_go_to} ${currency.description} ${intl.nft_collection_wallet}',
          onTap: () {
            navigateToWallet(
              sRouter.navigatorKey.currentContext!,
              currency,
            );
          },
        ),
      ),
      const SpaceH16(),
      SPaddingH24(
        child: STextButton1(
          active: true,
          name: intl.previewSell_close,
          onTap: () {
            sRouter.pop();
          },
        ),
      ),
      const SpaceH24(),
    ],
  );
}
