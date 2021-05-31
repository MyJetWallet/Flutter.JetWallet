import '../../../../screens/wallet/models/asset_with_balance_model.dart';

List<AssetWithBalanceModel> removeElement(
  AssetWithBalanceModel element,
  List<AssetWithBalanceModel> list,
) {
  final newList = List<AssetWithBalanceModel>.from(list);

  newList.removeWhere((item) => item == element);

  return newList;
}
