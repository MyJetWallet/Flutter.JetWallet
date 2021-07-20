import '../../../../screens/market/model/currency_model.dart';

List<CurrencyModel> removeElement(
  CurrencyModel element,
  List<CurrencyModel> list,
) {
  final newList = List<CurrencyModel>.from(list);

  newList.removeWhere((item) => item == element);

  return newList;
}
