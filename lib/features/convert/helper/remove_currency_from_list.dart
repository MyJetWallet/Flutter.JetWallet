import 'package:jetwallet/utils/models/currency_model.dart';

/// Returns [newList] with removed currency from it
List<CurrencyModel> removeCurrencyFromList(
  CurrencyModel currency,
  List<CurrencyModel> list,
) {
  final newList = List<CurrencyModel>.from(list);

  newList.removeWhere((item) => item.symbol == currency.symbol);

  return newList;
}
