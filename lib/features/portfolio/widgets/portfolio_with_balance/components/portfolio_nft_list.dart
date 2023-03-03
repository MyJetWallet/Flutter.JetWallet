import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/portfolio/helper/calculate_nft_price.dart';
import 'package:jetwallet/features/portfolio/helper/zero_balance_wallets_empty.dart';
import 'package:jetwallet/features/portfolio/widgets/portfolio_with_balance/components/balance_in_process.dart';
import 'package:jetwallet/features/portfolio/widgets/portfolio_with_balance/components/portfolio_nft_empty_item.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/utils/models/nft_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../core/di/di.dart';
import '../../../../kyc/helper/kyc_alert_handler.dart';
import '../../../../kyc/kyc_service.dart';
import '../../../../kyc/models/kyc_operation_status_model.dart';
import 'portfolio_divider.dart';

class PortfolioNftList extends StatelessObserverWidget {
  const PortfolioNftList({
    super.key,
    required this.userNft,
  });

  final List<NftModel> userNft;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;

    CurrencyModel? currency;

    if (userNft.isNotEmpty) {
      currency = currencyFrom(
        sSignalRModules.currenciesList,
        userNft.first.nftList.first.tradingAsset ?? '',
      );
    }

    return userNft.isEmpty
        ? emptyNFTList(context)
        : ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final item in userNft) ...[
                SWalletItem(
                  icon: CachedNetworkImage(
                    imageUrl: '$shortUrl${item.sImage}',
                    width: 24,
                    height: 24,
                  ),
                  primaryText: item.name ?? '',
                  amount: volumeFormat(
                    prefix: baseCurrency.prefix,
                    decimal: currency!.currentPrice *
                        calculateNFTPrice(item.nftList),
                    symbol: baseCurrency.symbol,
                    accuracy: baseCurrency.accuracy,
                  ),
                  secondaryText:
                      '${item.nftList.length} ${intl.nft_collection_details_items_small}',
                  removeDivider: getNFTOnSell(item.nftList).isNotEmpty ||
                      item == userNft.last,
                  onTap: () {
                    // If there is only 1 purchased NFT in the collection, immediately open the NFT screen

                    if (item.nftList.length == 1) {
                      sRouter.push(
                        NFTDetailsRouter(
                          nftSymbol: item.nftList.first.symbol!,
                          userNFT: true,
                        ),
                      );
                    } else {

                      sRouter.push(
                        NFTCollectionSimpleListRouter(
                          collectionID: item.id!,
                        ),
                      );
                    }
                  },
                ),
                if (getNFTOnSell(item.nftList).isNotEmpty) ...[
                  if (getNFTOnSell(item.nftList).length == 1) ...[
                    BalanceInProcess(
                      text: volumeFormat(
                        decimal: calculateSellNFTPrice(item.nftList),
                        accuracy: currency.accuracy,
                        symbol: currency.symbol,
                        prefix: currency.prefixSymbol,
                      ),
                      leadText: intl.portfolioWithBalanceBody_selling_at,
                      removeDivider: item == userNft.last,
                      showInProgressText: false,
                      icon: SMinusIcon(
                        color: colors.grey3,
                      ),
                    ),
                  ] else ...[
                    BalanceInProcess(
                      text:
                          '${getNFTOnSell(item.nftList).length} ${intl.portfolioWithBalanceBody_items}',
                      leadText: intl.portfolioWithBalanceBody_selling,
                      removeDivider: item == userNft.last,
                      showInProgressText: false,
                      icon: SMinusIcon(
                        color: colors.grey3,
                      ),
                    ),
                  ],
                ],
              ],
            ],
          );
  }

  Widget emptyNFTList(BuildContext context) {
    final colors = sKit.colors;
    final kyc = getIt.get<KycService>();
    final handler = getIt.get<KycAlertHandler>();

    return SPaddingH24(
      child: Column(
        children: [
          const SpaceH30(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PortfolioNftEmptyItem(
                text: intl.portfolioWithBalanceBody_buy_nft,
                icon: SPlusIcon(
                  color: colors.black,
                ),
                onTap: () {
                  sRouter.push(
                    HomeRouter(
                      children: [
                        MarketRouter(initIndex: 2),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                width: 19,
              ),
              PortfolioNftEmptyItem(
                text: intl.portfolioWithBalanceBody_receive_nft,
                icon: SActionReceiveIcon(
                  color: colors.black,
                ),
                onTap: () {
                  if (kyc.depositStatus ==
                          kycOperationStatus(KycStatus.allowed) &&
                      kyc.withdrawalStatus ==
                          kycOperationStatus(KycStatus.allowed) &&
                      kyc.sellStatus == kycOperationStatus(KycStatus.allowed)) {
                    sRouter.push(
                      const ReceiveNFTRouter(),
                    );
                  } else {
                    handler.handle(
                      status: kyc.depositStatus !=
                              kycOperationStatus(KycStatus.allowed)
                          ? kyc.depositStatus
                          : kyc.withdrawalStatus !=
                                  kycOperationStatus(KycStatus.allowed)
                              ? kyc.withdrawalStatus
                              : kyc.sellStatus,
                      isProgress: kyc.verificationInProgress,
                      currentNavigate: () {
                        sRouter.push(
                          const ReceiveNFTRouter(),
                        );
                      },
                      requiredDocuments: kyc.requiredDocuments,
                      requiredVerifications: kyc.requiredVerifications,
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
