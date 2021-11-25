import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/components/app_frame.dart';
import '../../../shared/helpers/is_balance_empty.dart';
import '../../../shared/providers/currencies_pod/currencies_pod.dart';
import 'components/empty_portfolio_body/empty_porfolio_body.dart';
import 'components/portfolio_with_balance/portfolio_with_balance_app_bar.dart';
import 'components/portfolio_with_balance/portfolio_with_balance_body.dart';

class Portfolio extends HookWidget {
  const Portfolio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balanceEmpty = isBalanceEmpty(useProvider(currenciesPod));

    if (balanceEmpty) {
      return const SPageFrameWithPadding(
        header: SSmallHeader(
          title: 'Balance',
          showBackButton: false,
        ),
        child: EmptyPortfolioBody(),
      );
    } else {
      return const AppFrame(
        appBar: PortfolioWithBalanceAppBar(),
        child: PortfolioWithBalanceBody(),
      );
    }
  }
}
