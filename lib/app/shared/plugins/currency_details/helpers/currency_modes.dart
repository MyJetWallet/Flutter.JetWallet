import '../../../../screens/wallet/models/asset_with_balance_model.dart';

// 0 stands for ON
// 1 stands for OFF
bool isDepositMode(AssetWithBalanceModel currency) {
  return currency.depositMode == 0;
}

bool isWithdrawalMode(AssetWithBalanceModel currency) {
  return currency.withdrawalMode == 0;
}
