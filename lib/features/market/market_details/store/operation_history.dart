import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/market/market_details/model/operation_history_union.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_request_model.dart'
    as oh_req;
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart'
    as oh_resp;

part 'operation_history.g.dart';

class OperationHistory extends _OperationHistoryBase with _$OperationHistory {
  OperationHistory(String? assetId) : super(assetId);

  static _OperationHistoryBase of(BuildContext context) =>
      Provider.of<OperationHistory>(context, listen: false);
}

abstract class _OperationHistoryBase with Store {
  _OperationHistoryBase(this.assetId);

  final String? assetId;

  static final _logger = Logger('OperationHistoryStore');

  @observable
  ObservableList<oh_resp.OperationHistoryItem> operationHistoryItems =
      ObservableList.of([]);

  @observable
  OperationHistoryUnion union = const OperationHistoryUnion.loading();

  @observable
  bool nothingToLoad = false;

  @action
  Future<void> initOperationHistory() async {
    _logger.log(notifier, 'initOperationHistory');
    union = const OperationHistoryUnion.loading();

    try {
      final operationHistory = await _requestOperationHistory(
        oh_req.OperationHistoryRequestModel(
          assetId: assetId,
          batchSize: 20,
        ),
      );

      _updateOperationHistory(operationHistory.operationHistory);

      union = const OperationHistoryUnion.loaded();
    } catch (e) {
      print(e);

      _logger.log(stateFlow, 'initOperationHistory', e);

      sNotification.showError(
        intl.something_went_wrong,
        id: 1,
      );

      union = const OperationHistoryUnion.error();
    }
  }

  @action
  Future<void> operationHistory(String? assetId) async {
    _logger.log(notifier, 'operationHistory');

    try {
      final operationHistory = await _requestOperationHistory(
        oh_req.OperationHistoryRequestModel(
          assetId: assetId,
          batchSize: 20,
          lastDate: operationHistoryItems.last.timeStamp,
        ),
      );

      _updateOperationHistory(operationHistory.operationHistory);
    } catch (e) {
      _logger.log(stateFlow, 'operationHistory', e);

      sNotification.showError(
        intl.something_went_wrong,
        id: 2,
      );

      union = const OperationHistoryUnion.error();
    }
  }

  @action
  void _updateOperationHistory(List<oh_resp.OperationHistoryItem> items) {
    if (items.isEmpty) {
      nothingToLoad = true;
      union = const OperationHistoryUnion.loaded();
    } else {
      operationHistoryItems = ObservableList.of(
        operationHistoryItems + _filterUnusedOperationTypeItemsFrom(items),
      );
      union = const OperationHistoryUnion.loaded();
    }
  }

  @action
  Future<oh_resp.OperationHistoryResponseModel> _requestOperationHistory(
    oh_req.OperationHistoryRequestModel model,
  ) async {
    union = const OperationHistoryUnion.loading();

    final response =
        await sNetwork.getWalletModule().getOperationHistory(model);

    return response.data!;
  }
}

// TODO(Vova): remove when all types will be properly sorted on the backend.
List<oh_resp.OperationHistoryItem> _filterUnusedOperationTypeItemsFrom(
  List<oh_resp.OperationHistoryItem> items,
) {
  final filteredItems = items
      .where(
    (item) =>
        item.operationType == oh_resp.OperationType.deposit ||
        item.operationType == oh_resp.OperationType.withdraw ||
        item.operationType == oh_resp.OperationType.swap ||
        item.operationType == oh_resp.OperationType.transferByPhone ||
        item.operationType == oh_resp.OperationType.receiveByPhone ||
        item.operationType == oh_resp.OperationType.paidInterestRate ||
        item.operationType == oh_resp.OperationType.feeSharePayment ||
        item.operationType == oh_resp.OperationType.rewardPayment ||
        item.operationType == oh_resp.OperationType.simplexBuy ||
        item.operationType == oh_resp.OperationType.recurringBuy ||
        item.operationType == oh_resp.OperationType.earningDeposit ||
        item.operationType == oh_resp.OperationType.earningWithdrawal ||
        item.operationType == oh_resp.OperationType.cryptoInfo ||
        item.operationType == oh_resp.OperationType.nftSwap ||
        item.operationType == oh_resp.OperationType.nftBuyOpposite ||
        item.operationType == oh_resp.OperationType.nftSell ||
        item.operationType == oh_resp.OperationType.nftSellOpposite ||
        item.operationType == oh_resp.OperationType.nftDeposit ||
        item.operationType == oh_resp.OperationType.nftWithdrawal ||
        item.operationType == oh_resp.OperationType.nftWithdrawalFee ||
        item.operationType == oh_resp.OperationType.nftBuy,
  )
      .map((item) {
    return item.operationType == oh_resp.OperationType.swap
        ? item.copyWith(
            operationType: item.swapInfo!.isSell
                ? oh_resp.OperationType.sell
                : oh_resp.OperationType.buy,
          )
        : item;
  }).toList();

  return filteredItems;
}
