import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/features/my_wallets/widgets/get_account_button.dart';
import 'package:jetwallet/features/wallet/helper/market_item_from.dart';
import 'package:jetwallet/utils/formatting/base/decimal_extension.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';

import '../../../core/services/user_info/user_info_service.dart';

class MyWalletsAssetItem extends StatelessObserverWidget {
  const MyWalletsAssetItem({
    required this.isMoving,
    required this.currency,
    required this.store,
  });

  final CurrencyModel currency;
  final bool isMoving;
  final MyWalletsSrore store;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final marketItems = sSignalRModules.marketItems;

    final userInfo = getIt.get<UserInfoService>();

    var secondaryText = '';

    if (baseCurrency.symbol != currency.symbol) {
      secondaryText = getIt<AppStore>().isBalanceHide
          ? '******* ${currency.symbol}'
          : currency.symbol == 'EUR'
              ? sSignalRModules.totalEurWalletBalance.toVolumeFormat(
                  accuracy: currency.accuracy,
                  symbol: currency.symbol,
                )
              : currency.volumeAssetBalance;
    }

    if (currency.symbol == 'EUR') {
      final isAnyBankAccountInCreating = (sSignalRModules.bankingProfileData?.banking?.accounts ?? [])
          .where((element) => element.status == AccountStatus.inCreation)
          .isNotEmpty;
      final isSimpleInCreating =
          sSignalRModules.bankingProfileData?.simple?.account?.status == AccountStatus.inCreation;

      final isLoadingState =
          store.buttonStatus == BankingShowState.inProgress || isAnyBankAccountInCreating || isSimpleInCreating;

      final isCardInCreating = (sSignalRModules.bankingProfileData?.banking?.cards ?? [])
          .where((element) => element.status == AccountStatusCard.inCreation)
          .isNotEmpty;

      final isButtonSmall = !isLoadingState &&
          (store.buttonStatus == BankingShowState.getAccount || store.buttonStatus == BankingShowState.getAccountBlock);

      return SimpleTableAccount(
        assetIcon: SNetworkSvg24(
          url: currency.iconUrl,
        ),
        label: currency.description,
        supplement: secondaryText,
        rightValue:
            getIt<AppStore>().isBalanceHide ? '**** ${baseCurrency.symbol}' : currency.volumeBaseBalance(baseCurrency),
        hasButton: !isMoving &&
            (isLoadingState ||
                isCardInCreating ||
                (store.buttonStatus == BankingShowState.getAccount) ||
                store.buttonStatus == BankingShowState.getAccountBlock),
        isButtonLoading: isLoadingState || isCardInCreating,
        buttonHasRightArrow: !isButtonSmall && !isSimpleInCreating,
        buttonHasCardIcon: (sSignalRModules.bankingProfileData?.banking?.cards
                        ?.where(
                          (element) =>
                              element.status == AccountStatusCard.active || element.status == AccountStatusCard.frozen,
                        )
                        .toList()
                        .length ??
                    0) >
                0 &&
            userInfo.isSimpleCardAvailable,
        buttonLabel: isLoadingState
            ? intl.my_wallets_create_account
            : isCardInCreating
                ? intl.my_wallets_card_creating
                : store.simpleCardButtonText,
        isButtonSmall: isButtonSmall,
        isButtonLabelBold: isButtonSmall,
        buttonTap: () {
          sAnalytics.tapOnTheButtonGetAccountEUROnWalletsScreen();
          onGetAccountClick(store, context, currency);
        },
        onTableAssetTap: !isMoving
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
                      sRouter
                          .push(
                            CJAccountRouter(
                              bankingAccount: sSignalRModules.bankingProfileData!.simple!.account!,
                              isCJAccount: true,
                              eurCurrency: currency,
                            ),
                          )
                          .then(
                            (value) => sAnalytics.eurWalletTapBackOnAccountWalletScreen(
                              isCJ: true,
                              eurAccountLabel: sSignalRModules.bankingProfileData!.simple!.account!.label ?? '',
                              isHasTransaction: false,
                            ),
                          );
                    } else if (sSignalRModules.bankingProfileData?.showState == BankingShowState.inProgress) {
                      return;
                    } else if (sSignalRModules.bankingProfileData?.showState == BankingShowState.accountList) {
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
                        },
                      );
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
                    },
                  );
                }
              }
            : null,
        customRightWidget: isMoving ? Assets.svg.small.reorder.simpleSvg() : null,
      );
    } else {
      return SimpleTableAsset(
        assetIcon: SNetworkSvg24(
          url: currency.iconUrl,
        ),
        label: currency.description,
        supplement: secondaryText,
        rightValue:
            getIt<AppStore>().isBalanceHide ? '**** ${baseCurrency.symbol}' : currency.volumeBaseBalance(baseCurrency),
        onTableAssetTap: !isMoving
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
                    },
                  );
                }
              }
            : null,
        customRightWidget: isMoving ? Assets.svg.small.reorder.simpleSvg() : null,
      );
    }
  }
}
