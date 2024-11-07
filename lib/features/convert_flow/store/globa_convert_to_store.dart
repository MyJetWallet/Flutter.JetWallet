import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';

part 'globa_convert_to_store.g.dart';

class GlobaConvertToStore extends _GlobaConvertToStoreBase with _$GlobaConvertToStore {
  GlobaConvertToStore() : super();

  static GlobaConvertToStore of(BuildContext context) => Provider.of<GlobaConvertToStore>(context, listen: false);
}

abstract class _GlobaConvertToStoreBase with Store {
  @computed
  List<CurrencyModel> get assets {
    return [];
  }

  @computed
  List<CardDataModel> get cards =>
      sSignalRModules.bankingProfileData?.banking?.cards
          ?.where(
            (element) => element.status == AccountStatusCard.active,
          )
          .toList() ??
      [];

  @computed
  List<SimpleBankingAccount> get accounts {
    final accounts = <SimpleBankingAccount>[];

    final simpleAccount = sSignalRModules.bankingProfileData?.simple?.account;

    if (simpleAccount != null && simpleAccount.status == AccountStatus.active) {
      accounts.add(simpleAccount);
    }

    final bankingAccounts = sSignalRModules.bankingProfileData?.banking?.accounts
            ?.where(
              (element) => element.status == AccountStatus.active && !(element.isHidden ?? false),
            )
            .toList() ??
        <SimpleBankingAccount>[];

    accounts.addAll(bankingAccounts);

    return accounts;
  }
}
