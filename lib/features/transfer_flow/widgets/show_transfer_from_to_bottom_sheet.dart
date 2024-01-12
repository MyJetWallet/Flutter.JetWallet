import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:jetwallet/features/transfer_flow/store/transfer_from_to_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/transfer/account_transfer_preview_request_model.dart';

void showTransferFromToBottomSheet({
  required BuildContext context,
  required void Function({CardDataModel? newCard, SimpleBankingAccount? newAccount}) onSelected,
  required bool isFrom,
  String? skipId,
  CredentialsType? fromType,
  CredentialsType? toType,
}) {
  final store = TransferFromToStore()
    ..init(
      isFrom: isFrom,
      skipId: skipId,
      fromType: fromType,
      toType: toType,
    );

  sShowBasicModalBottomSheet(
    context: context,
    pinned: SBottomSheetHeader(
      name: isFrom ? intl.transfer_transfer_from : intl.transfer_transfer_to,
    ),
    scrollable: true,
    children: [
      _TransferFromToBody(
        onSelected: onSelected,
        store: store,
      ),
    ],
  );
}

class _TransferFromToBody extends StatelessWidget {
  const _TransferFromToBody({
    required this.onSelected,
    required this.store,
  });

  final void Function({
    CardDataModel? newCard,
    SimpleBankingAccount? newAccount,
  }) onSelected;
  final TransferFromToStore store;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                sRouter.pop();
                onSelected(newAccount: account);
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
              label: card.label ?? 'Simple card',
              supplement: '${card.cardType?.frontName} ••• ${card.last4NumberCharacters}',
              rightValue: volumeFormat(
                decimal: card.balance ?? Decimal.zero,
                accuracy: 2,
                symbol: card.currency ?? 'EUR',
              ),
              isCard: true,
              onTableAssetTap: () {
                sRouter.pop();
                onSelected(newCard: card);
              },
            ),
        ],
        const SpaceH42(),
      ],
    );
  }
}
