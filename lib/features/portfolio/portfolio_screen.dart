import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/portfolio/widgets/empty_apy_portfolio/empty_apy_portfolio.dart';
import 'package:jetwallet/features/portfolio/widgets/empty_portfolio/empty_porfolio.dart';
import 'package:jetwallet/features/portfolio/widgets/portfolio_with_balance/portfolio_balance.dart';
import 'package:jetwallet/features/portfolio/widgets/portfolio_with_balance/portfolio_with_balance.dart';
import 'package:jetwallet/utils/helpers/are_balances_empty.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';

class PortfolioScreen extends StatelessObserverWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;

    final balancesEmpty = areBalancesEmpty(currencies);
    final noDeposits = _noDepositsInProccess(currencies);

    final apyCurrencies = filterByApy(currencies);

    if (balancesEmpty && noDeposits) {
      // ignore: prefer-conditional-expressions
      if (apyCurrencies.isEmpty) {
        return const EmptyPortfolio();
      } else {
        return const EmptyApyPortfolio();
      }
    } else {
      return const PortfolioBalance();
      //return const PortfolioWithBalance();
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
