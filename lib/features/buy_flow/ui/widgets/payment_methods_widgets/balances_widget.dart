import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

import '../../../../../core/di/di.dart';
import '../../../../app/store/app_store.dart';

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
        STextDivider(intl.sell_amount_accounts),
        for (final account in accounts)
          SimpleTableAsset(
            assetIcon: Assets.svg.assets.fiat.account.simpleSvg(
              width: 24,
            ),
            label: account.label ?? 'Account 1',
            supplement: account.accountId != 'clearjuction_account'
                ? intl.eur_wallet_personal_account
                : intl.eur_wallet_simple_account,
            onTableAssetTap: () {
              onTap(account);
            },
            rightValue:
                getIt<AppStore>().isBalanceHide ? '**** ${account.currency}' : '${account.balance} ${account.currency}',
          ),
      ],
    );
  }
}
