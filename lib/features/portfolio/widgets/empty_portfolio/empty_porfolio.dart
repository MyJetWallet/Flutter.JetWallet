import 'package:flutter/material.dart';
import 'package:jetwallet/features/portfolio/widgets/empty_portfolio/widgets/empty_portfolio_body.dart';
import 'package:simple_kit/simple_kit.dart';

import '../portfolio_header.dart';

class EmptyPortfolio extends StatelessWidget {
  const EmptyPortfolio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SPageFrame(
      header: PortfolioHeader(
        emptyBalance: true,
      ),
      child: EmptyPortfolioBody(),
    );
  }
}
