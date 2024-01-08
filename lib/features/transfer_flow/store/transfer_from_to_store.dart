import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';

part 'transfer_from_to_store.g.dart';

class TransferFromToStore = _TransferFromToStoreBase with _$TransferFromToStore;

abstract class _TransferFromToStoreBase with Store {
  @observable
  bool _isFrom = false;

  @observable
  bool isAccountsAvaible = true;

  @observable
  bool isCardsAvaible = true;

  @computed
  List<CardDataModel> get cards {
    return _isFrom
        ? sSignalRModules.bankingProfileData?.banking?.cards
                ?.where(
                  (element) => element.status == AccountStatusCard.active && element.isNotEmptyBalance,
                )
                .toList() ??
            []
        : sSignalRModules.bankingProfileData?.banking?.cards
                ?.where(
                  (element) => element.status == AccountStatusCard.active,
                )
                .toList() ??
            [];
  }

  @computed
  List<SimpleBankingAccount> get accounts {
    final accounts = <SimpleBankingAccount>[];

    final simpleAccount = sSignalRModules.bankingProfileData?.simple?.account;

    if (simpleAccount != null) {
      accounts.add(simpleAccount);
    }

    final bankingAccounts = _isFrom
        ? sSignalRModules.bankingProfileData?.banking?.accounts
                ?.where((element) => element.isNotEmptyBalance && !(element.isHidden ?? false))
                .toList() ??
            <SimpleBankingAccount>[]
        : sSignalRModules.bankingProfileData?.banking?.accounts
                ?.where((element) => !(element.isHidden ?? false))
                .toList() ??
            <SimpleBankingAccount>[];

    accounts.addAll(bankingAccounts);

    return accounts;
  }

  @action
  void init({required bool isFrom}) {
    _isFrom = isFrom;
  }
}
