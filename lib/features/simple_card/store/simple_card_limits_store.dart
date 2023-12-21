import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_limits_request.dart';

part 'simple_card_limits_store.g.dart';

class SimpleCardLimitsStore extends _SimpleCardLimitsStoreBase with _$SimpleCardLimitsStore {
  SimpleCardLimitsStore() : super();

  static _SimpleCardLimitsStoreBase of(BuildContext context) =>
      Provider.of<SimpleCardLimitsStore>(context, listen: false);
}

abstract class _SimpleCardLimitsStoreBase with Store {
  @observable
  bool isLoading = false;

  String dailyLimitsData = '';
  String dailySpendingValue = '';
  String dailySpendingLimit = '';
  String dailyWithdrawalValue = '';
  String dailyWithdrawalLimit = '';
  double dailySpendingProgress = 0;
  double dailyWithdrawalProgress = 0;

  String monthlyLimitsData = '';
  String monthlySpendingValue = '';
  String monthlySpendingLimit = '';
  String monthlyWithdrawalValue = '';
  String monthlyWithdrawalLimit = '';
  double monthlySpendingProgress = 0;
  double monthlyWithdrawalProgress = 0;

  @action
  Future<void> init(String cardId) async {
    try {
      isLoading = true;
      final model = SimpleCardLimitsRequestModel(
        cardId: cardId,
      );
      final response = await sNetwork.getWalletModule().postCardLimits(model);
      response.pick(
        onData: (data) {
          dailyLimitsData = DateFormat('dd MMMM yyyy').format(data.dailyLimitsReset ?? DateTime.now());
          dailySpendingValue = volumeFormat(
            decimal: data.dailySpendingValue ?? Decimal.zero,
            symbol: 'EUR',
          );
          dailySpendingLimit = volumeFormat(
            decimal: data.dailySpendingLimit ?? Decimal.zero,
            symbol: 'EUR',
          );
          dailyWithdrawalValue = volumeFormat(
            decimal: data.dailyWithdrawalValue ?? Decimal.zero,
            symbol: 'EUR',
          );
          dailyWithdrawalLimit = volumeFormat(
            decimal: data.dailyWithdrawalLimit ?? Decimal.zero,
            symbol: 'EUR',
          );
          dailySpendingProgress =
              ((data.dailySpendingValue ?? Decimal.zero) / (data.dailySpendingLimit ?? Decimal.zero)).toDouble();
          dailyWithdrawalProgress =
              ((data.dailyWithdrawalValue ?? Decimal.zero) / (data.dailyWithdrawalLimit ?? Decimal.zero)).toDouble();

          monthlyLimitsData = DateFormat('MMMM yyyy').format(data.monthlyLimitsReset ?? DateTime.now());
          monthlySpendingValue = volumeFormat(
            decimal: data.monthlySpendingValue ?? Decimal.zero,
            symbol: 'EUR',
          );
          monthlySpendingLimit = volumeFormat(
            decimal: data.monthlySpendingLimit ?? Decimal.zero,
            symbol: 'EUR',
          );
          monthlyWithdrawalValue = volumeFormat(
            decimal: data.monthlyWithdrawalValue ?? Decimal.zero,
            symbol: 'EUR',
          );
          monthlyWithdrawalLimit = volumeFormat(
            decimal: data.monthlyWithdrawalLimit ?? Decimal.zero,
            symbol: 'EUR',
          );
          monthlySpendingProgress =
              ((data.monthlySpendingValue ?? Decimal.zero) / (data.monthlySpendingLimit ?? Decimal.zero)).toDouble();
          monthlyWithdrawalProgress =
              ((data.monthlyWithdrawalValue ?? Decimal.zero) / (data.monthlyWithdrawalLimit ?? Decimal.zero))
                  .toDouble();
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
            needFeedback: true,
          );
        },
      );
      isLoading = false;
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        id: 4,
        needFeedback: true,
      );
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 5,
        needFeedback: true,
      );
    }
  }
}
