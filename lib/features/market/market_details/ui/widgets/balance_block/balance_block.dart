import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/store/operation_history.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/reccurring/store/recurring_buys_store.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

import '../../../helper/currency_from.dart';
import '../../../helper/swap_words.dart';
import 'components/balance_action_buttons.dart';

class BalanceBlock extends StatelessWidget {
  const BalanceBlock({
    super.key,
    required this.marketItem,
  });

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    return Provider<OperationHistory>(
      create: (context) =>
          OperationHistory(marketItem.symbol, null, null, null),
      builder: (context, child) => _BalanceBlockBody(
        marketItem: marketItem,
      ),
    );
  }
}

class _BalanceBlockBody extends StatelessObserverWidget {
  const _BalanceBlockBody({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final currency = currencyFrom(
      sSignalRModules.currenciesList,
      marketItem.associateAsset,
    );

    final transactionHistory = OperationHistory.of(context);

    final recurringNotifier = getIt.get<RecurringBuysStore>();
    final languageCode = Localizations.localeOf(context).languageCode;

    return SizedBox(
      height: 127,
      child: Column(
        children: [
          /*SPaddingH24(
            child: SWalletItem(
              currencyPrefix: baseCurrency.prefix,
              currencySymbol: baseCurrency.symbol,
              decline: marketItem.dayPercentChange.isNegative,
              icon: SNetworkSvg24(
                url: marketItem.iconUrl,
              ),
              primaryText: sortWordDependingLang(
                text: marketItem.name,
                swappedText: intl.walletBody_balance,
                languageCode: languageCode,
                isCapitalize: true,
              ),
              amount: volumeFormat(
                prefix: baseCurrency.prefix,
                decimal: marketItem.baseBalance,
                symbol: baseCurrency.symbol,
                accuracy: baseCurrency.accuracy,
              ),
              amountDecimal: double.parse('${marketItem.baseBalance}'),
              secondaryText: volumeFormat(
                prefix: marketItem.prefixSymbol,
                decimal: marketItem.assetBalance,
                symbol: marketItem.symbol,
                accuracy: marketItem.assetAccuracy,
              ),
              onTap: () {
                sAnalytics.walletAssetView(
                  Source.assetScreen,
                  currency.description,
                );

                onMarketItemTap(
                  context: context,
                  marketItem: marketItem,
                  currency: currency,
                  isIndexTransactionEmpty:
                      transactionHistory.operationHistoryItems.isEmpty,
                );
              },
              removeDivider: true,
              leftBlockTopPadding: _leftBlockTopPadding(),
              balanceTopMargin: 16,
              height: 75,
              rightBlockTopPadding: 16,
              showSecondaryText: !marketItem.isBalanceEmpty,
            ),
          ),
          */
          const SDivider(),
          const SpaceH16(),
          BalanceActionButtons(
            marketItem: marketItem,
          ),
          const SpaceH18(),
        ],
      ),
    );
  }

  double _leftBlockTopPadding() {
    return marketItem.isBalanceEmpty ? 26 : 16;
  }

  void onMarketItemTap({
    required BuildContext context,
    required MarketItemModel marketItem,
    required CurrencyModel currency,
    required bool isIndexTransactionEmpty,
  }) {
    if (marketItem.type == AssetType.indices) {
      if (!isIndexTransactionEmpty) {
        sRouter.push(
          TransactionHistoryRouter(
            assetName: marketItem.name,
            assetSymbol: marketItem.symbol,
          ),
        );
      }
    } else {
      navigateToWallet(context, currency);
    }
  }
}
