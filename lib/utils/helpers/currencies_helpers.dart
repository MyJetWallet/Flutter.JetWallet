import 'package:decimal/decimal.dart';

import '../models/currency_model.dart';

/// Used for [BUY] and [SELL] features \
/// Always provide newList to avoid unexpected behaviour
void sortCurrencies(List<CurrencyModel> currencies) {
  // If baseBalance of 2 assets are equal, compare by assetBalance
  currencies.sort((a, b) {
    final compare = b.baseBalance.compareTo(a.baseBalance);
    if (compare != 0) return compare;

    return b.assetBalance.compareTo(a.assetBalance);
  });
}

void sortCurrenciesMyAssets(List<CurrencyModel> currencies) {
  // If baseBalance of 2 assets are equal, compare by assetBalance
  currencies.sort((a, b) {
    final compare = b.baseBalance.compareTo(a.baseBalance);
    if (compare != 0) return compare;

    return a.weight.compareTo(b.weight);
  });
}

/// Used for [Convert] feature
/// Always provide a copy of List to avoid unexpected behaviour
void sortByWeight(List<CurrencyModel> currencies) {
  currencies.sort((a, b) => a.weight.compareTo(b.weight));
}

List<CurrencyModel> currenciesWithBalance(List<CurrencyModel> currencies) {
  final list = <CurrencyModel>[];

  if (currencies.isNotEmpty) {
    for (final element in currencies) {
      if (element.baseBalance != Decimal.zero) {
        list.add(element);
      }
    }
  }

  return list;
}

List<CurrencyModel> currenciesWithoutBalance(List<CurrencyModel> currencies) {
  final list = <CurrencyModel>[];

  if (currencies.isNotEmpty) {
    for (final element in currencies) {
      if (element.baseBalance == Decimal.zero) {
        list.add(element);
      }
    }
  }

  return list;
}

/// Used for [BUY] feature \
/// Always provide newList to avoid unexpected behaviour
void removeEmptyCurrenciesFrom(List<CurrencyModel> currencies) {
  currencies.removeWhere((element) => element.assetBalance == Decimal.zero);
}

/// Used for [BUY] and [SELL] features \
/// Always provide newList to avoid unexpected behaviour
void removeCurrencyFrom(
  List<CurrencyModel> currencies,
  CurrencyModel currency,
) {
  currencies.removeWhere((element) => element.symbol == currency.symbol);
}

/// Used for [Portfolio] feature with empty balance
/// Always provide a copy of List to avoid unexpected behaviour
void sortByApyAndWeight(List<CurrencyModel> currencies) {
  currencies.sort((a, b) {
    final compare = b.apy.compareTo(a.apy);
    if (compare != 0) return compare;

    return b.weight.compareTo(a.weight);
  });
}

/// Used for [Buy] [Convert] features with empty balance
/// Always provide a copy of List to avoid unexpected behaviour
void sortByBalanceAndWeight(List<CurrencyModel> currencies) {
  currencies.sort((a, b) {
    final compare = b.baseBalance.compareTo(a.baseBalance);
    if (compare != 0) return compare;
    final compareWeight = a.weight.compareTo(b.weight);
    if (compareWeight != 0) return compareWeight;

    return a.symbol.compareTo(b.symbol);
  });
}

/// Used for [Receive] feature with empty balance
/// Always provide a copy of List to avoid unexpected behaviour
void sortByBalanceWatchlistAndWeight(
  List<CurrencyModel> currencies,
  List<String> watchlist,
) {
  currencies.sort((a, b) {
    final compare = b.baseBalance.compareTo(a.baseBalance);
    if (compare != 0) return compare;
    if (watchlist.contains(a.symbol) && !watchlist.contains(b.symbol)) {
      return 0.compareTo(1);
    } else if (watchlist.contains(b.symbol) && !watchlist.contains(a.symbol)) {
      return 1.compareTo(0);
    }
    final compareWeight = a.weight.compareTo(b.weight);
    if (compareWeight != 0) return compareWeight;

    return a.symbol.compareTo(b.symbol);
  });
}

List<CurrencyModel> filterByApy(List<CurrencyModel> currencies) {
  return currencies.where((element) {
    return element.apy != Decimal.zero;
  }).toList();
}
