import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/earn/widgets/deposit_card_badge.dart';
import 'package:jetwallet/features/earn/widgets/link_label.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/shared/simple_network_svg.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';

class SDepositCard extends StatelessWidget {
  const SDepositCard({
    super.key,
    required this.earnPosition,
  });

  final EarnPositionClientModel earnPosition;

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CryptoCardHeader(
                name: earnPosition.assetId,
                iconUrl: earnPosition.assetId,
                apyRate: '',
                earnPositoinStatus: earnPosition.status,
              ),
              const SizedBox(height: 16),
              const CryptoCardBody(
                //! There to get this data
                balance: '999',
                revenue: '999',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CryptoCardHeader extends StatelessWidget {
  const CryptoCardHeader({
    this.iconUrl,
    this.name,
    this.apyRate,
    required this.earnPositoinStatus,
  });

  final String? iconUrl;
  final String? name;
  final String? apyRate;
  final EarnPositionStatus earnPositoinStatus;

  @override
  Widget build(BuildContext context) {
    final currencies = sSignalRModules.currenciesList;

    final currency = currencies.firstWhereOrNull(
      (currency) => currency.symbol == iconUrl,
    );

    final colors = SColorsLight();

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.transparent,
          child: currency != null
              ? SNetworkSvg(
                  url: currency.iconUrl,
                  width: 40,
                  height: 40,
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (name != null)
                SLinkLabel(
                  title: name!,
                  onTap: () {},
                ),
              Text(
                'Variable APY $apyRate%',
                style: STStyles.body2Medium.copyWith(color: colors.grey1),
              ),
            ],
          ),
        ),
        SDepositCardBadge(status: earnPositoinStatus),
      ],
    );
  }
}

class CryptoCardBody extends StatelessWidget {
  const CryptoCardBody({
    required this.balance,
    required this.revenue,
  });

  final String balance;
  final String revenue;

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
              //! Alex S. fix this values
              amount: '$balance EUR',
              btcAmount: '$balance BTC',
            ),
            Container(
              height: 50,
              width: 1,
              color: colors.grey3,
            ),
            const SizedBox(width: 24),
            CryptoBodyColumn(
              title: intl.earn_revenue,
              //! Alex S. fix this values
              amount: '$revenue EUR',
              btcAmount: '$revenue BTC',
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
