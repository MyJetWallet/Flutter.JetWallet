import 'package:flutter/material.dart';
import 'package:jetwallet/features/portfolio/widgets/empty_portfolio/widgets/empty_portfolio_body.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../core/l10n/i10n.dart';
import '../portfolio_header.dart';

class EmptyPortfolio extends StatelessWidget {
  const EmptyPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: const PortfolioHeader(
        emptyBalance: true,
      ),
      child: const EmptyPortfolioBody(),
    );
  }
}
