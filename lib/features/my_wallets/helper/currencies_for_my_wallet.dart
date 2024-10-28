import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

ObservableList<CurrencyModel> currenciesForMyWallet({
  ObservableList<CurrencyModel>? currencies,
  bool fromWalletsScreen = false,
  BankingShowState? state,
}) {
  var activeCurrencies = (currencies ?? sSignalRModules.currenciesList)
      .where(
        (currency) => currency.walletIsActive,
      )
      .toList();

  final kycState = getIt.get<KycService>();

  final isShowEUR = (!fromWalletsScreen || state == BankingShowState.accountList) &&
      (!kycState.isSimpleKyc || kycState.earlyKycFlowAllowed);

  activeCurrencies.sort((a, b) => (a.walletOrder ?? 1).compareTo(b.walletOrder ?? 1));

  if (!isShowEUR) {
    activeCurrencies = ObservableList.of(
      activeCurrencies
          .where(
            (currency) => currency.symbol != 'EUR',
          )
          .toList(),
    );
  }

  return ObservableList.of(activeCurrencies);
}

ObservableList<CurrencyModel> currenciesForSearchInMyWallet(
  ObservableList<CurrencyModel> currencies,
) {
  final activeCurrencies = currencies
      .where(
        (currency) => !currency.walletIsActive,
      )
      .toList();

  activeCurrencies.sort((a, b) => a.weight.compareTo(b.weight));

  return ObservableList.of(activeCurrencies);
}
