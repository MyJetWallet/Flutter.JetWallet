import 'dart:async';

import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/anchors/anchors_helper.dart';
import 'package:jetwallet/core/services/anchors/models/convert_confirmation_model/convert_confirmation_model.dart';
import 'package:jetwallet/core/services/anchors/models/crypto_deposit/crypto_deposit_model.dart';
import 'package:jetwallet/core/services/push_notification_service.dart';
import 'package:jetwallet/core/services/remote_config/models/remote_config_union.dart';
import 'package:jetwallet/core/services/route_query_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorized_union.dart';
import 'package:jetwallet/features/app/timer_service.dart';
import 'package:jetwallet/features/cj_banking_accounts/screens/show_account_details_screen.dart';
import 'package:jetwallet/features/home/store/bottom_bar_store.dart';
import 'package:jetwallet/features/wallet/helper/market_item_from.dart';
import 'package:jetwallet/features/withdrawal_banking/helpers/show_bank_transfer_select.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/analytic_records/models/anchor_record.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

class AnchorsService {
  static const _tag = '[AnchorsService]';

  Future<void> setAnchor(AnchorRecordModel anchorRecord) async {
    await getIt.get<SNetwork>().simpleNetworking.getAnalyticApiModule().postAddAnchor(anchorRecord);
  }

  Future<void> handleDeeplink({
    required String type,
    required Map<String, String> metadata,
    required String? messageId,
  }) async {
    if (metadata.isEmpty) {
      if (kDebugMode) {
        print('$_tag error: Metadata is null');
      }
      return;
    }

    switch (type) {
      case AnchorsHelper.anchorTypeCryptoDeposit:
        {
          await pushCryptoDepositScreen(metadata);
        }
      case AnchorsHelper.anchorTypeConvertConfirmation:
        {
          await pushConvertConfirmScreen(metadata);
        }
      case AnchorsHelper.anchorTypeMarketDetails:
        {
          await pushMarketDetailsScreen(metadata);
        }
      case AnchorsHelper.anchorTypeBankingAccountDetails:
        {
          await pushBankingAccountDetailsScreen(metadata);
        }
      case AnchorsHelper.anchorTypeForgotEarnDeposit:
        {
          await pushForgotEarnDepositScreen(metadata);
        }
      case AnchorsHelper.anchorTypeForgotTopUpEarnDeposit:
        {
          await pushTopUpEarnDepositScreen(metadata);
        }
      case AnchorsHelper.anchorTypeForgotSectors:
        {
          await pushMarketSectorScreen(metadata);
        }
      case AnchorsHelper.anchorTypeAddExternalIban:
        {
          await pushAddExternalIbanScreen(metadata);
        }
    }
    if (messageId != null && messageId.isNotEmpty) {
      unawaited(logPushNotificationToBD(messageId, 2));
    }
  }

