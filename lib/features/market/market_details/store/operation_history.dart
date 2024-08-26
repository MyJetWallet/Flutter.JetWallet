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
import 'package:jetwallet/features/transaction_history/helper/show_transaction_details.dart';
import 'package:jetwallet/features/wallet/helper/nft_types.dart';
import 'package:jetwallet/utils/event_bus_events.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_request_model.dart'
    as oh_req;
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart'
    as oh_resp;

part 'operation_history.g.dart';

class OperationHistory extends _OperationHistoryBase with _$OperationHistory {
  OperationHistory(
    super.assetId,
    super.jarId,
    super.filter,
    super.isRecurring,
    super.jwOperationId,
    super.pendingOnly,
    super.accountId,
    super.isCard,
    super.onError,
    super.jwOperationPtpManage,
  );

  static _OperationHistoryBase of(BuildContext context) => Provider.of<OperationHistory>(context, listen: false);
}

abstract class _OperationHistoryBase with Store {
  _OperationHistoryBase(
    this.assetId,
    this.jarId,
    this.filter,
    this.isRecurring,
    this.jwOperationId,
    this.pendingOnly,
    this.accountId,
    this.isCard,
    this.onError,
    this.jwOperationPtpManage,
  ) {
    getIt<EventBus>().on<GetNewHistoryEvent>().listen((event) {
      refreshHistory(needLoader: false);
    });
  }

  final String? assetId;
  final String? jarId;
  final TransactionType? filter;
  final bool? isRecurring;
  final bool? isCard;
  final String? accountId;
  final Function(String reason)? onError;

  // Указывает на конкретную операцию, используем после тапа по пушу
  String? jwOperationId;

  final String? jwOperationPtpManage;

  @observable
  ScrollController scrollController = ScrollController();

  @observable
  ObservableList<oh_resp.OperationHistoryItem> operationHistoryItems = ObservableList.of([]);

  @observable
  OperationHistoryUnion union = const OperationHistoryUnion.loading();

  @observable
  bool nothingToLoad = false;

  @observable
  bool isLoading = false;

  @observable
  bool pendingOnly = false;

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
          jarId: jarId,
          batchSize: 20,
          pendingOnly: pendingOnly,
          accountId: accountId,
        ),
        needLoader,
      );

      _updateOperationHistory(
        operationHistory.operationHistory,
        isbgUpdate: !needLoader,
      );

      union = const OperationHistoryUnion.loaded();

      if (jwOperationId != null) {
        final item = listToShow.indexWhere((element) => element.operationId == jwOperationId);

        if (item != -1) {
          if (detailsShowed) return;

          detailsShowed = true;
          showTransactionDetails(
            context: sRouter.navigatorKey.currentContext!,
            transactionListItem: listToShow[item],
            then: (q) {
              detailsShowed = false;
            },
          );

          if (jwOperationPtpManage == '1') {
            sAnalytics.ptpBuyWebViewScreenView(
              asset: listToShow[item].cryptoBuyInfo?.buyAssetId ?? '',
              ptpCurrency: listToShow[item].cryptoBuyInfo?.paymentAssetId ?? '',
              ptpBuyMethod: listToShow[item].cryptoBuyInfo?.paymentMethodName ?? '',
            );
            final conetext = sRouter.navigatorKey.currentContext!;
            await launchURL(
              conetext,
              listToShow[item].cryptoBuyInfo?.paymentUrl ?? '',
            );
          }
        } else {
          await getOperationHistoryOperation(jwOperationId!);
        }

        jwOperationId = null;
      }
    } catch (e) {
      sNotification.showError(
        intl.something_went_wrong,
        id: 1,
      );
      if (isCard != null && isCard!) {
        onError?.call(intl.something_went_wrong);
      }

      union = const OperationHistoryUnion.error();
    }

    isLoading = false;
  }

  @action
  Future<void> getOperationHistoryOperation(String operationID) async {
    final response = await sNetwork.getWalletModule().getOperationHistoryOperationID(operationID);

    response.pick(
      onData: (data) {
        if (data.assetId.isEmpty) return;

        showTransactionDetails(
          context: sRouter.navigatorKey.currentContext!,
          transactionListItem: data,
          then: (q) {
            detailsShowed = false;
          },
        );
      },
      onError: (e) {},
    );
  }

  // При сколле вниз
  @action
  Future<void> operationHistory(String? assetId, {String? accountId}) async {
    if (operationHistoryItems.isEmpty) return;

    union = const OperationHistoryUnion.loading();
    isLoading = true;

    final operationHistory = await _requestOperationHistory(
      oh_req.OperationHistoryRequestModel(
        assetId: assetId,
        jarId: jarId,
        batchSize: 20,
        lastDate: operationHistoryItems.last.timeStamp,
        pendingOnly: pendingOnly,
        accountId: accountId,
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

    final response = await sNetwork.getWalletModule().getOperationHistory(model);

    return response.data!;
  }
}

Set<oh_resp.OperationType> avaibleOperationTypes = {
  oh_resp.OperationType.deposit,
  oh_resp.OperationType.withdraw,
  oh_resp.OperationType.swap,
  oh_resp.OperationType.rewardPayment,
  oh_resp.OperationType.cryptoBuy,
  oh_resp.OperationType.ibanDeposit,
  oh_resp.OperationType.sendGlobally,
  oh_resp.OperationType.giftSend,
  oh_resp.OperationType.giftReceive,
  oh_resp.OperationType.bankingAccountDeposit,
  oh_resp.OperationType.bankingAccountWithdrawal,
  oh_resp.OperationType.bankingTransfer,
  oh_resp.OperationType.bankingBuy,
  oh_resp.OperationType.bankingSell,
  oh_resp.OperationType.cardPurchase,
  oh_resp.OperationType.cardRefund,
  oh_resp.OperationType.cardWithdrawal,
  oh_resp.OperationType.cardBankingSell,
  oh_resp.OperationType.cardTransfer,
  oh_resp.OperationType.earnReserve,
  oh_resp.OperationType.earnSend,
  oh_resp.OperationType.earnDeposit,
  oh_resp.OperationType.earnWithdrawal,
  oh_resp.OperationType.earnPayroll,
  oh_resp.OperationType.buyPrepaidCard,
  oh_resp.OperationType.p2pBuy,
  oh_resp.OperationType.jarDeposit,
  oh_resp.OperationType.jarWithdrawal,
};

List<oh_resp.OperationHistoryItem> _filterUnusedOperationTypeItemsFrom(
  List<oh_resp.OperationHistoryItem> items,
) {
  final filteredItems = items
      .where(
    (item) => avaibleOperationTypes.contains(item.operationType),
  )
      .map((item) {
    return item.operationType == oh_resp.OperationType.swap
        ? item.copyWith(
            operationType: item.swapInfo!.isSell ? oh_resp.OperationType.swapSell : oh_resp.OperationType.swapBuy,
          )
        : item;
  }).toList();

  return filteredItems;
}
