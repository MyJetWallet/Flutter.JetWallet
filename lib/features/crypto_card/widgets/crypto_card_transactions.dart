import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/earn/widgets/basic_header.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class CryptoCardTransactions extends StatelessWidget {
  const CryptoCardTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SBasicHeader(
          title: intl.wallet_transactions,
          buttonTitle: intl.wallet_history_view_all,
          onTap: () {},
        ),
        SPlaceholder(
          size: SPlaceholderSize.l,
          text: intl.wallet_simple_account_empty,
        ),
      ],
    );
  }
}
