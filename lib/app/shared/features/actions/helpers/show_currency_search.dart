import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../models/currency_model.dart';
import '../shared/notifier/action_search_notipod.dart';

const _minCurrencies = 7;

bool showBuyCurrencySearch(
  BuildContext context, {
  required bool fromCard,
}) {
  final state = context.read(actionSearchNotipod);
  final currencies = <CurrencyModel>[];

  if (fromCard) {
    for (final currency in state.filteredCurrencies) {
      if (currency.supportsAtLeastOneBuyMethod) {
        currencies.add(currency);
      }
    }
  } else {
    for (final currency in state.filteredCurrencies) {
      currencies.add(currency);
    }
  }

  return _displaySearch(currencies);
}

bool showSellCurrencySearch(BuildContext context) {
  final state = context.read(actionSearchNotipod);
  final assets = <CurrencyModel>[];

  for (final currency in state.filteredCurrencies) {
    if (currency.baseBalance != Decimal.zero &&
        currency.isAssetBalanceNotEmpty) {
      assets.add(currency);
    }
  }

  return _displaySearch(assets);
}

bool showDepositCurrencySearch(BuildContext context) {
  final state = context.read(actionSearchNotipod);
  final assets = <CurrencyModel>[];

  for (final currency in state.filteredCurrencies) {
    if (currency.supportsAtLeastOneFiatDepositMethod ||
        currency.supportsCryptoDeposit) {
      assets.add(currency);
    }
  }

  return _displaySearch(assets);
}

bool showReceiveCurrencySearch(BuildContext context) {
  final state = context.read(actionSearchNotipod);
  final assets = <CurrencyModel>[];

  for (final currency in state.filteredCurrencies) {
    if (currency.type == AssetType.crypto && currency.supportsCryptoDeposit) {
      assets.add(currency);
    }
  }

  return _displaySearch(assets);
}

bool showSendCurrencySearch(BuildContext context) {
  final state = context.read(actionSearchNotipod);
  final assets = <CurrencyModel>[];

  for (final currency in state.filteredCurrencies) {
    if (currency.supportsCryptoWithdrawal && currency.isAssetBalanceNotEmpty) {
      assets.add(currency);
    }
  }

  return _displaySearch(assets);
}

bool showWithdrawalCurrencySearch(BuildContext context) {
  final state = context.read(actionSearchNotipod);
  final assets = <CurrencyModel>[];

  for (final currency in state.filteredCurrencies) {
    if (currency.isAssetBalanceNotEmpty &&
        currency.supportsAtLeastOneWithdrawalMethod) {
      assets.add(currency);
    }
  }

  return _displaySearch(assets);
}

bool _displaySearch(List<CurrencyModel> currencies) {
  if (currencies.length > _minCurrencies) {
    return true;
  } else {
    return false;
  }
}
