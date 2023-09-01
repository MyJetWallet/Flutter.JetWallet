import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/market/market_details/model/operation_history_union.dart';
import 'package:jetwallet/features/wallet/helper/nft_types.dart';
import 'package:jetwallet/features/wallet/helper/show_transaction_details.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_request_model.dart'
    as oh_req;
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart'
    as oh_resp;

part 'operation_history.g.dart';

class OperationHistory extends _OperationHistoryBase with _$OperationHistory {
  OperationHistory(
    super.assetId,
    super.filter,
    super.isRecurring,
    super.jw_operation_id,
  );

  static _OperationHistoryBase of(BuildContext context) =>
      Provider.of<OperationHistory>(context, listen: false);
}

abstract class _OperationHistoryBase with Store {
  _OperationHistoryBase(
    this.assetId,
    this.filter,
    this.isRecurring,
    this.jw_operation_id,
  ) {
    getIt<EventBus>().on<GetNewHistoryEvent>().listen((event) {
      refreshHistory(needLoader: false);
    });
  }

  final String? assetId;
  final TransactionType? filter;
  final bool? isRecurring;

  // Указывает на конкретную операцию, используем после тапа по пушу
  String? jw_operation_id;

  @observable
  ScrollController scrollController = ScrollController();

  @observable
  ObservableList<oh_resp.OperationHistoryItem> operationHistoryItems =
      ObservableList.of([]);

  @observable
  OperationHistoryUnion union = const OperationHistoryUnion.loading();

  @observable
  bool nothingToLoad = false;

  @observable
  bool isLoading = false;

  @computed
  List<oh_resp.OperationHistoryItem> get listToShow => isRecurring!
      ? operationHistoryItems
          .where(
            (i) => i.operationType == oh_resp.OperationType.recurringBuy,
          )
          .toList()
      : operationHistoryItems
          .where(
            (i) => !nftTypes.contains(i.operationType),
          )
          .toList();

  @action
  Future<bool> refreshHistory({bool needLoader = true}) async {
    getIt.get<SimpleLoggerService>().log(
          level: Level.info,
          place: 'Operation History Store',
          message: 'refreshHistory',
        );

    operationHistoryItems = ObservableList.of([]);

    await initOperationHistory(needLoader: needLoader);

    return true;
  }

  var detailsShowed = false;

  @action
  Future<void> initOperationHistory({
    bool needLoader = true,
  }) async {
    union = const OperationHistoryUnion.loading();
    isLoading = true;

    try {
      final operationHistory = await _requestOperationHistory(
        oh_req.OperationHistoryRequestModel(
          assetId: assetId,
          batchSize: 20,
        ),
        needLoader,
      );

      _updateOperationHistory(
        operationHistory.operationHistory,
        isbgUpdate: !needLoader,
      );

      union = const OperationHistoryUnion.loaded();

      if (jw_operation_id != null) {
        final item = listToShow
            .indexWhere((element) => element.operationId == jw_operation_id);

        if (item != -1) {
          if (detailsShowed) return;

          detailsShowed = true;
          showTransactionDetails(
            sRouter.navigatorKey.currentContext!,
            listToShow[item],
            (q) {
              detailsShowed = false;
            },
          );
        } else {
          await getOperationHistoryOperation(jw_operation_id!);
        }

        jw_operation_id = null;
      }
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
  Future<void> getOperationHistoryOperation(String operationID) async {
    final response = await sNetwork
        .getWalletModule()
        .getOperationHistoryOperationID(operationID);

    response.pick(
      onData: (data) {
        if (data.assetId.isEmpty) return;

        showTransactionDetails(
          sRouter.navigatorKey.currentContext!,
          data,
          (q) {
            detailsShowed = false;
          },
        );
      },
      onError: (e) {},
    );
  }

  // При сколле вниз
  @action
  Future<void> operationHistory(String? assetId) async {
    if (operationHistoryItems.isEmpty) return;

    union = const OperationHistoryUnion.loading();
    isLoading = true;

    final operationHistory = await _requestOperationHistory(
      oh_req.OperationHistoryRequestModel(
        assetId: assetId,
        batchSize: 20,
        lastDate: operationHistoryItems.last.timeStamp,
      ),
      true,
    );

    _updateOperationHistory(operationHistory.operationHistory);

    union = const OperationHistoryUnion.loaded();

    isLoading = false;
  }

  @action
  void _updateOperationHistory(
    List<oh_resp.OperationHistoryItem> items, {
    bool isbgUpdate = false,
  }) {
    if (items.isEmpty) {
      nothingToLoad = true;
      union = const OperationHistoryUnion.loaded();
    } else {
      if (isbgUpdate) {
        operationHistoryItems = ObservableList.of(
          _filterUnusedOperationTypeItemsFrom(items),
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
        operationHistoryItems = ObservableList.of(
          operationHistoryItems + _filterUnusedOperationTypeItemsFrom(items),
        );

        union = const OperationHistoryUnion.loaded();
      }
    }
  }

  @action
  Future<oh_resp.OperationHistoryResponseModel> _requestOperationHistory(
    oh_req.OperationHistoryRequestModel model,
    bool needLoader,
  ) async {
    if (needLoader) {
      union = const OperationHistoryUnion.loading();
    }

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
        item.operationType == oh_resp.OperationType.buyApplePay ||
        item.operationType == oh_resp.OperationType.buyGooglePay ||
        item.operationType == oh_resp.OperationType.nftSwap ||
        item.operationType == oh_resp.OperationType.nftBuyOpposite ||
        item.operationType == oh_resp.OperationType.nftSell ||
        item.operationType == oh_resp.OperationType.nftSellOpposite ||
        item.operationType == oh_resp.OperationType.nftDeposit ||
        item.operationType == oh_resp.OperationType.nftWithdrawal ||
        item.operationType == oh_resp.OperationType.nftWithdrawalFee ||
        item.operationType == oh_resp.OperationType.nftBuy ||
        item.operationType == oh_resp.OperationType.ibanDeposit ||
        item.operationType == oh_resp.OperationType.ibanSend ||
        item.operationType == oh_resp.OperationType.sendGlobally ||
        item.operationType == oh_resp.OperationType.p2pBuy ||
        item.operationType == oh_resp.OperationType.giftSend ||
        item.operationType == oh_resp.OperationType.giftReceive,
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
