import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

class BalancesWidget extends StatelessWidget {
  const BalancesWidget({
    super.key,
    required this.onTap,
    required this.accounts,
  });

  final void Function(SimpleBankingAccount account) onTap;
  final List<SimpleBankingAccount> accounts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MarketSeparator(
          text: intl.pay_with_balances,
          isNeedDivider: false,
        ),
        for (final account in accounts)
          SCardRow(
            icon: Container(
              margin: const EdgeInsets.only(top: 3),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: sKit.colors.blue,
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: 16,
                height: 16,
                child: SBankMediumIcon(
                  color: sKit.colors.white,
                ),
              ),
            ),
            name: account.label ?? '',
            helper: account.bankName != null
                ? intl.eur_wallet_personal_account
                : intl.eur_wallet_simple_account,
            onTap: () {
              onTap(account);
            },
            description: '',
            amount: '',
            needSpacer: true,
            rightIcon: account.status == AccountStatus.active
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color(0xFFF1F4F8)),
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: Text(
                      '${account.balance} ${account.currency}',
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
