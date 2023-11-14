import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/wallet/helper/market_item_from.dart';
import 'package:jetwallet/utils/formatting/base/decimal_extension.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

class MyWalletsAssetItem extends StatelessObserverWidget {
  const MyWalletsAssetItem({
    required this.isMoving,
    required this.currency,
  });

  final CurrencyModel currency;
  final bool isMoving;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final marketItems = sSignalRModules.marketItems;

    var secondaryText = '';

    if (baseCurrency.symbol != currency.symbol) {
      secondaryText = getIt<AppStore>().isBalanceHide
          ? currency.symbol
          : currency.symbol == 'EUR'
              ? sSignalRModules.totalEurWalletBalance.toVolumeFormat(
                  accuracy: currency.accuracy,
                  symbol: currency.symbol,
                )
              : currency.volumeAssetBalance;
    }

    return SWalletItem(
      height: 80,
      key: UniqueKey(),
      isBalanceHide: getIt<AppStore>().isBalanceHide,
      decline: currency.dayPercentChange.isNegative,
      icon: SNetworkSvg24(
        url: currency.iconUrl,
      ),
      baseCurrencySymbol: baseCurrency.symbol,
      primaryText: currency.description,
      amount: currency.volumeBaseBalance(baseCurrency),
      secondaryText: secondaryText,
      onTap: !isMoving
          ? () {
              sAnalytics.tapOnFavouriteWalletOnWalletsScreen(
                openedAsset: currency.symbol,
              );
              if (currency.type == AssetType.indices) {
                sRouter.push(
                  MarketDetailsRouter(
                    marketItem: marketItemFrom(
                      marketItems,
                      currency.symbol,
                    ),
                  ),
                );
              } else {
                if (currency.symbol == 'EUR') {
                  if (sSignalRModules.bankingProfileData?.showState == BankingShowState.onlySimple) {
                    if (checkUserBlock()) {
                      sRouter
                          .push(
                            CJAccountRouter(
                              bankingAccount: sSignalRModules.bankingProfileData!.simple!.account!,
                              isCJAccount: true,
                            ),
                          )
                          .then(
                            (value) => sAnalytics.eurWalletTapBackOnAccountWalletScreen(
                              isCJ: true,
                              eurAccountLabel: sSignalRModules.bankingProfileData!.simple!.account!.label ?? '',
                              isHasTransaction: false,
                            ),
                          );
                    }
                  } else if (sSignalRModules.bankingProfileData?.showState == BankingShowState.inProgress) {
                    return;
                  } else if (sSignalRModules.bankingProfileData?.showState == BankingShowState.accountList) {
                    if (checkUserBlock()) {
                      sRouter
                          .push(
                            WalletRouter(
                              currency: currency,
                            ),
                          )
                          .then((value) => sAnalytics.eurWalletTapBackOnAccountsScreen());
                    }
                  }

                  return;
                }

                sRouter
                    .push(
                  WalletRouter(
                    currency: currency,
                  ),
                )
                    .then(
                  (value) {
                    sAnalytics.tapOnTheButtonBackOrSwipeToBackOnCryptoFavouriteWalletScreen(
                      openedAsset: currency.symbol,
                    );

                    sAnalytics.eurWalletTapBackOnAccountsScreen();
                  },
                );
              }
            }
          : null,
      removeDivider: true,
      isPendingDeposit: currency.isPendingDeposit,
      isMoving: isMoving,
      priceFieldHeight: 44,
    );
  }

  bool checkUserBlock() {
    if (sSignalRModules.clientDetail.clientBlockers.isNotEmpty) {
      sNotification.showError(
        intl.operation_is_unavailable,
        duration: 4,
        id: 1,
        needFeedback: true,
      );

      return false;
    } else {
      return true;
    }
  }
}
