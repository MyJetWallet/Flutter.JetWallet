import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

part 'sell_payment_method_store.g.dart';

class SellPaymentMethodStore extends _SellPaymentMethodStoreBase with _$SellPaymentMethodStore {
  SellPaymentMethodStore() : super();

  static SellPaymentMethodStore of(BuildContext context) => Provider.of<SellPaymentMethodStore>(context, listen: false);
}

abstract class _SellPaymentMethodStoreBase with Store {
  @observable
  CurrencyModel? selectedAssset;

  @computed
  List<SimpleBankingAccount> get accounts {
    final accounts = <SimpleBankingAccount>[];

    final simpleAccount = sSignalRModules.bankingProfileData?.simple?.account;

    if ((simpleAccount != null) && isSimpleAccountAvaible) {
      accounts.add(simpleAccount);
    }

    final bankingAccounts = sSignalRModules.bankingProfileData?.banking?.accounts
            ?.where((element) => element.status == AccountStatus.active)
            .toList() ??
        <SimpleBankingAccount>[];

    if (isBankingAccountsAvaible) {
      accounts.addAll(bankingAccounts);
    }

    return accounts;
  }

  @computed
  bool get isSimpleAccountAvaible {
    // TODO (Yaroslav): add blockers checking
    return true;
  }

  @computed
  bool get isBankingAccountsAvaible {
    // TODO (Yaroslav): add blockers checking
    return true;
  }

  @action
  Future<void> init({
    CurrencyModel? asset,
  }) async {
    sAnalytics.paymentMethodScreenView();

    selectedAssset = asset;
  }
}
