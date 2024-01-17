import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:jetwallet/features/market/market_details/model/operation_history_union.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';
import 'package:simple_networking/modules/wallet_api/models/invest/new_invest_request_model.dart';

import '../../../../utils/enum.dart';
import '../../helpers/invest_period_info.dart';
import '../dashboard/invest_positions_store.dart';

part 'invest_history_store.g.dart';

class InvestHistory extends _InvestHistoryBase with _$InvestHistory {
  InvestHistory();

  static _InvestHistoryBase of(BuildContext context) => Provider.of<InvestHistory>(context, listen: false);
}

abstract class _InvestHistoryBase with Store {
  _InvestHistoryBase() {
    getIt<EventBus>().on<GetNewHistoryEvent>().listen((event) {
      refreshHistory(needLoader: false);
    });
  }

  @observable
  ScrollController scrollController = ScrollController();

  @observable
  ObservableList<InvestPositionModel> investHistoryItems = ObservableList.of([]);

  @observable
  ObservableList<InvestPositionModel> investPendingItems = ObservableList.of([]);

  @observable
  ObservableList<InvestSummaryModel> investHistorySummaryItems = ObservableList.of([]);

  @observable
  OperationHistoryUnion union = const OperationHistoryUnion.loading();

  @observable
  OperationHistoryUnion unionPending = const OperationHistoryUnion.loading();

  @observable
  OperationHistoryUnion unionSummary = const OperationHistoryUnion.loading();

  @observable
  bool nothingToLoad = false;

  @observable
  bool nothingToLoadPending = false;

  @observable
  bool isLoading = false;

  @observable
  bool isLoadingPending = false;

  @observable
  bool isLoadingSummary = false;

  @computed
  List<InvestPositionModel> get listToShow => investHistoryItems
    .where(
      (i) => i.status == PositionStatus.closed || i.status == PositionStatus.cancelled,
    )
    .toList();

  @computed
  List<InvestPositionModel> get listToShowPending => investPendingItems
    .where(
      (i) => i.status == PositionStatus.closed || i.status == PositionStatus.cancelled,
    )
    .toList();

  @action
  Future<bool> refreshHistory({bool needLoader = true}) async {
    getIt.get<SimpleLoggerService>().log(
          level: Level.info,
          place: 'Invest History Store',
          message: 'refreshHistory',
        );

    investHistoryItems = ObservableList.of([]);

    await initInvestHistory(needLoader: needLoader);

    return true;
  }

  var detailsShowed = false;

  @action
  Future<void> initInvestHistory({
    bool needLoader = true,
    String? symbol,
  }) async {
    union = const OperationHistoryUnion.loading();
    isLoading = true;

    try {
      final investHistory = await _requestInvestHistory(
        needLoader,
        symbol,
      );

      _updateInvestHistory(
        investHistory,
        isbgUpdate: !needLoader,
      );

      union = const OperationHistoryUnion.loaded();

    } catch (e) {
      sNotification.showError(
        intl.something_went_wrong,
        id: 1,
      );

      union = const OperationHistoryUnion.error();
    }

    isLoading = false;
  }

  @action
  Future<void> initInvestPending({
    bool needLoader = true,
    String? symbol,
  }) async {
    unionPending = const OperationHistoryUnion.loading();
    isLoadingPending = true;

    try {
      final investHistory = await _requestInvestPending(
        needLoader,
        symbol,
      );

      _updateInvestPending(
        investHistory,
        isbgUpdate: !needLoader,
      );

      unionPending = const OperationHistoryUnion.loaded();

    } catch (e) {
      sNotification.showError(
        intl.something_went_wrong,
        id: 1,
      );

      unionPending = const OperationHistoryUnion.error();
    }

    isLoadingPending = false;
  }

  @action
  Future<void> initInvestHistorySummary({
    bool needLoader = true,
  }) async {
    unionSummary = const OperationHistoryUnion.loading();
    isLoadingSummary = true;

    try {
      final investHistorySummary = await _requestInvestHistorySummary(
        needLoader,
      );


      final investPositionsStore = getIt.get<InvestPositionsStore>();
      var amount = Decimal.zero;
      var profit = Decimal.zero;
      var percent = Decimal.zero;

      if (investHistorySummary.isNotEmpty) {
        for (final instrument in investHistorySummary) {
          amount += instrument.amount ?? Decimal.zero;
          profit += instrument.amountPl ?? Decimal.zero;
        }
        if (amount != Decimal.zero && profit != Decimal.zero) {
          percent = Decimal.fromJson('${(Decimal.fromInt(100) * profit / amount).toDouble()}');
        }
      }

      investPositionsStore.setTotals(amount, profit, percent);
      investPositionsStore.setSummary(investHistorySummary);

      investHistorySummaryItems = ObservableList.of(investHistorySummary);

      unionSummary = const OperationHistoryUnion.loaded();

    } catch (e) {
      sNotification.showError(
        intl.something_went_wrong,
        id: 1,
      );

      unionSummary = const OperationHistoryUnion.error();
    }

    isLoadingSummary = false;
  }

