import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';

part 'simple_card_deposit_by_store.g.dart';

class SimpleCardDepositByStore = _SimpleCardDepositByStoreBase with _$SimpleCardDepositByStore;

abstract class _SimpleCardDepositByStoreBase with Store {
  @observable
  bool isBankTrnasferAvaible = true;

  @observable
  bool isCryptoAvaible = true;

  @observable
  bool isAccountsAvaible = true;

  @observable
  bool isCardsAvaible = true;

  @observable
  CardDataModel? card;

  @observable
  bool isCJAccount = false;

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

    if (simpleAccount != null) {
      accounts.add(simpleAccount);
    }

    final bankingAccounts = sSignalRModules.bankingProfileData?.banking?.accounts
            ?.where((element) => element.isNotEmptyBalance && !(element.isHidden ?? false))
            .toList() ??
        <SimpleBankingAccount>[];

    accounts.addAll(bankingAccounts);

    return accounts;
  }

  @action
  void init({
    required CardDataModel newCard,
  }) {
    card = newCard;
  }
}
