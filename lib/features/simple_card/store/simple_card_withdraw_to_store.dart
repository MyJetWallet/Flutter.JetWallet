import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';

part 'simple_card_withdraw_to_store.g.dart';

class SimpleCardWithdrawToStore = _SimpleCardWithdrawToStoreBase with _$SimpleCardWithdrawToStore;

abstract class _SimpleCardWithdrawToStoreBase with Store {
  @observable
  bool isBankTrnasferAvaible = true;

  @observable
  bool isCryptoAvaible = true;

  @observable
  bool isAccountsAvaible = true;

  @observable
  bool isCardsAvaible = false;

  @observable
  CardDataModel? card;

  @computed
  List<CardDataModel> get cards =>
      sSignalRModules.bankingProfileData?.banking?.cards
          ?.where(
            (element) => element.status == AccountStatusCard.active && element.cardId != card?.cardId,
          )
          .toList() ??
      [];

  @computed
  List<SimpleBankingAccount> get accounts {
    final accounts = <SimpleBankingAccount>[];

    final bankingAccounts = sSignalRModules.bankingProfileData?.banking?.accounts
            ?.where(
              (element) =>
                  element.status == AccountStatus.active &&
                  !(element.isHidden ?? false) &&
                  element.accountId != card?.cardId,
            )
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

    var currencyFiltered = List<CurrencyModel>.from(sSignalRModules.currenciesList);
    currencyFiltered = currencyFiltered
        .where(
          (element) => element.isAssetBalanceNotEmpty && element.type == AssetType.crypto,
        )
        .toList();

    final isAccountAvaible = sSignalRModules.sellMethods.any((element) => element.id == SellMethodsId.ibanSell);

    final kycState = getIt.get<KycService>();

    final withdrawalStatus = kycState.withdrawalStatus == kycOperationStatus(KycStatus.allowed);
    final isWithdrawalBlocker =
        sSignalRModules.clientDetail.clientBlockers.any((element) => element.blockingType == BlockingType.withdrawal);

    isCryptoAvaible = withdrawalStatus && !isWithdrawalBlocker && currencyFiltered.isNotEmpty && isAccountAvaible;
  }
}
