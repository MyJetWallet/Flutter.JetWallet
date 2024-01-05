import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:jetwallet/features/sell_flow/widgets/sell_choose_asset_bottom_sheet.dart';
import 'package:jetwallet/features/simple_card/store/simple_card_deposit_by_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

void showSimpleCardDepositBySelector({
  required BuildContext context,
  required VoidCallback onClose,
  required CardDataModel card,
}) {
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
        MarketSeparator(
          text: intl.methods,
          isNeedDivider: false,
        ),
        if (store.isCryptoAvaible) ...[
          SimpleTableAsset(
            label: intl.market_crypto,
            supplement: intl.internal_exchange,
            assetIcon: Assets.svg.assets.crypto.defaultPlaceholder.simpleSvg(
              width: 24,
            ),
            onTableAssetTap: () {
              showSellChooseAssetBottomSheet(
                context: context,
                isAddCash: true,
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
