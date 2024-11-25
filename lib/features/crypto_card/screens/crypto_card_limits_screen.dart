import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'CryptoCardLimitsRoute')
class CryptoCardLimitsScreen extends StatelessWidget {
  const CryptoCardLimitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: '',
      header: GlobalBasicAppBar(
        hasRightIcon: false,
        title: intl.crypto_card_limits,
      ),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                STextDivider(intl.crypto_card_limits_card_payments),
                // TODO (Yaroslav): SPU-4804 add real data
                SimpleHistoryTable(
                  label: intl.crypto_card_limits_daily,
                  value: '1 000 EUR',
                  rightSupplement: intl.crypto_card_limits_left('1 000 EUR'),
                ),
                SimpleHistoryTable(
                  label: intl.crypto_card_limits_weekly,
                  value: '3 000 EUR',
                  rightSupplement: intl.crypto_card_limits_left('2 000 EUR'),
                ),
                SimpleHistoryTable(
                  label: intl.crypto_card_monthly,
                  value: '5 000 EUR',
                  rightSupplement: intl.crypto_card_limits_left('4 000 EUR'),
                ),
                STextDivider(intl.crypto_card_limits_atm_withdrawals),
                SimpleHistoryTable(
                  label: intl.crypto_card_limits_daily,
                  value: '500 EUR',
                  rightSupplement: intl.crypto_card_limits_left('0 EUR'),
                ),
                SimpleHistoryTable(
                  label: intl.crypto_card_limits_weekly,
                  value: '1 000 EUR',
                  rightSupplement: intl.crypto_card_limits_left('500 EUR'),
                ),
                SimpleHistoryTable(
                  label: intl.crypto_card_monthly,
                  value: '2 000 EUR',
                  rightSupplement: intl.crypto_card_limits_left('1 500 EUR'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
