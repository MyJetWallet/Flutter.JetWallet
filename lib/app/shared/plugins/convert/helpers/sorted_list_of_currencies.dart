import '../../../../screens/wallet/models/asset_with_balance_model.dart';

List<AssetWithBalanceModel> sortedListOfCurrencies(
  List<AssetWithBalanceModel> currencies,
  AssetWithBalanceModel currencyToRemove,
) {
  final newList = List<AssetWithBalanceModel>.from(currencies);

  newList.removeWhere((element) => element == currencyToRemove);

  return newList;
}
