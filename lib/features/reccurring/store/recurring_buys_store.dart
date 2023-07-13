import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/actions/action_buy/action_buy.dart';
import 'package:jetwallet/features/actions/action_send/widgets/show_send_timer_alert_or.dart';
import 'package:jetwallet/features/reccurring/helper/recurring_buys_name.dart';
import 'package:jetwallet/features/reccurring/helper/recurring_buys_operation_name.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_model.dart';
import 'package:simple_networking/modules/wallet_api/models/recurring_manage/recurring_delete_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/recurring_manage/recurring_manage_request_model.dart';
part 'recurring_buys_store.g.dart';

@lazySingleton
class RecurringBuysStore = _RecurringBuysStoreBase with _$RecurringBuysStore;

abstract class _RecurringBuysStoreBase with Store {
  _RecurringBuysStoreBase();

  static final _logger = Logger('RecurringBuysNotifier');

  //@observable
  //ObservableList<RecurringBuysModel> recurringBuys = ObservableList.of([]);

  @computed
  List<RecurringBuysModel> get recurringBuys => sSignalRModules.recurringBuys;

  @computed
  List<RecurringBuysModel> get recurringBuysFiltred {
    final localList = recurringBuys.toList();

    localList.sort((a, b) => a.toAsset.compareTo(b.toAsset));

    return localList.toList();
  }

  @computed
  RecurringBuysStatus get recurringBuysStatus {
    if (recurringBuysFiltred.isNotEmpty) {
      final active = recurringBuysFiltred.where(
        (element) =>
            element.status == RecurringBuysStatus.active ||
            element.status == RecurringBuysStatus.paused,
      );
      if (active.isNotEmpty) {
        return RecurringBuysStatus.active;
      }
    }

    return RecurringBuysStatus.empty;
  }

  @computed
  RecurringBuysStatus get typeActiveOrEmpty {
    if (recurringBuysFiltred.isNotEmpty) {
      final activeRecurringBuysList = recurringBuysFiltred
          .where((element) => element.status == RecurringBuysStatus.active);

      if (activeRecurringBuysList.isNotEmpty) {
        return RecurringBuysStatus.active;
      }
    }

    return RecurringBuysStatus.empty;
  }

  @computed
  bool get recurringPausedNavigateToHistory {
    if (recurringBuysFiltred.isNotEmpty) {
      final pausedRecurringBuysList = recurringBuysFiltred
          .where((element) => element.status == RecurringBuysStatus.paused);

      if (pausedRecurringBuysList.isNotEmpty &&
          pausedRecurringBuysList.length == recurringBuysFiltred.length &&
          recurringBuysFiltred.length > 1) {
        return true;
      }
    }

    return false;
  }

  @action
  RecurringBuysStatus type(String symbol) {
    final recurringBuysList = _recurringBuyAssetList(symbol);

    if (recurringBuysList.isNotEmpty) {
      final activeRecurringBuysList = recurringBuysList
          .where((element) => element.status == RecurringBuysStatus.active);

      if (activeRecurringBuysList.isNotEmpty) {
        return RecurringBuysStatus.active;
      }

      final pausedRecurringBuysList = recurringBuysList
          .where((element) => element.status == RecurringBuysStatus.paused);

      if (pausedRecurringBuysList.isNotEmpty &&
          pausedRecurringBuysList.length == recurringBuysList.length) {
        return RecurringBuysStatus.paused;
      }
    }

    return RecurringBuysStatus.empty;
  }

  @action
  RecurringBuysStatus typeByAllRecurringBuys() {
    if (recurringBuysFiltred.isNotEmpty) {
      final activeRecurringBuysList = recurringBuysFiltred
          .where((element) => element.status == RecurringBuysStatus.active);

      if (activeRecurringBuysList.isNotEmpty) {
        return RecurringBuysStatus.active;
      }

      final pausedRecurringBuysList = recurringBuysFiltred
          .where((element) => element.status == RecurringBuysStatus.paused);

      if (pausedRecurringBuysList.isNotEmpty &&
          pausedRecurringBuysList.length == recurringBuysFiltred.length) {
        return RecurringBuysStatus.paused;
      }
    }

    return RecurringBuysStatus.empty;
  }

  @action
  void handleNavigate(BuildContext context, [Source? from]) {
    if (typeByAllRecurringBuys() == RecurringBuysStatus.active) {
      sRouter.push(HistoryRecurringBuysRouter());

      return;
    }

    if (typeByAllRecurringBuys() == RecurringBuysStatus.empty) {
      showSendTimerAlertOr(
        context: context,
        or: () {
          showBuyAction(
            from: from,
            context: context,
            shouldPop: false,
            showRecurring: true,
          );
        },
        from: BlockingType.deposit,
      );

      return;
    }

    if (typeByAllRecurringBuys() == RecurringBuysStatus.paused &&
        recurringPausedNavigateToHistory) {
      sRouter.push(HistoryRecurringBuysRouter());
    } else {
      sRouter.push(
        ShowRecurringInfoActionRouter(
          recurringItem: recurringBuysFiltred[0],
          assetName: recurringBuysFiltred[0].toAsset,
        ),
      );
    }
  }

