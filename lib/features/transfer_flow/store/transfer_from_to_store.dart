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

  String? _skipId;

  @computed
  List<CardDataModel> get cards {
    return _isFrom
        ? sSignalRModules.bankingProfileData?.banking?.cards
                ?.where(
                  (element) =>
                      element.status == AccountStatusCard.active &&
                      element.isNotEmptyBalance &&
                      element.cardId != _skipId,
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

    if (simpleAccount != null && simpleAccount.accountId != _skipId) {
      if (_isFrom) {
        if (simpleAccount.isNotEmptyBalance) {
          accounts.add(simpleAccount);
        }
      } else {
        accounts.add(simpleAccount);
      }
    }

    final bankingAccounts = _isFrom
        ? sSignalRModules.bankingProfileData?.banking?.accounts
                ?.where(
                  (element) =>
                      element.isNotEmptyBalance && !(element.isHidden ?? false) && element.accountId != _skipId,
                )
                .toList() ??
            <SimpleBankingAccount>[]
        : sSignalRModules.bankingProfileData?.banking?.accounts
                ?.where(
                  (element) => !(element.isHidden ?? false) && element.accountId != _skipId,
                )
                .toList() ??
            <SimpleBankingAccount>[];

    accounts.addAll(bankingAccounts);

    return accounts;
  }

  @action
  void init({
    required bool isFrom,
    String? skipId,
  }) {
    _isFrom = isFrom;
    _skipId = skipId;
  }
}
