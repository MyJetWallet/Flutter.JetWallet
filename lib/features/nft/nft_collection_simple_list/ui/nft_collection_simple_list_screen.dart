import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/nft/nft_collection_details/ui/components/nft_collection_nft_item.dart';
import 'package:jetwallet/features/portfolio/widgets/portfolio_with_balance/components/balance_in_process.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/utils/models/nft_model.dart';
import 'package:simple_kit/modules/shared/page_frames/simple_page_frame_with_padding.dart';
import 'package:simple_kit/simple_kit.dart';

class NFTCollectionSimpleListScreen extends StatelessObserverWidget {
  const NFTCollectionSimpleListScreen({super.key, required this.collection});

  final NftModel collection;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      collection.nftList.first.tradingAsset ?? '',
    );

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: collection.name ?? '',
        ),
      ),
      child: Column(
        children: [
          Flexible(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 19,
                  childAspectRatio: 0.5823,
                ),
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                ),
                physics: const ClampingScrollPhysics(),
                itemCount: collection.nftList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      NFTCollectionNftItem(
                        nft: collection.nftList[index],
                        showBuyInfo: true,
                        showDivider: false,
                        onTap: () {
                          sRouter.push(
                            NFTDetailsRouter(
                              nft: collection.nftList[index],
                              userNFT: true,
                            ),
                          );
                        },
                      ),
                      if (collection.nftList[index].onSell ?? false) ...[
                        BalanceInProcess(
                          text: volumeFormat(
                            decimal: collection.nftList[index].sellPrice ??
                                Decimal.zero,
                            accuracy: currency.accuracy,
                            symbol: currency.symbol,
                            prefix: currency.prefixSymbol,
                          ),
                          leadText: intl.portfolioWithBalanceBody_selling_at,
                          removeDivider: true,
                          showInProgressText: false,
                          needPadding: false,
                          icon: SMinusIcon(
                            color: colors.grey3,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
