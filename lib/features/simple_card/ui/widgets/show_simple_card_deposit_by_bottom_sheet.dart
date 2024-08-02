import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/cj_banking_accounts/widgets/show_add_cash_from_bottom_sheet.dart';
import 'package:jetwallet/features/simple_card/store/simple_card_deposit_by_store.dart';
import 'package:jetwallet/utils/balances/crypto_balance.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

import '../../../../core/di/di.dart';
import '../../../app/store/app_store.dart';

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
                onClose: () {},
                onChooseAsset: (currency) {
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
