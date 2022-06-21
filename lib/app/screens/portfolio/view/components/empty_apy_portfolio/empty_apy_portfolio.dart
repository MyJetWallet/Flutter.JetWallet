import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../portfolio_header.dart';
import 'components/empty_apy_portfolio_body/empty_apy_portfolio_body.dart';

class EmptyApyPortfolio extends StatelessWidget {
  const EmptyApyPortfolio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SPageFrame(
      header: PortfolioHeader(
        emptyBalance: true,
      ),
      child: EmptyApyPortfolioBody(),
    );
  }
}
