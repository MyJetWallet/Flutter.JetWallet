import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/anchors/anchors_helper.dart';
import 'package:jetwallet/core/services/anchors/models/convert_confirmation_model/convert_confirmation_model.dart';
import 'package:jetwallet/core/services/anchors/models/crypto_deposit/crypto_deposit_model.dart';
import 'package:jetwallet/core/services/remote_config/models/remote_config_union.dart';
import 'package:jetwallet/core/services/route_query_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorized_union.dart';
import 'package:jetwallet/features/app/timer_service.dart';
import 'package:jetwallet/features/cj_banking_accounts/screens/show_account_details_screen.dart';
import 'package:jetwallet/features/wallet/helper/market_item_from.dart';
import 'package:simple_networking/modules/analytic_records/models/anchor_record.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

class AnchorsService {
  static const _tag = '[AnchorsService]';

  Future<void> setAnchor(AnchorRecordModel anchorRecord) async {
    await getIt.get<SNetwork>().simpleNetworking.getAnalyticApiModule().postAddAnchor(anchorRecord);
  }

  void handleDeeplink({required String type, required Map<String, String> metadata}) {
    if (metadata.isEmpty) {
      if (kDebugMode) {
        print('$_tag error: Metadata is null');
      }
      return;
    }

    print('$_tag handle: $type, $metadata');
    switch (type) {
      case AnchorsHelper.anchorTypeCryptoDeposit:
        {
          pushCryptoDepositScreen(metadata);
        }
      case AnchorsHelper.anchorTypeConvertConfirmation:
        {
          pushConvertConfirmScreen(metadata);
        }
      case AnchorsHelper.anchorTypeMarketDetails:
        {
          pushMarketDetailsScreen(metadata);
        }
      case AnchorsHelper.anchorTypeBankingAccountDetails:
        {
          pushBankingAccountDetailsScreen(metadata);
        }
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

      await sRouter.push(
        CryptoDepositRouter(
          cryptoDepositModel: CryptoDepositModel(
            assetSymbol: symbol,
          ),
        ),
      );
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
            await sRouter.push(
              CryptoDepositRouter(
                cryptoDepositModel: CryptoDepositModel(
                  assetSymbol: symbol,
                ),
              ),
            );
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
    } else {
      getIt<RouteQueryService>().addToQuery(
        RouteQueryModel(
          func: () async {
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

      final market = marketItemFrom(
        sSignalRModules.marketItems,
        symbol,
      );

      await sRouter.push(
        MarketDetailsRouter(
          marketItem: market,
        ),
      );
    }

    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home &&
        getIt<TimerService>().isPinScreenOpen == false) {
      sRouter.popUntilRoot();

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
      sRouter.popUntilRoot();

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
}
