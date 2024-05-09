import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/convert_flow/widgets/convert_to_choose_asset_bottom_sheet.dart';
import 'package:jetwallet/features/sell_flow/store/sell_payment_method_store.dart';
import 'package:jetwallet/utils/balances/crypto_balance.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

import '../../../core/di/di.dart';
import '../../app/store/app_store.dart';

void showSellPayWithBottomSheet({
  required BuildContext context,
  CurrencyModel? currency,
  void Function({
    SimpleBankingAccount? account,
    CardDataModel? card,
  })? onSelected,
  dynamic Function(dynamic)? then,
}) {
  final store = SellPaymentMethodStore()
    ..init(
      asset: currency,
    );

  if (store.accounts.isNotEmpty) {
    sShowBasicModalBottomSheet(
      context: context,
      then: then,
      scrollable: true,
      pinned: ActionBottomSheetHeader(
        name: intl.sell_amount_sell_to,
        needBottomPadding: false,
      ),
      horizontalPinnedPadding: 0.0,
      removePinnedPadding: true,
      children: [
        _PaymentMethodScreenBody(
          asset: currency,
          onSelected: onSelected,
          store: store,
        ),
      ],
    );
  }
}

class _PaymentMethodScreenBody extends StatelessObserverWidget {
  const _PaymentMethodScreenBody({
    required this.asset,
    required this.store,
    this.onSelected,
  });

  final CurrencyModel? asset;
  final void Function({
    SimpleBankingAccount? account,
    CardDataModel? card,
  })? onSelected;
  final SellPaymentMethodStore store;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          STextDivider(intl.sell_amount_accounts),
          SimpleTableAsset(
            assetIcon: Assets.svg.assets.crypto.defaultPlaceholder.simpleSvg(
              width: 24,
            ),
            label: intl.wallet_crypto_wallet,
            supplement: intl.wallet_crypto_assets,
            onTableAssetTap: () {
              showConvertToChooseAssetBottomSheet(
                context: context,
                onChooseAsset: (currency) {
                  sRouter.push(
                    AmountRoute(
                      tab: AmountScreenTab.convert,
                      asset: asset,
                      toAsset: currency,
                    ),
                  );
                },
                skipAssetSymbol: asset?.symbol,
                then: (value) {
                  if (value != true) {
                    sAnalytics.tapOnCloseSheetConvertToButton();
                  }
                },
              );
            },
            rightValue: !getIt<AppStore>().isBalanceHide
                ? calculateCryptoBalance()
                : '**** ${sSignalRModules.baseCurrency.symbol}',
          ),
          for (final account in store.accounts)
            SimpleTableAsset(
              assetIcon: Assets.svg.assets.fiat.account.simpleSvg(
                width: 24,
              ),
              label: account.label ?? 'Account 1',
              supplement: account.accountId != 'clearjuction_account'
                  ? intl.eur_wallet_personal_account
                  : intl.eur_wallet_simple_account,
              onTableAssetTap: () {
                if (onSelected != null) {
                  onSelected!(account: account);
                } else {
                  sRouter.push(
                    AmountRoute(
                      tab: AmountScreenTab.buy,
                      asset: asset,
                      account: account,
                    ),
                  );
                }
              },
              rightValue: getIt<AppStore>().isBalanceHide
                  ? '**** ${account.currency}'
                  : '${account.balance} ${account.currency}',
            ),
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
                  if (onSelected != null) {
                    onSelected!(card: card);
                  } else {
                    sRouter.push(
                      AmountRoute(
                        tab: AmountScreenTab.buy,
                        asset: asset,
                        simpleCard: card,
                      ),
                    );
                  }
                },
              ),
          ],
          const SpaceH45(),
        ],
      ),
    );
  }
}