  Future<void> pushCryptoDepositScreen(
    Map<String, String> metadata,
  ) async {
    final symbol = metadata[AnchorsHelper.anchorMetadataAssetSymbol];

    if (symbol == null) {
      return;
    }

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      sRouter.popUntilRoot();

      await Future.delayed(const Duration(milliseconds: 650));

      final isPageRouterNow = sRouter.stack.any((rout) => rout.name == CryptoDepositRouter.name);
      if (!isPageRouterNow) {
        await sRouter.push(
          CryptoDepositRouter(
            cryptoDepositModel: CryptoDepositModel(
              assetSymbol: symbol,
            ),
          ),
        );
      }
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            sRouter.popUntilRoot();

            final isPageRouterNow = sRouter.stack.any((rout) => rout.name == CryptoDepositRouter.name);
            if (!isPageRouterNow) {
              await sRouter.push(
                CryptoDepositRouter(
                  cryptoDepositModel: CryptoDepositModel(
                    assetSymbol: symbol,
                  ),
                ),
              );
            }
          },
        ),
      );
    }
  }

  Future<void> pushConvertConfirmScreen(
    Map<String, String> metadata,
  ) async {
    final fromAsset = metadata[AnchorsHelper.anchorMetadataFromAsset];
    final toAsset = metadata[AnchorsHelper.anchorMetadataToAsset];
    final fromAmount = metadata[AnchorsHelper.anchorMetadataFromAmount];
    final toAmount = metadata[AnchorsHelper.anchorMetadataToAmount];
    final isFromFixed = metadata[AnchorsHelper.anchorMetadataIsFromFixed];

    if (fromAsset == null || toAsset == null || fromAmount == null || toAmount == null || isFromFixed == null) {
      return;
    }

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      sRouter.popUntilRoot();

      await Future.delayed(const Duration(milliseconds: 650));

      final isPageRouterNow = sRouter.stack.any((rout) => rout.name == ConvertConfirmationRoute.name);
      if (!isPageRouterNow) {
        await sRouter.push(
          ConvertConfirmationRoute(
            convertConfirmationModel: ConvertConfirmationModel(
              fromAsset: fromAsset,
              toAsset: toAsset,
              fromAmount: Decimal.parse(fromAmount),
              toAmount: Decimal.parse(toAmount),
              isFromFixed: bool.parse(isFromFixed),
            ),
          ),
        );
      }
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            sRouter.popUntilRoot();

            final isPageRouterNow = sRouter.stack.any((rout) => rout.name == ConvertConfirmationRoute.name);
            if (!isPageRouterNow) {
              await sRouter.push(
                ConvertConfirmationRoute(
                  convertConfirmationModel: ConvertConfirmationModel(
                    fromAsset: fromAsset,
                    toAsset: toAsset,
                    fromAmount: Decimal.parse(fromAmount),
                    toAmount: Decimal.parse(toAmount),
                    isFromFixed: bool.parse(isFromFixed),
                  ),
                ),
              );
            }
          },
        ),
      );
    }
  }

  Future<void> pushMarketDetailsScreen(
    Map<String, String> metadata,
  ) async {
    final symbol = metadata[AnchorsHelper.anchorMetadataAssetSymbol];

    if (symbol == null) {
      return;
    }

    Future<void> func() async {
      await Future.delayed(const Duration(milliseconds: 650));
      sRouter.popUntilRoot();

      final market = marketItemFrom(
        sSignalRModules.marketItems,
        symbol,
      );

      final isPageRouterNow = sRouter.stack.any((rout) => rout.name == MarketDetailsRouter.name);
      if (!isPageRouterNow) {
        await sRouter.push(
          MarketDetailsRouter(
            marketItem: market,
          ),
        );
      }
    }

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      await func();
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            await func();
          },
        ),
      );
    }
  }

  Future<void> pushBankingAccountDetailsScreen(
    Map<String, String> metadata,
  ) async {
    final accountId = metadata[AnchorsHelper.anchorMetadataAccountId];

    if (accountId == null) {
      return;
    }

    Future<void> func() async {
      await Future.delayed(const Duration(milliseconds: 650));
      sRouter.popUntilRoot();

      SimpleBankingAccount? bankingAccount;
      if (accountId == 'clearjuction_account') {
        bankingAccount = sSignalRModules.bankingProfileData?.simple?.account;
      } else {
        bankingAccount = sSignalRModules.bankingProfileData?.banking?.accounts
            ?.where((account) => account.accountId == accountId)
            .firstOrNull;
      }

      if (bankingAccount == null) {
        return;
      }

      if (sRouter.navigatorKey.currentContext != null) {
        showAccountDetails(
          context: sRouter.navigatorKey.currentContext!,
          bankingAccount: bankingAccount,
          onClose: () {},
        );
      }
    }

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      await func();
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            await func();
          },
        ),
      );
    }
  }

  Future<void> pushForgotEarnDepositScreen(
    Map<String, String> metadata,
  ) async {
    final offerId = metadata[AnchorsHelper.anchorMetadataOfferId];

    if (offerId == null) {
      return;
    }

    Future<void> func() async {
      await Future.delayed(const Duration(milliseconds: 650));
      sRouter.popUntilRoot();

      final offers = sSignalRModules.activeEarnOffersMessage?.offers ?? [];

      if (offers.isEmpty) {
        return;
      }

      final offer = offers.where((element) => element.id == offerId).firstOrNull;
      if (offer == null) {
        return;
      }

      final isPageRouterNow = sRouter.stack.any((rout) => rout.name == EarnDepositScreenRouter.name);
      if (!isPageRouterNow) {
        await sRouter.push(
          EarnDepositScreenRouter(
            offer: offer,
          ),
        );
      }
    }

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      await func();
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            await func();
          },
        ),
      );
    }
  }

  Future<void> pushTopUpEarnDepositScreen(
    Map<String, String> metadata,
  ) async {
    final offerId = metadata[AnchorsHelper.anchorMetadataOfferId];
    final positionId = metadata[AnchorsHelper.anchorMetadataPositionId];

    if (offerId == null || positionId == null) {
      return;
    }

    Future<void> func() async {
      await Future.delayed(const Duration(milliseconds: 650));
      sRouter.popUntilRoot();

      final offers = sSignalRModules.activeEarnOffersMessage?.offers ?? [];

      if (offers.isEmpty) {
        return;
      }

      final offer = offers.where((element) => element.id == offerId).firstOrNull;
      if (offer == null) {
        return;
      }

      final positions = sSignalRModules.activeEarnPositionsMessage?.positions ?? [];
      final position = positions.where((element) => element.id == positionId).firstOrNull;
      if (position == null) {
        return;
      }

      final positionWithOffers = position.copyWith(
        offers: offers,
      );

      final isPageRouterNow = sRouter.stack.any((rout) => rout.name == EarnPositionActiveRouter.name);
      if (!isPageRouterNow) {
        unawaited(
          sRouter.push(
            EarnPositionActiveRouter(
              earnPosition: positionWithOffers,
              offers: offers,
            ),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 350));
        unawaited(
          sRouter.push(
            EarnTopUpAmountRouter(
              earnPosition: positionWithOffers,
            ),
          ),
        );
      }
    }

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      await func();
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            await func();
          },
        ),
      );
    }
  }

  Future<void> pushMarketSectorScreen(
    Map<String, String> metadata,
  ) async {
    final sectorId = metadata[AnchorsHelper.anchorMetadataSectorId];

    if (sectorId == null) {
      return;
    }

    Future<void> func() async {
      sRouter.popUntilRoot();
      getIt<BottomBarStore>().setHomeTab(BottomItemType.market);

      final sector = sSignalRModules.marketSectors.firstWhereOrNull((sector) => sector.id == sectorId);
      if (sector != null) {
        final isPageRouterNow = sRouter.stack.any((rout) => rout.name == MarketSectorDetailsRouter.name);
        if (!isPageRouterNow) {
          await sRouter.push(
            MarketSectorDetailsRouter(
              sector: sector,
            ),
          );
        }
      }
    }

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      await Future.delayed(const Duration(milliseconds: 100));

      await func();
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            await func();
          },
        ),
      );
    }
  }

  Future<void> pushAddExternalIbanScreen(
    Map<String, String> metadata,
  ) async {
    final accountId = metadata[AnchorsHelper.anchorMetadataAccountId];

    if (accountId == null) {
      return;
    }

    void func() {
      sRouter.popUntilRoot();

      SimpleBankingAccount? bankingAccount;
      if (accountId == 'clearjuction_account') {
        bankingAccount = sSignalRModules.bankingProfileData?.simple?.account;
      } else {
        bankingAccount = sSignalRModules.bankingProfileData?.banking?.accounts
            ?.where((account) => account.accountId == accountId)
            .firstOrNull;
      }

      if (bankingAccount == null) {
        return;
      }

      final eurCurrency = currencyFrom(
        sSignalRModules.currenciesList,
        'EUR',
      );

      final isPageRouterNow = sRouter.stack.any((rout) => rout.name == CJAccountRouter.name);
      if (!isPageRouterNow) {
        sRouter.push(
          CJAccountRouter(
            bankingAccount: bankingAccount,
            isCJAccount: bankingAccount.isClearjuctionAccount,
            eurCurrency: eurCurrency,
          ),
        );
      }

      Future.delayed(const Duration(milliseconds: 250)).then((_) {
        showBankTransforSelect(
          sRouter.navigatorKey.currentContext!,
          bankingAccount!,
          bankingAccount.isClearjuctionAccount,
        );
      });
    }

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      await Future.delayed(const Duration(milliseconds: 650));

      func();
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            await Future.delayed(const Duration(milliseconds: 650));

            func();
          },
        ),
      );
    }
  }
}
