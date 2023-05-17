// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

const _minCurrencies = 7;

bool showBuyCurrencySearch(
  BuildContext context, {
  required bool fromCard,
  required ActionSearchStore searchStore,
}) {
  final currencies = <CurrencyModel>[];

  if (fromCard) {
    for (final currency in searchStore.filteredCurrencies) {
      if (currency.supportsAtLeastOneBuyMethod) {
        currencies.add(currency);
      }
    }
  } else {
    for (final currency in searchStore.filteredCurrencies) {
      currencies.add(currency);
    }
  }

  return _displaySearch(currencies);
}

bool showSellCurrencySearch(BuildContext context) {
  final state = getIt.get<ActionSearchStore>();
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
  final state = getIt.get<ActionSearchStore>();
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
  final state = getIt.get<ActionSearchStore>();
  final assets = <CurrencyModel>[];

  for (final currency in state.fCurrencies) {
    if (currency.type == AssetType.crypto && currency.supportsCryptoDeposit) {
      assets.add(currency);
    }
  }

  return _displaySearch(assets);
}

bool showSendCurrencySearch(BuildContext context) {
  final state = getIt.get<ActionSearchStore>();
  final assets = <CurrencyModel>[];

  for (final currency in state.fCurrencies) {
    if (currency.supportsCryptoWithdrawal && currency.isAssetBalanceNotEmpty) {
      assets.add(currency);
    }
  }

  return _displaySearch(assets);
}

bool showWithdrawalCurrencySearch(BuildContext context) {
  final state = getIt.get<ActionSearchStore>();
  final assets = <CurrencyModel>[];

  for (final currency in state.fCurrencies) {
    if (currency.isAssetBalanceNotEmpty &&
        currency.supportsAtLeastOneWithdrawalMethod) {
      assets.add(currency);
    }
  }

  return _displaySearch(assets);
}

bool _displaySearch(List<CurrencyModel> currencies) {
  return currencies.length > _minCurrencies ? true : false;
}
