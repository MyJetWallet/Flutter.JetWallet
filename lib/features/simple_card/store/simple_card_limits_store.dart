import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_limits_request.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_limits_responce.dart';

part 'simple_card_limits_store.g.dart';

class SimpleCardLimitsStore extends _SimpleCardLimitsStoreBase with _$SimpleCardLimitsStore {
  SimpleCardLimitsStore() : super();

  static _SimpleCardLimitsStoreBase of(BuildContext context) =>
      Provider.of<SimpleCardLimitsStore>(context, listen: false);
}

abstract class _SimpleCardLimitsStoreBase with Store {
  String cardId = '';

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
  Future<void> init(String newCardId) async {
    try {
      cardId = newCardId;
      isLoading = true;
      final model = SimpleCardLimitsRequestModel(
        cardId: cardId,
      );
      final response = await sNetwork.getWalletModule().postCardLimits(model);
      response.pick(
        onData: (data) {
          _parseData(data);
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

  @action
  Future<void> refreshData() async {
    try {
      isLoading = true;
      final model = SimpleCardLimitsRequestModel(
        cardId: cardId,
      );
      final response = await sNetwork.getWalletModule().postCardLimits(model);
      response.pick(
        onData: (data) {
          _parseData(data);
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
      isLoading = true;
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 5,
        needFeedback: true,
      );
      isLoading = true;
    }
  }

  void _parseData(SimpleCardLimitsResponceModel data) {
    dailyLimitsData = DateFormat('dd MMMM yyyy', intl.localeName).format(data.dailyLimitsReset ?? DateTime.now());
    dailySpendingValue = (data.dailySpendingValue ?? Decimal.zero).toFormatCount(
      symbol: 'EUR',
    );
    dailySpendingLimit = (data.dailySpendingLimit ?? Decimal.zero).toFormatCount(
      symbol: 'EUR',
    );
    dailyWithdrawalValue = (data.dailyWithdrawalValue ?? Decimal.zero).toFormatCount(
      symbol: 'EUR',
    );
    dailyWithdrawalLimit = (data.dailyWithdrawalLimit ?? Decimal.zero).toFormatCount(
      symbol: 'EUR',
    );
    dailySpendingProgress =
        ((data.dailySpendingValue ?? Decimal.zero) / (data.dailySpendingLimit ?? Decimal.one)).toDouble();
    dailyWithdrawalProgress =
        ((data.dailyWithdrawalValue ?? Decimal.zero) / (data.dailyWithdrawalLimit ?? Decimal.one)).toDouble();

    monthlyLimitsData = _formatMMMMyyyy(data.monthlyLimitsReset ?? DateTime.now());
    monthlySpendingValue = (data.monthlySpendingValue ?? Decimal.zero).toFormatCount(
      symbol: 'EUR',
    );
    monthlySpendingLimit = (data.monthlySpendingLimit ?? Decimal.zero).toFormatCount(
      symbol: 'EUR',
    );
    monthlyWithdrawalValue = (data.monthlyWithdrawalValue ?? Decimal.zero).toFormatCount(
      symbol: 'EUR',
    );
    monthlyWithdrawalLimit = (data.monthlyWithdrawalLimit ?? Decimal.zero).toFormatCount(
      symbol: 'EUR',
    );
    monthlySpendingProgress =
        ((data.monthlySpendingValue ?? Decimal.zero) / (data.monthlySpendingLimit ?? Decimal.one)).toDouble();
    monthlyWithdrawalProgress =
        ((data.monthlyWithdrawalValue ?? Decimal.zero) / (data.monthlyWithdrawalLimit ?? Decimal.one)).toDouble();
  }

  String _formatMMMMyyyy(DateTime date) {
    return '${toBeginningOfSentenceCase(DateFormat('MMMM', intl.localeName).format(date))} ${DateFormat('yyyy', intl.localeName).format(date)}';
  }
}
