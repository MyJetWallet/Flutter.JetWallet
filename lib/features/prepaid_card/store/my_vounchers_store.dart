import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/buy_prepaid_card_intention_dto_list_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/get_purchase_card_list_request_model.dart';

part 'my_vounchers_store.g.dart';

class MyVounchersStore extends _MyVounchersStoreBase with _$MyVounchersStore {
  MyVounchersStore() : super();

  static _MyVounchersStoreBase of(BuildContext context) => Provider.of<MyVounchersStore>(context);
}

abstract class _MyVounchersStoreBase with Store {
  _MyVounchersStoreBase() {
    getListMyVouchers();
  }
  @observable
  ObservableList<PrapaidCardVoucherModel> listMyVouchers = ObservableList.of([]);

  @observable
  bool isLoading = false;

  @observable
  bool isLoadingPagination = false;

  @observable
  bool isShortDescription = true;

  Timer? _timer;

  static const List<BuyPrepaidCardIntentionStatus> avabledStatuses = [
    BuyPrepaidCardIntentionStatus.undefined,
    BuyPrepaidCardIntentionStatus.created,
    BuyPrepaidCardIntentionStatus.paid,
    BuyPrepaidCardIntentionStatus.purchasing,
    BuyPrepaidCardIntentionStatus.completed,
    BuyPrepaidCardIntentionStatus.toRefund,
    BuyPrepaidCardIntentionStatus.cantFindVaucher,
  ];

  @action
  void setShortDescription() {
    isShortDescription = !isShortDescription;
  }

  @action
  Future<void> getListMyVouchers({bool isFirsRun = true}) async {
    try {
      isLoading = true;

      const model = GetPurchaseCardListRequestModel(
        statuses: avabledStatuses,
      );
      final response = await sNetwork.getWalletModule().postGetPurchaseList(model);

      response.pick(
        onData: (data) {
          listMyVouchers
            ..clear()
            ..addAll(data.vouchers);
          if (isFirsRun) {
            _startTimer();
          }
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
            needFeedback: true,
          );
        },
      );
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        id: 1,
        needFeedback: true,
      );
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
        needFeedback: true,
      );
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loadMoreClosedPositions({int take = 20}) async {
    final hasMore = (listMyVouchers.length % take) == 0;
    if (!hasMore || isLoadingPagination) return;
    isLoadingPagination = true;
    try {
      final skip = listMyVouchers.length;

      final model = GetPurchaseCardListRequestModel(
        take: take,
        skip: skip,
        statuses: avabledStatuses,
      );
      final response = await sNetwork.getWalletModule().postGetPurchaseList(model);

      response.pick(
        onData: (data) {
          final vouchers = data.vouchers;
          if (vouchers.isNotEmpty) {
            listMyVouchers.addAll(vouchers);
          }
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
            needFeedback: true,
          );
        },
      );
    } catch (e) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
        needFeedback: true,
      );
    } finally {
      isLoadingPagination = false;
    }
  }

  void _startTimer() {
    if (listMyVouchers.any(
      (voucher) => voucher.status == BuyPrepaidCardIntentionStatus.purchasing,
    )) {
      _timer = Timer.periodic(
        const Duration(seconds: 20),
        (timer) {
          if (listMyVouchers.any(
            (voucher) => voucher.status == BuyPrepaidCardIntentionStatus.purchasing,
          )) {
            getListMyVouchers(isFirsRun: false);
          } else {
            _timer?.cancel();
          }
        },
      );
    } else {
      _timer?.cancel();
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}
