import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/earn/widgets/deposit_card_badge.dart';
import 'package:jetwallet/features/earn/widgets/link_label.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

class SDepositCard extends StatelessWidget {
  const SDepositCard({
    super.key,
    required this.earnPosition,
  });

  final EarnOfferClientModel earnPosition;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 8,
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors.grey4),
        ),
        color: colors.white,
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CryptoCardHeader(),
              SizedBox(height: 16),
              CryptoCardBody(),
            ],
          ),
        ),
      ),
    );
  }
}

class CryptoCardHeader extends StatelessWidget {
  const CryptoCardHeader();

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: colors.orange,
          child: Icon(Icons.currency_bitcoin, color: colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SLinkLabel(
                title: 'Bitcoin',
                onTap: () {},
              ),
              Text(
                'Variable APY 17.23%',
                style: STStyles.body2Medium.copyWith(color: colors.grey1),
              ),
            ],
          ),
        ),
        const SDepositCardBadge(status: EarnPositionStatus.active),
      ],
    );
  }
}

class CryptoCardBody extends StatelessWidget {
  const CryptoCardBody();

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.grey5,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CryptoBodyColumn(
              title: intl.earn_balance,
              amount: '14.43 EUR',
              btcAmount: '0.365 BTC',
            ),
            Container(
              height: 50,
              width: 1,
              color: colors.grey3,
            ),
            const SizedBox(width: 24),
            CryptoBodyColumn(
              title: intl.earn_revenue,
              amount: '92.12 EUR',
              btcAmount: '0.00234 BTC',
            ),
          ],
        ),
      ),
    );
  }
}

class CryptoBodyColumn extends StatelessWidget {
  const CryptoBodyColumn({
    required this.title,
    required this.amount,
    required this.btcAmount,
  });

  final String title;
  final String amount;
  final String btcAmount;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: STStyles.body2Medium.copyWith(color: colors.grey1),
          ),
          Text(
            amount,
            style: STStyles.subtitle2.copyWith(color: colors.black),
          ),
          Text(
            btcAmount,
            style: STStyles.body2Medium.copyWith(color: colors.grey1),
          ),
        ],
      ),
    );
  }
}
