import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/cj_banking_accounts/screens/show_account_details_screen.dart';
import 'package:jetwallet/features/cj_banking_accounts/store/account_deposit_by_store.dart';
import 'package:jetwallet/features/cj_banking_accounts/widgets/show_add_cash_from_bottom_sheet.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

void showAccountDepositBySelector({
  required BuildContext context,
  required VoidCallback onClose,
  required SimpleBankingAccount bankingAccount,
}) {
  final store = AccountDepositByStore()..init(bankingAccount: bankingAccount);

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

  final AccountDepositByStore store;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MarketSeparator(
          text: intl.methods,
          isNeedDivider: false,
        ),
        SimpleTableAsset(
          label: intl.bankAccountsSelectPopupTitle,
          supplement: intl.external_transfer,
          assetIcon: Assets.svg.assets.fiat.externalTransfer.simpleSvg(
            width: 24,
          ),
          onTableAssetTap: () {
            sRouter.pop();
            
            showAccountDetails(
              context: context,
              onClose: () {
                sAnalytics.eurWalletTapCloseOnDeposirSheet(
                  isCJ: store.isCJAccount,
                  eurAccountLabel: store.account?.label ?? 'Account',
                  isHasTransaction: true,
                );
              },
              bankingAccount: store.account!,
            );
          },
        ),
        if (store.isCryptoAvaible) ...[
          SimpleTableAsset(
            label: intl.market_crypto,
            supplement: intl.internal_exchange,
            assetIcon: Assets.svg.assets.crypto.defaultPlaceholder.simpleSvg(
              width: 24,
            ),
            onTableAssetTap: () {
              showAddCashFromBottomSheet(
                context: context,
                onClose: () {
                  sAnalytics.eurWalletTapCloseOnDeposirSheet(
                    isCJ: store.isCJAccount,
                    eurAccountLabel: store.account?.label ?? 'Account',
                    isHasTransaction: true,
                  );
                },
                onChooseAsset: (currency) {
                  Navigator.pop(context);
                  sRouter.push(
                    AmountRoute(
                      tab: AmountScreenTab.sell,
                      asset: currency,
                      account: store.account,
                    ),
                  );
                },
              );
            },
          ),
        ],
        if (store.isAccountsAvaible && store.accounts.isNotEmpty) ...[
          MarketSeparator(
            text: intl.deposit_by_accounts,
            isNeedDivider: false,
          ),
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
                sRouter.push(
                  AmountRoute(
                    tab: AmountScreenTab.transfer,
                    toAccount: store.account,
                    fromAccount: account,
                  ),
                );
              },
            ),
        ],
        if (store.isCardsAvaible && store.cards.isNotEmpty) ...[
          MarketSeparator(
            text: intl.deposit_by_cards,
            isNeedDivider: false,
          ),
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
                sRouter.push(
                  AmountRoute(
                    tab: AmountScreenTab.transfer,
                    toAccount: store.account,
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
