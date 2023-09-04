import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../core/l10n/i10n.dart';
import '../portfolio_header.dart';
import 'components/empty_apy_portfolio_body/empty_apy_portfolio_body.dart';

class EmptyApyPortfolio extends StatelessWidget {
  const EmptyApyPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: const PortfolioHeader(
        emptyBalance: true,
      ),
      child: const EmptyApyPortfolioBody(),
    );
  }
}
