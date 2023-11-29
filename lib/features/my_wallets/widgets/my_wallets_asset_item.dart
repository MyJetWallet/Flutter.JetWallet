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
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';

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

    if (currency.symbol == 'EUR') {
      final isButtonSmall =
          store.buttonStatus == BankingShowState.getAccount || store.buttonStatus == BankingShowState.getAccountBlock;

      final isAnyBankAccountInCreating = (sSignalRModules.bankingProfileData?.banking?.accounts ?? [])
          .where((element) => element.status == AccountStatus.inCreation)
          .isNotEmpty;
      final isSimpleInCreating =
          sSignalRModules.bankingProfileData?.simple?.account?.status == AccountStatus.inCreation;
      final isCardInCreating = (sSignalRModules.bankingProfileData?.banking?.cards ?? [])
          .where((element) => element.status == AccountStatusCard.inCreation)
          .isNotEmpty;

      final isLoadingState = store.buttonStatus == BankingShowState.inProgress ||
          isAnyBankAccountInCreating ||
          isSimpleInCreating ||
          isCardInCreating;

      return SimpleTableAccount(
        assetIcon: SNetworkSvg24(
          url: currency.iconUrl,
        ),
        label: currency.description,
        supplement: secondaryText,
        rightValue:
            getIt<AppStore>().isBalanceHide ? '**** ${baseCurrency.symbol}' : currency.volumeBaseBalance(baseCurrency),
        hasButton: !isMoving,
        isButtonLoading: isLoadingState,
        buttonHasRightArrow: !isLoadingState && !isButtonSmall,
        buttonLabel: isLoadingState ? intl.my_wallets_create_account : store.simpleCardButtonText,
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
                          .then((value) => sAnalytics.eurWalletTapBackOnAccountsScreen());
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
        customRightWidget: isMoving ? Assets.svg.small.reorder.simpleSvg() : null,
      );
    } else {
      return SimpleTableAsset(
        isCard: false,
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

                      sAnalytics.eurWalletTapBackOnAccountsScreen();
                    },
                  );
                }
              }
            : null,
        customRightWidget: isMoving ? Assets.svg.small.reorder.simpleSvg() : null,
      );
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
                  } else if (sSignalRModules.bankingProfileData?.showState == BankingShowState.inProgress) {
                    return;
                  } else if (sSignalRModules.bankingProfileData?.showState == BankingShowState.accountList) {
                    sRouter
                        .push(
                          WalletRouter(
                            currency: currency,
                          ),
                        )
                        .then((value) => sAnalytics.eurWalletTapBackOnAccountsScreen());
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
}
