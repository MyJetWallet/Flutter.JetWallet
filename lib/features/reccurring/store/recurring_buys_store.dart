import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/currencies_service/currencies_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/actions/action_buy/action_buy.dart';
import 'package:jetwallet/features/reccurring/helper/recurring_buys_name.dart';
import 'package:jetwallet/features/reccurring/helper/recurring_buys_operation_name.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_model.dart';
import 'package:simple_networking/modules/wallet_api/models/recurring_manage/recurring_delete_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/recurring_manage/recurring_manage_request_model.dart';
part 'recurring_buys_store.g.dart';

@lazySingleton
class RecurringBuysStore = _RecurringBuysStoreBase with _$RecurringBuysStore;

abstract class _RecurringBuysStoreBase with Store {
  _RecurringBuysStoreBase() {
    recurringBuys = sSignalRModules.recurringBuys;

    _init();
  }

  static final _logger = Logger('RecurringBuysNotifier');

  @observable
  ObservableList<RecurringBuysModel> recurringBuys = ObservableList.of([]);

  @computed
  RecurringBuysStatus get recurringBuysStatus {
    if (recurringBuys.isNotEmpty) {
      final active = recurringBuys.where(
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
    if (recurringBuys.isNotEmpty) {
      final activeRecurringBuysList = recurringBuys
          .where((element) => element.status == RecurringBuysStatus.active);

      if (activeRecurringBuysList.isNotEmpty) {
        return RecurringBuysStatus.active;
      }
    }

    return RecurringBuysStatus.empty;
  }

  @computed
  bool get recurringPausedNavigateToHistory {
    if (recurringBuys.isNotEmpty) {
      final pausedRecurringBuysList = recurringBuys
          .where((element) => element.status == RecurringBuysStatus.paused);

      if (pausedRecurringBuysList.isNotEmpty &&
          pausedRecurringBuysList.length == recurringBuys.length &&
          recurringBuys.length > 1) {
        return true;
      }
    }

    return false;
  }

  @action
  void _init() {
    recurringBuys.sort((a, b) => a.toAsset.compareTo(b.toAsset));
    recurringBuys = ObservableList.of([...recurringBuys]);
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
    if (recurringBuys.isNotEmpty) {
      final activeRecurringBuysList = recurringBuys
          .where((element) => element.status == RecurringBuysStatus.active);

      if (activeRecurringBuysList.isNotEmpty) {
        return RecurringBuysStatus.active;
      }

      final pausedRecurringBuysList = recurringBuys
          .where((element) => element.status == RecurringBuysStatus.paused);

      if (pausedRecurringBuysList.isNotEmpty &&
          pausedRecurringBuysList.length == recurringBuys.length) {
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
      showBuyAction(
        from: from,
        context: context,
        fromCard: false,
        shouldPop: false,
        showRecurring: true,
      );

      return;
    }

    if (typeByAllRecurringBuys() == RecurringBuysStatus.paused &&
        recurringPausedNavigateToHistory) {
      sRouter.push(HistoryRecurringBuysRouter());
    } else {
      sRouter.push(
        ShowRecurringInfoActionRouter(
          recurringItem: recurringBuys[0],
          assetName: recurringBuys[0].toAsset,
        ),
      );
    }
  }

  @action
  String totalRecurringByAsset({
    required String asset,
  }) {
    final currencies = sSignalRModules.getCurrencies;
    final baseCurrency = sSignalRModules.baseCurrency;

    var accumulate = Decimal.zero;
    var calculateTotal = false;

    for (final element in recurringBuys) {
      if (element.toAsset == asset) {
        if (element.status == RecurringBuysStatus.active) {
          calculateTotal = true;
        }
      }
    }

    if (!calculateTotal) {
      return '';
    }

    for (final element in recurringBuys) {
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
    final currencies = sSignalRModules.getCurrencies;

    final array = <RecurringBuysModel>[];

    for (final element in recurringBuys) {
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
        ? '${intl.recurringBuys_recurring_pl_prefix}'
            '${recurringBuysOperationName(array.first.scheduleType)} '
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
    final currencies = sSignalRModules.getCurrencies;
    final baseCurrency = sSignalRModules.baseCurrency;

    var accumulate = Decimal.zero;
    for (final element in recurringBuys) {
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
    for (final element in recurringBuys) {
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
