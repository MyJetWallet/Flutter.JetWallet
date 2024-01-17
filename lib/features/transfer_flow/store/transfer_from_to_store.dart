import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';
import 'package:simple_networking/modules/wallet_api/models/transfer/account_transfer_preview_request_model.dart';

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

  CredentialsType? _fromType;
  CredentialsType? _toType;

  @computed
  List<CardDataModel> get cards {
    if (_toType == CredentialsType.clearjunctionAccount) {
      return [];
    }

    return _isFrom
        ? _toType == CredentialsType.unlimitCard
            ? []
            : sSignalRModules.bankingProfileData?.banking?.cards
                    ?.where(
                      (element) =>
                          element.status == AccountStatusCard.active &&
                          element.isNotEmptyBalance &&
                          element.cardId != _skipId,
                    )
                    .toList() ??
                []
        : _fromType == CredentialsType.unlimitCard
            ? []
            : sSignalRModules.bankingProfileData?.banking?.cards
                    ?.where((element) => element.status == AccountStatusCard.active && element.cardId != _skipId)
                    .toList() ??
                [];
  }

  @computed
  List<SimpleBankingAccount> get accounts {
    final accounts = <SimpleBankingAccount>[];

    final simpleAccount = sSignalRModules.bankingProfileData?.simple?.account;

    if (simpleAccount != null && simpleAccount.accountId != _skipId && simpleAccount.status == AccountStatus.active) {
      if (_isFrom) {
        if (simpleAccount.isNotEmptyBalance) {
          accounts.add(simpleAccount);
        }
      } else if (_fromType != CredentialsType.unlimitCard) {
        accounts.add(simpleAccount);
      }
    }

    final bankingAccounts = _isFrom
        ? sSignalRModules.bankingProfileData?.banking?.accounts
                ?.where(
                  (element) =>
                      element.isNotEmptyBalance &&
                      !(element.isHidden ?? false) &&
                      element.accountId != _skipId &&
                      element.status == AccountStatus.active,
                )
                .toList() ??
            <SimpleBankingAccount>[]
        : sSignalRModules.bankingProfileData?.banking?.accounts
                ?.where(
                  (element) =>
                      !(element.isHidden ?? false) &&
                      element.accountId != _skipId &&
                      element.status == AccountStatus.active,
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
    CredentialsType? fromType,
    CredentialsType? toType,
  }) {
    _isFrom = isFrom;
    _skipId = skipId;
    _fromType = fromType;
    _toType = toType;
  }
}
