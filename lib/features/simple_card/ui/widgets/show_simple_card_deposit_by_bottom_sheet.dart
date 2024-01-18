import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/cj_banking_accounts/widgets/show_add_cash_from_bottom_sheet.dart';
import 'package:jetwallet/features/simple_card/store/simple_card_deposit_by_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

void showSimpleCardDepositBySelector({
  required BuildContext context,
  required VoidCallback onClose,
  required CardDataModel card,
}) {
  sAnalytics.depositByScreenView();

  final store = SimpleCardDepositByStore()..init(newCard: card);

  sShowBasicModalBottomSheet(
    context: context,
    pinned: SBottomSheetHeader(
      name: intl.deposit_by,
    ),
    scrollable: true,
    onDissmis: onClose,
    children: [
      _DepositByBody(
        store: store,
      ),
    ],
  );
}

class _DepositByBody extends StatelessWidget {
  const _DepositByBody({
    required this.store,
  });

  final SimpleCardDepositByStore store;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        STextDivider(intl.methods),
        if (store.isCryptoAvaible) ...[
          SimpleTableAsset(
            label: intl.market_crypto,
            supplement: intl.internal_exchange,
            assetIcon: Assets.svg.assets.crypto.defaultPlaceholder.simpleSvg(
              width: 24,
            ),
            hasRightValue: false,
            onTableAssetTap: () {
              sAnalytics.tapOnTheAnyAccountForDepositButton(
                accountType: 'Crypto',
              );
              showAddCashFromBottomSheet(
                context: context,
                onClose: () {},
                onChooseAsset: (currency) {
                  Navigator.of(context).pop();
                  sRouter.push(
                    AmountRoute(
                      tab: AmountScreenTab.sell,
                      asset: currency,
                      simpleCard: store.card,
                    ),
                  );
                },
              );
            },
          ),
        ],
        if (store.isAccountsAvaible && store.accounts.isNotEmpty) ...[
          STextDivider(intl.deposit_by_accounts),
          for (final account in store.accounts)
            SimpleTableAsset(
              label: account.label ?? 'Account 1',
              supplement:
                  account.isClearjuctionAccount ? intl.eur_wallet_simple_account : intl.eur_wallet_personal_account,
              rightValue: volumeFormat(
                decimal: account.balance ?? Decimal.zero,
                accuracy: 2,
                symbol: account.currency ?? 'EUR',
              ),
              assetIcon: Assets.svg.assets.fiat.account.simpleSvg(
                width: 24,
              ),
              onTableAssetTap: () {
                sAnalytics.tapOnTheAnyAccountForDepositButton(
                  accountType: account.isClearjuctionAccount ? 'CJ' : 'Unlimit',
                );
                sRouter.push(
                  AmountRoute(
                    tab: AmountScreenTab.transfer,
                    toCard: store.card,
                    fromAccount: account,
                  ),
                );
              },
            ),
        ],
        if (store.isCardsAvaible && store.cards.isNotEmpty) ...[
          STextDivider(intl.deposit_by_cards),
          for (final card in store.cards)
            SimpleTableAsset(
              label: card.label ?? '',
              supplement: '${card.cardType?.frontName} ••• ${card.last4NumberCharacters}',
              rightValue: volumeFormat(
                decimal: card.balance ?? Decimal.zero,
                accuracy: 2,
                symbol: card.currency ?? 'EUR',
              ),
              isCard: true,
              onTableAssetTap: () {
                sAnalytics.tapOnTheAnyAccountForDepositButton(
                  accountType: 'V.Card',
                );
                sRouter.push(
                  AmountRoute(
                    tab: AmountScreenTab.transfer,
                    toCard: store.card,
                    fromCard: card,
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
