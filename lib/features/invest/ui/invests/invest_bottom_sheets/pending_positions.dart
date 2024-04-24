import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_positions_store.dart';
import 'package:jetwallet/features/invest/ui/invests/above_list_line.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/table/placeholder/simple_placeholder.dart';
import 'package:simple_networking/modules/signal_r/models/invest_instruments_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../../utils/helpers/currency_from.dart';
import '../invest_line.dart';
import '../main_invest_block.dart';

class PendingInvestList extends StatelessObserverWidget {
  const PendingInvestList({
    this.instrument,
  });

  final InvestInstrumentModel? instrument;

  @override
  Widget build(BuildContext context) {
    final investPositionsStore = getIt.get<InvestPositionsStore>();
    final investStore = getIt.get<InvestDashboardStore>();
    final currencies = sSignalRModules.currenciesList;
    final currency = currencyFrom(currencies, 'USDT');

    InvestInstrumentModel getInstrumentBySymbol(String symbol) {
      final instrument = investPositionsStore.instrumentsList
          .where(
            (element) => element.symbol == symbol,
          )
          .toList();

      return instrument[0];
    }

    Decimal getGroupedAmount(String symbol) {
      final groupedPositions = investPositionsStore.pendingList
          .where(
            (element) => element.symbol == symbol,
          )
          .toList();
      var amount = Decimal.zero;
      for (var i = 0; i < groupedPositions.length; i++) {
        amount += groupedPositions[i].amount ?? Decimal.zero;
      }

      return amount;
    }

    return Observer(
      builder: (BuildContext context) {
        return Column(
          children: [
            Observer(
              builder: (BuildContext context) {
                return MainInvestBlock(
                  pending: Decimal.zero,
                  amount: investStore.totalPendingAmount,
                  balance:
                      instrument != null ? getGroupedAmount(instrument!.symbol ?? '') : investStore.totalPendingAmount,
                  percent: investStore.totalYield,
                  onShare: () {},
                  currency: currency,
                  title: intl.invest_pending_invest,
                  showAmount: false,
                  showPercent: false,
                  showShare: false,
                );
              },
            ),
            const SpaceH4(),
            Observer(
              builder: (BuildContext context) {
                final listToShow = instrument != null
                    ? investPositionsStore.pendingList
                        .where(
                          (element) => element.symbol == instrument?.symbol,
                        )
                        .toList()
                    : investPositionsStore.pendingList;
                if (listToShow.isEmpty) {
                  return SPlaceholder(
                    size: SPlaceholderSize.l,
                    text: intl.wallet_simple_account_empty,
                  );
                }

                return AboveListLine(
                  mainColumn: instrument != null ? intl.invest_in_group : intl.invest_list_instrument,
                  secondaryColumn: '${intl.invest_list_amount} (${currency.symbol})',
                  lastColumn: intl.invest_price,
                  onCheckboxTap: investPositionsStore.setIsActiveGrouped,
                );
              },
            ),
            Observer(
              builder: (BuildContext context) {
                final listToShow = instrument != null
                    ? investPositionsStore.pendingList
                        .where(
                          (element) => element.symbol == instrument?.symbol,
                        )
                        .toList()
                    : investPositionsStore.pendingList;

                return Column(
                  children: [
                    for (final position in listToShow) ...[
                      InvestLine(
                        priceAccuracy: getInstrumentBySymbol(position.symbol ?? '').priceAccuracy ?? 2,
                        currency: currencyFrom(currencies, getInstrumentBySymbol(position.symbol ?? '').name ?? ''),
                        price: position.pendingPrice ?? Decimal.zero,
                        operationType: position.direction ?? Direction.undefined,
                        isPending: true,
                        amount: position.amount ?? Decimal.zero,
                        leverage: Decimal.fromInt(position.multiplicator ?? 0),
                        isGroup: false,
                        historyCount: 1,
                        profit: investStore.getProfitByPosition(position),
                        profitPercent: investStore.getYieldByPosition(position),
                        accuracy: currency.accuracy,
                        onTap: () {
                          sRouter.push(
                            PendingInvestManageRouter(
                              position: position,
                              instrument: getInstrumentBySymbol(position.symbol ?? ''),
                            ),
                          );
                        },
                      ),
                      if (listToShow.last.id != position.id) const SDivider(),
                    ],
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
