import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/recurring_manage/model/recurring_delete_request_model.dart';
import '../../../../../service/services/recurring_manage/model/recurring_manage_request_model.dart';
import '../../../../../service/services/signal_r/model/recurring_buys_model.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../helpers/calculate_base_balance.dart';
import '../../../helpers/formatting/base/volume_format.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../actions/action_buy/action_buy.dart';
import '../../actions/action_recurring_info/action_recurring_info.dart';
import '../../transaction_history/components/history_recurring_buys.dart';
import '../helper/recurring_buys_name.dart';
import '../helper/recurring_buys_operation_name.dart';
import '../helper/recurring_buys_status_name.dart';
import 'recurring_buys_state.dart';

class RecurringBuysNotifier extends StateNotifier<RecurringBuysState> {
  RecurringBuysNotifier(
    this.read,
    this.recurringBuys,
  ) : super(
          const RecurringBuysState(
            recurringBuys: <RecurringBuysModel>[],
          ),
        ) {
    _init();
  }

  final Reader read;
  final List<RecurringBuysModel> recurringBuys;

  static final _logger = Logger('RecurringBuysNotifier');

  void _init() {
    state = state.copyWith(recurringBuys: [...recurringBuys]);
  }

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

  RecurringBuysStatus typeByAllRecurringBuys() {
    if (state.recurringBuys.isNotEmpty) {
      final activeRecurringBuysList = state.recurringBuys
          .where((element) => element.status == RecurringBuysStatus.active);

      if (activeRecurringBuysList.isNotEmpty) {
        return RecurringBuysStatus.active;
      }

      final pausedRecurringBuysList = state.recurringBuys
          .where((element) => element.status == RecurringBuysStatus.paused);

      if (pausedRecurringBuysList.isNotEmpty &&
          pausedRecurringBuysList.length == state.recurringBuys.length) {
        return RecurringBuysStatus.paused;
      }
    }

    return RecurringBuysStatus.empty;
  }

  void handleNavigate(BuildContext context) {
    if (typeByAllRecurringBuys() == RecurringBuysStatus.active) {
      navigatorPush(context, const HistoryRecurringBuys());
      return;
    }

    if (typeByAllRecurringBuys() == RecurringBuysStatus.empty) {
      showBuyAction(
        context: context,
        fromCard: false,
        shouldPop: false,
        showRecurring: true,
      );
      return;
    }

    if (typeByAllRecurringBuys() == RecurringBuysStatus.paused &&
        state.recurringPausedNavigateToHistory) {
      navigatorPush(context, const HistoryRecurringBuys());
    } else {
      navigatorPush(
        context,
        ShowRecurringInfoAction(
          recurringItem: state.recurringBuys[0],
          assetName: state.recurringBuys[0].toAsset,
        ),
      );
    }
  }

  String totalRecurringByAsset({
    required String asset,
  }) {
    final currencies = read(currenciesPod);
    final baseCurrency = read(baseCurrencyPod);

    var accumulate = Decimal.zero;
    var calculateTotal = false;

    for (final element in state.recurringBuys) {
      if (element.toAsset == asset) {
        if (element.status == RecurringBuysStatus.active) {
          calculateTotal = true;
        }
      }
    }

    if (!calculateTotal) {
      return '';
    }

    for (final element in state.recurringBuys) {
      if (element.toAsset == asset) {
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

  String recurringBannerTitle({
    required String asset,
  }) {
    final currencies = read(currenciesPod);

    final array = <RecurringBuysModel>[];

    for (final element in state.recurringBuys) {
      if (element.toAsset == asset) {
        for (final currency in currencies) {
          if (currency.symbol == element.fromAsset) {
            array.add(element);
          }
        }
      }
    }

    if (array.length == 1 && array.first.status == RecurringBuysStatus.active) {
      return '${recurringBuysOperationName(array.first.scheduleType)} buy'
          ' ${totalRecurringByAsset(asset: asset)}';
    }

    if (array.length > 1 && _differentRecurringType(array)) {
      return 'Recurring buy (${array.length})';
    } else {
      if (type(asset) == RecurringBuysStatus.paused) {
        return recurringBuysName(RecurringBuysStatus.paused);
      } else if (type(asset) == RecurringBuysStatus.empty) {
        return recurringBuysName(RecurringBuysStatus.empty);
      }
      return 'Recurring buy ${totalRecurringByAsset(asset: asset)}';
    }
  }

  bool _differentRecurringType(List<RecurringBuysModel> array) {
    var prevAsset = '';

    for (final element in state.recurringBuys) {
      if (prevAsset.isEmpty) {
        prevAsset = element.toAsset;
      } else {
        if (prevAsset != element.toAsset) {
          return true;
        }
      }
    }

    return false;
  }

  String totalByAllRecurring() {
    final currencies = read(currenciesPod);
    final baseCurrency = read(baseCurrencyPod);

    var accumulate = Decimal.zero;
    for (final element in state.recurringBuys) {
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

  String price({
    required String asset,
    required double amount,
  }) {
    final baseCurrency = read(baseCurrencyPod);
    final assetBasePriceInUsd = _convertToUsd(asset, amount);

    final priceInUsd = _priceVolumeFormat(assetBasePriceInUsd);

    return '${baseCurrency.prefix}$priceInUsd';
  }

  String _priceVolumeFormat(Decimal amount) {
    final priceInUsd = volumeFormat(
      decimal: amount,
      accuracy: 2,
      symbol: '',
    );

    return priceInUsd;
  }

  List<RecurringBuysModel> _recurringBuyAssetList(String asset) {
    final list = <RecurringBuysModel>[];
    for (final element in state.recurringBuys) {
      if (element.toAsset == asset) {
        list.add(element);
      }
    }

    return list;
  }

  Decimal _convertToUsd(String asset, double amount) {
    final assetBasePriceInUsd = calculateBaseBalanceWithReader(
      read: read,
      assetSymbol: asset,
      assetBalance: Decimal.parse('$amount'),
    );

    return assetBasePriceInUsd;
  }

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

      await read(recurringManageServicePod).set(model);
    } catch (e) {
      _logger.log(stateFlow, 'switchRecurringStatus', e);
    }
  }

  Future<void> removeRecurringBuy(
    String instructionId,
  ) async {
    _logger.log(notifier, 'removeRecurringBuy');

    try {
      final model = RecurringDeleteRequestModel(
        instructionId: instructionId,
      );

      await read(recurringManageServicePod).remove(model);
    } catch (e) {
      _logger.log(stateFlow, 'removeRecurringBuy', e);
    }
  }

  bool activeOrPausedType(String symbol) {
    if (type(symbol) == RecurringBuysStatus.empty) {
      return false;
    }

    return true;
  }
}
