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
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/get_vouncher_request_model.dart';

part 'prepaid_card_details_store.g.dart';

class PrepaidCardDetailsStore extends _PrepaidCardDetailsStoreBase with _$PrepaidCardDetailsStore {
  PrepaidCardDetailsStore({super.voucher, super.orderId}) : super();

  static _PrepaidCardDetailsStoreBase of(BuildContext context) => Provider.of<PrepaidCardDetailsStore>(context);
}

abstract class _PrepaidCardDetailsStoreBase with Store {
  _PrepaidCardDetailsStoreBase({this.voucher, this.orderId}) {
    if (orderId == null && voucher?.orderId != null) {
      orderId = voucher?.orderId;
    }
    _getVouncherData();
  }

  @observable
  PrapaidCardVoucherModel? voucher;

  @observable
  String? orderId;

  @observable
  bool isLoading = false;

  Timer? _timer;

  Future<void> _getVouncherData({bool isFirsRun = true}) async {
    if (voucher != null && isFirsRun) {
      if (isFirsRun) {
        _startTimer();
      }
      return;
    }

    try {
      isLoading = true;

      final model = GetVouncherRequestModel(
        orderId: orderId ?? '',
      );
      final response = await sNetwork.getWalletModule().postGetVouncher(model);

      response.pick(
        onData: (data) {
          voucher = data.vouchers.first;
          isLoading = false;
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
    }
  }

  void _startTimer() {
    if (voucher?.status == BuyPrepaidCardIntentionStatus.purchasing) {
      _timer = Timer.periodic(
        const Duration(seconds: 10),
        (timer) {
          if (voucher?.status == BuyPrepaidCardIntentionStatus.purchasing) {
            _getVouncherData(isFirsRun: false);
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
