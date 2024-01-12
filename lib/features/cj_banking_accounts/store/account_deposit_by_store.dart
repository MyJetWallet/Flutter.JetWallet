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

part 'account_deposit_by_store.g.dart';

class AccountDepositByStore = _AccountDepositByStoreBase with _$AccountDepositByStore;

abstract class _AccountDepositByStoreBase with Store {
  @observable
  bool isBankTrnasferAvaible = true;

  @observable
  bool isCryptoAvaible = true;

  @observable
  bool isAccountsAvaible = true;

  @observable
  bool isCardsAvaible = true;

  @observable
  SimpleBankingAccount? account;

  @observable
  bool isCJAccount = false;

  @computed
  List<CardDataModel> get cards =>
      sSignalRModules.bankingProfileData?.banking?.cards
          ?.where(
            (element) => element.status == AccountStatusCard.active && element.isNotEmptyBalance,
          )
          .toList() ??
      [];

  @computed
  List<SimpleBankingAccount> get accounts {
    final accounts = <SimpleBankingAccount>[];

    final simpleAccount = sSignalRModules.bankingProfileData?.simple?.account;

    if (simpleAccount != null &&
        simpleAccount.isNotEmptyBalance &&
        simpleAccount.accountId != account?.accountId) {
      accounts.add(simpleAccount);
    }

    final bankingAccounts = sSignalRModules.bankingProfileData?.banking?.accounts
            ?.where(
              (element) =>
                  element.isNotEmptyBalance && !(element.isHidden ?? false) && element.accountId != account?.accountId,
            )
            .toList() ??
        <SimpleBankingAccount>[];

    accounts.addAll(bankingAccounts);

    return accounts;
  }

  @action
  void init({
    required SimpleBankingAccount bankingAccount,
  }) {
    account = bankingAccount;

    isCJAccount = bankingAccount.isClearjuctionAccount;

    var currencyFiltered = List<CurrencyModel>.from(sSignalRModules.currenciesList);
    currencyFiltered = currencyFiltered
        .where(
          (element) => element.type == AssetType.crypto,
        )
        .toList();

    final isAccountAvaible = isCJAccount
        ? (sSignalRModules.paymentProducts
                    ?.any((element) => element.id == AssetPaymentProductsEnum.simpleIbanAccount) ??
                false) &&
            sSignalRModules.bankingProfileData?.simple?.account != null
        : sSignalRModules.sellMethods.any((element) => element.id == SellMethodsId.ibanSell);

    final kycState = getIt.get<KycService>();

    final tradeStatus = kycState.tradeStatus == kycOperationStatus(KycStatus.allowed);
    final isTradeBlocker =
        sSignalRModules.clientDetail.clientBlockers.any((element) => element.blockingType == BlockingType.trade);

    isCryptoAvaible = tradeStatus && !isTradeBlocker && currencyFiltered.isNotEmpty && isAccountAvaible;
  }
}
