import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/simple_card/store/simple_card_withdraw_to_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_kit/simple_kit.dart';
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

  sShowBasicModalBottomSheet(
    context: context,
    pinned: SBottomSheetHeader(
      name: intl.withdraw_to,
    ),
    scrollable: true,
    onDissmis: onClose,
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
                  : volumeFormat(
                      decimal: account.balance ?? Decimal.zero,
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
              supplement: '${card.cardType?.frontName} ••• ${card.last4NumberCharacters}',
              rightValue: getIt<AppStore>().isBalanceHide
                  ? '**** ${card.currency ?? 'EUR'}'
                  : volumeFormat(
                      decimal: card.balance ?? Decimal.zero,
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