  @action
  String totalRecurringByAsset({
    required String asset,
  }) {
    final currencies = sSignalRModules.currenciesList;
    final baseCurrency = sSignalRModules.baseCurrency;

    var accumulate = Decimal.zero;
    var calculateTotal = false;

    for (final element in recurringBuysFiltred) {
      if (element.toAsset == asset) {
        if (element.status == RecurringBuysStatus.active) {
          calculateTotal = true;
        }
      }
    }

    if (!calculateTotal) {
      return '';
    }

    for (final element in recurringBuysFiltred) {
      if (element.toAsset == asset) {
        for (final currency in currencies) {
          if (currency.symbol == element.fromAsset &&
              element.status == RecurringBuysStatus.active) {
            accumulate += _convertToUsd(element.fromAsset, element.fromAmount!);
          }
        }
      }
    }

    final total = _priceVolumeFormat(accumulate);

    return '${baseCurrency.prefix}$total';
  }

  @action
  String recurringBannerTitle({
    required String asset,
    required BuildContext context,
  }) {
    final currencies = sSignalRModules.currenciesList;

    final array = <RecurringBuysModel>[];

    for (final element in recurringBuysFiltred) {
      if (element.toAsset == asset) {
        for (final currency in currencies) {
          if (currency.symbol == element.fromAsset) {
            array.add(element);
          }
        }
      }
    }

    if (array.isEmpty) {
      return recurringBuysName(RecurringBuysStatus.empty);
    }

    if (array.length == 1 && type(asset) == RecurringBuysStatus.paused) {
      return recurringBuysName(RecurringBuysStatus.paused);
    }

    if (array.length > 1 && _allInPaused(array)) {
      return recurringBuysName(RecurringBuysStatus.paused);
    }

    return array.length == 1 && array.first.status == RecurringBuysStatus.active
        ? '${recurringBuysOperationName(array.first.scheduleType)} '
            '${intl.recurringBuys_recurring}'
            ' ${intl.recurringBuys_buy2}'
        : '${intl.account_recurringBuy} (${array.length})';
  }

  @action
  bool _allInPaused(List<RecurringBuysModel> array) {
    for (final element in array) {
      if (element.status != RecurringBuysStatus.paused) {
        return false;
      }
    }

    return true;
  }

  @action
  String totalByAllRecurring() {
    final currencies = sSignalRModules.currenciesList;
    final baseCurrency = sSignalRModules.baseCurrency;

    var accumulate = Decimal.zero;
    for (final element in recurringBuysFiltred) {
      if (element.status == RecurringBuysStatus.active) {
        for (final currency in currencies) {
          if (currency.symbol == element.fromAsset) {
            accumulate += _convertToUsd(element.toAsset, element.fromAmount!);
          }
        }
      }
    }

    final total = _priceVolumeFormat(accumulate);

    return '${baseCurrency.prefix}$total';
  }

  @action
  String price({
    required String asset,
    required double amount,
  }) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final assetBasePriceInUsd = _convertToUsd(asset, amount);

    final priceInUsd = _priceVolumeFormat(assetBasePriceInUsd);

    return '${baseCurrency.prefix}$priceInUsd';
  }

  @action
  String _priceVolumeFormat(Decimal amount) {
    final priceInUsd = volumeFormat(
      decimal: amount,
      accuracy: 2,
      symbol: '',
    );

    return priceInUsd;
  }

  @action
  List<RecurringBuysModel> _recurringBuyAssetList(String asset) {
    final list = <RecurringBuysModel>[];
    for (final element in recurringBuysFiltred) {
      if (element.toAsset == asset) {
        list.add(element);
      }
    }

    return list;
  }

  @action
  Decimal _convertToUsd(String asset, double amount) {
    final assetBasePriceInUsd = calculateBaseBalanceWithReader(
      assetSymbol: asset,
      assetBalance: Decimal.parse('$amount'),
    );

    return assetBasePriceInUsd;
  }

  @action
  Future<void> switchRecurringStatus({
    required bool isEnable,
    required String instructionId,
  }) async {
    _logger.log(notifier, 'switchRecurringStatus');

    try {
      final model = RecurringManageRequestModel(
        instructionId: instructionId,
        isEnable: isEnable,
      );

      final _ =
          await sNetwork.getWalletModule().postSwitchRecurringStatus(model);
    } catch (e) {
      _logger.log(stateFlow, 'switchRecurringStatus', e);
    }
  }

  @action
  Future<void> removeRecurringBuy(
    String instructionId,
  ) async {
    _logger.log(notifier, 'removeRecurringBuy');

    try {
      final model = RecurringDeleteRequestModel(
        instructionId: instructionId,
      );

      final _ =
          await sNetwork.getWalletModule().deleteRemoveRecurringBuy(model);
    } catch (e) {
      _logger.log(stateFlow, 'removeRecurringBuy', e);
    }
  }

  @action
  bool activeOrPausedType(String symbol) {
    if (type(symbol) == RecurringBuysStatus.empty) {
      return false;
    }

    return true;
  }
}
