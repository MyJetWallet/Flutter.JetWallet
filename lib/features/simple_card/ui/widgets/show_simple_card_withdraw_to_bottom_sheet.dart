import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/simple_card/store/simple_card_withdraw_to_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

import '../../../../core/di/di.dart';
import '../../../app/store/app_store.dart';

void showSimpleCardWithdrawToSelector({
  required BuildContext context,
  required VoidCallback onClose,
  required CardDataModel card,
}) {
  final store = SimpleCardWithdrawToStore()..init(newCard: card);

  showBasicBottomSheet(
    context: context,
    header: BasicBottomSheetHeaderWidget(
      title: intl.withdraw_to,
    ),
    onDismiss: onClose,
    children: [
      _WithdrawToBody(
        store: store,
      ),
    ],
  );
}

class _WithdrawToBody extends StatelessWidget {
  const _WithdrawToBody({
    required this.store,
  });

  final SimpleCardWithdrawToStore store;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (store.isAccountsAvaible && store.accounts.isNotEmpty) ...[
          STextDivider(intl.deposit_by_accounts),
          for (final account in store.accounts)
            SimpleTableAsset(
              label: account.label ?? 'Account 1',
              supplement:
                  account.isClearjuctionAccount ? intl.eur_wallet_simple_account : intl.eur_wallet_personal_account,
              rightValue: getIt<AppStore>().isBalanceHide
                  ? '**** ${account.currency ?? 'EUR'}'
                  : (account.balance ?? Decimal.zero).toFormatSum(
                      accuracy: 2,
                      symbol: account.currency ?? 'EUR',
                    ),
              assetIcon: Assets.svg.assets.fiat.account.simpleSvg(
                width: 24,
              ),
              onTableAssetTap: () {
                sRouter.push(
                  AmountRoute(
                    tab: AmountScreenTab.transfer,
                    toAccount: account,
                    fromCard: store.card,
                  ),
                );
              },
            ),
        ],
        if (store.isCardsAvaible && store.cards.isNotEmpty) ...[
          STextDivider(intl.deposit_by_cards),
          for (final card in store.cards)
            SimpleTableAsset(
              label: card.label ?? 'Simple card',
              supplement: '${card.cardType.frontName} ••• ${card.last4NumberCharacters}',
              rightValue: getIt<AppStore>().isBalanceHide
                  ? '**** ${card.currency ?? 'EUR'}'
                  : (card.balance ?? Decimal.zero).toFormatSum(
                      accuracy: 2,
                      symbol: card.currency ?? 'EUR',
                    ),
              isCard: true,
              onTableAssetTap: () {
                sRouter.push(
                  AmountRoute(
                    tab: AmountScreenTab.transfer,
                    toCard: card,
                    fromCard: store.card,
                  ),
                );
              },
            ),
        ],
        const SpaceH42(),
      ],
    );
  }
}
