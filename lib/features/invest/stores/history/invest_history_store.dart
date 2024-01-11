import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/market/market_details/model/operation_history_union.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/signal_r/models/invest_positions_model.dart';

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
  OperationHistoryUnion union = const OperationHistoryUnion.loading();

  @observable
  bool nothingToLoad = false;

  @observable
  bool isLoading = false;

  @computed
  List<InvestPositionModel> get listToShow => investHistoryItems
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
  }) async {
    union = const OperationHistoryUnion.loading();
    isLoading = true;

    try {
      final investHistory = await _requestInvestHistory(
        needLoader,
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

  // При сколле вниз
  @action
  Future<void> investHistory() async {
    if (investHistoryItems.isEmpty) return;

    union = const OperationHistoryUnion.loading();
    isLoading = true;

    final investHistory = await _requestInvestHistory(
      true,
    );

    _updateInvestHistory(investHistory);

    union = const OperationHistoryUnion.loaded();

    isLoading = false;
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
  Future<List<InvestPositionModel>> _requestInvestHistory(
    bool needLoader,
  ) async {
    if (needLoader) {
      union = const OperationHistoryUnion.loading();
    }

    final response = await sNetwork.getWalletModule().getInvestHistory(
      skip: '${investHistoryItems.length}',
      take: '20',
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
