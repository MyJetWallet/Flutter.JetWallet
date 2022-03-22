import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/helpers/are_balances_empty.dart';
import '../../../shared/models/currency_model.dart';
import '../../../shared/providers/currencies_pod/currencies_pod.dart';
import 'components/empty_portfolio/empty_porfolio.dart';
import 'components/portfolio_with_balance/portfolio_with_balance.dart';

class Portfolio extends HookWidget {
  const Portfolio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencies = useProvider(currenciesPod);

    final balancesEmpty = areBalancesEmpty(currencies);
    final noDeposits = _noDepositsInProccess(currencies);

    if (balancesEmpty && noDeposits) {
      return const EmptyPortfolio();
    } else {
      return const PortfolioWithBalance();
    }
  }
}

/// Checks whether user has any assets with the deposit in proccess
bool _noDepositsInProccess(List<CurrencyModel> currencies) {
  for (final currency in currencies) {
    if (currency.isPendingDeposit) {
      return false;
    }
  }
  return true;
}