  // При сколле вниз
  @action
  Future<void> investHistory(String? symbol) async {
    if (investHistoryItems.isEmpty) return;

    union = const OperationHistoryUnion.loading();
    isLoading = true;

    final investHistory = await _requestInvestHistory(
      true,
      symbol,
    );

    _updateInvestHistory(investHistory);

    union = const OperationHistoryUnion.loaded();

    isLoading = false;
  }

  @action
  Future<void> investHistoryPending(String? symbol) async {
    if (investPendingItems.isEmpty) return;

    unionPending = const OperationHistoryUnion.loading();
    isLoadingPending = true;

    final investHistory = await _requestInvestPending(
      true,
      symbol,
    );

    _updateInvestPending(investHistory);

    unionPending = const OperationHistoryUnion.loaded();

    isLoadingPending = false;
  }

  @action
  void _updateInvestHistory(
    List<InvestPositionModel> items, {
    bool isbgUpdate = false,
  }) {
    if (items.isEmpty) {
      nothingToLoad = true;
      union = const OperationHistoryUnion.loaded();
    } else {
      if (isbgUpdate) {
        investHistoryItems = ObservableList.of(
          _filterUnusedInvestTypeItemsFrom(items),
        );

        if (scrollController.hasClients) {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.linear,
          );
        }

        union = const OperationHistoryUnion.loaded();
      } else {
        investHistoryItems = ObservableList.of(
          investHistoryItems + _filterUnusedInvestTypeItemsFrom(items),
        );

        union = const OperationHistoryUnion.loaded();
      }
    }
  }

  @action
  void _updateInvestPending(
    List<InvestPositionModel> items, {
    bool isbgUpdate = false,
  }) {
    if (items.isEmpty) {
      nothingToLoadPending = true;
      unionPending = const OperationHistoryUnion.loaded();
    } else {
      if (isbgUpdate) {
        investPendingItems = ObservableList.of(
          _filterUnusedInvestTypeItemsFrom(items),
        );

        if (scrollController.hasClients) {
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.linear,
          );
        }

        unionPending = const OperationHistoryUnion.loaded();
      } else {
        investPendingItems = ObservableList.of(
          investPendingItems + _filterUnusedInvestTypeItemsFrom(items),
        );

        unionPending = const OperationHistoryUnion.loaded();
      }
    }
  }

  @action
  Future<List<InvestPositionModel>> _requestInvestHistory(
    bool needLoader,
    String? symbol,
  ) async {
    if (needLoader) {
      union = const OperationHistoryUnion.loading();
    }

    final response = await sNetwork.getWalletModule().getInvestHistory(
      skip: '${investHistoryItems.length}',
      take: '20',
      symbol: symbol,
    );

    return response.data!;
  }

  @action
  Future<List<InvestPositionModel>> _requestInvestPending(
    bool needLoader,
    String? symbol,
  ) async {
    if (needLoader) {
      unionPending = const OperationHistoryUnion.loading();
    }

    final response = await sNetwork.getWalletModule().getInvestHistoryCanceled(
      skip: '${investPendingItems.length}',
      take: '20',
      symbol: symbol,
    );

    return response.data!;
  }

  @action
  Future<List<InvestSummaryModel>> _requestInvestHistorySummary(
    bool needLoader,
  ) async {
    if (needLoader) {
      unionSummary = const OperationHistoryUnion.loading();
    }

    final investStore = getIt.get<InvestDashboardStore>();

    final response = await sNetwork.getWalletModule().getInvestHistorySummary(
      dateFrom: '${DateTime.now().subtract(
        Duration(
          days: getDaysByPeriod(investStore.period),
        ),
      )}',
      dateTo: '${DateTime.now()}',
    );

    return response.data!;
  }
}

List<InvestPositionModel> _filterUnusedInvestTypeItemsFrom(
  List<InvestPositionModel> items,
) {
  final filteredItems = items
    .where(
      (i) => i.status == PositionStatus.closed ||
      i.status == PositionStatus.cancelled,
    ).toList();

  return filteredItems;
}
