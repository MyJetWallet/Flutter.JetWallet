import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/cj_banking_accounts/screens/show_account_details_screen.dart';
import 'package:jetwallet/features/cj_banking_accounts/store/account_deposit_by_store.dart';
import 'package:jetwallet/features/cj_banking_accounts/widgets/show_add_cash_from_bottom_sheet.dart';
import 'package:jetwallet/utils/balances/crypto_balance.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

import '../../../core/di/di.dart';
import '../../app/store/app_store.dart';

void showAccountDepositBySelector({
  required BuildContext context,
  required VoidCallback onClose,
  required SimpleBankingAccount bankingAccount,
}) {
  sAnalytics.depositByScreenView();

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
        STextDivider(intl.methods),
        SimpleTableAsset(
          label: intl.bankAccountsSelectPopupTitle,
          supplement: intl.wallet_external_bank_transfer,
          assetIcon: Assets.svg.assets.fiat.externalTransfer.simpleSvg(
            width: 24,
          ),
          hasRightValue: false,
          onTableAssetTap: () {
            sRouter.maybePop();

            sAnalytics.tapOnTheAnyAccountForDepositButton(
              accountType: 'Requisites',
            );

            sAnalytics.eurWalletDepositDetailsSheet(
              isCJ: store.isCJAccount,
              eurAccountLabel: store.account?.label ?? 'Account',
              isHasTransaction: true,
              source: 'Account',
            );

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
        if (store.isCryptoAvaible ||
            (store.isAccountsAvaible && store.accounts.isNotEmpty) ||
            (store.isCardsAvaible && store.cards.isNotEmpty))
          STextDivider(intl.deposit_by_accounts),
        if (store.isCryptoAvaible) ...[
          SimpleTableAsset(
            label: intl.market_crypto,
            supplement: intl.internal_exchange,
            assetIcon: Assets.svg.assets.crypto.defaultPlaceholder.simpleSvg(
              width: 24,
            ),
            rightValue: !getIt<AppStore>().isBalanceHide
                ? calculateCryptoBalance()
                : '**** ${sSignalRModules.baseCurrency.symbol}',
            onTableAssetTap: () {
              sAnalytics.tapOnTheAnyAccountForDepositButton(
                accountType: 'Crypto',
              );

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
          for (final account in store.accounts)
            SimpleTableAsset(
              label: account.label ?? 'Account 1',
              supplement: intl.wallet_internal_transfer,
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
                sAnalytics.tapOnTheAnyAccountForDepositButton(
                  accountType: account.isClearjuctionAccount ? 'Simple account' : 'Personal account',
                );

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
          STextDivider(intl.deposit_by_cards),
          for (final card in store.cards)
            SimpleTableAsset(
              label: card.label ?? '',
              supplement: intl.wallet_internal_transfer,
              rightValue: getIt<AppStore>().isBalanceHide
                  ? '**** ${card.currency ?? 'EUR'}'
                  : volumeFormat(
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
