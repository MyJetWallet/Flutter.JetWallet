import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';

import '../../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../../utils/formatting/base/volume_format.dart';
import '../../../../../utils/helpers/non_indices_with_balance_from.dart';

class CardBalancesWidget extends StatelessWidget {
  const CardBalancesWidget({
    super.key,
    required this.onTap,
    required this.card,
  });

  final void Function(CardDataModel card) onTap;
  final CardDataModel card;

  @override
  Widget build(BuildContext context) {
    final eurCurrency = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    ).where((element) => element.symbol == 'EUR').first;

    return Column(
      children: [
        const SpaceH24(),
        STextDivider(intl.simple_card_add_cards),
        SCardRow(
          frozenIcon: (card.status == AccountStatusCard.frozen)
              ? const SFrozenIcon(
                  width: 16,
                  height: 16,
                )
              : null,
          icon: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceH6(),
              if (card.status == AccountStatusCard.frozen)
                const SFrozenCardIcon(
                  width: 24,
                  height: 16,
                )
              else
                const SCardIcon(
                  width: 24,
                  height: 16,
                ),
            ],
          ),
          name: intl.eur_wallet_simple_card,
          helper: intl.simple_card_type_virtual,
          onTap: () {
            onTap(card);
          },
          description: '',
          amount: '',
          needSpacer: true,
          rightIcon: card.status == AccountStatusCard.active
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Color(0xFFF1F4F8)),
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: Text(
                    volumeFormat(
                      decimal: card.balance ?? Decimal.zero,
                      accuracy: eurCurrency.accuracy,
                      symbol: eurCurrency.symbol,
                    ),
                    style: sSubtitle1Style.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null,
        ),
      ],
    );
  }
}
