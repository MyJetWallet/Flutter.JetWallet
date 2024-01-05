import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
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
                bankingAccount: store.account!,
              );
            },
          ),
        ],
        if (store.isAccountsAvaible) ...[
          const MarketSeparator(
            text: 'Accounts',
            isNeedDivider: false,
          ),
          for (final account in store.accounts)
            SimpleTableAsset(
              label: account.label ?? 'Account 1',
              supplement: 'Simple account',
              rightValue: volumeFormat(
                decimal: account.balance ?? Decimal.zero,
                accuracy: 2,
                symbol: account.currency ?? 'EUR',
              ),
              assetIcon: Assets.svg.assets.fiat.account.simpleSvg(
                width: 24,
              ),
              onTableAssetTap: () {
                //TODO (yaroslav): add routing somewhere
              },
            ),
        ],
        if (store.isCardsAvaible) ...[
          const MarketSeparator(
            text: 'Cards',
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
                //TODO (yaroslav): add routing somewhere
              },
            ),
        ],
        const SpaceH42(),
      ],
    );
  }
}
