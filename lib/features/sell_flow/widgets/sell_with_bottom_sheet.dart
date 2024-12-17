import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/convert_flow/widgets/convert_to_choose_asset_bottom_sheet.dart';
import 'package:jetwallet/features/sell_flow/store/sell_payment_method_store.dart';
import 'package:jetwallet/utils/balances/crypto_balance.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:simple_analytics/simple_analytics.dart';
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
  void Function({
    CurrencyModel? newCurrency,
  })? onSelectedCryptoAsset,
}) {
  sAnalytics.sellToSheetView();

  final store = SellPaymentMethodStore()
    ..init(
      asset: currency,
    );

  showBasicBottomSheet(
    context: context,
    header: BasicBottomSheetHeaderWidget(
      title: intl.sell_amount_sell_to,
    ),
    children: [
      _PaymentMethodScreenBody(
        asset: currency,
        onSelected: onSelected,
        store: store,
        onSelectedCryptoAsset: onSelectedCryptoAsset,
      ),
    ],
  ).then((value) {
    then?.call(value);
  });
}

class _PaymentMethodScreenBody extends StatelessObserverWidget {
  const _PaymentMethodScreenBody({
    required this.asset,
    required this.store,
    this.onSelected,
    this.onSelectedCryptoAsset,
  });

  final CurrencyModel? asset;
  final void Function({
    SimpleBankingAccount? account,
    CardDataModel? card,
  })? onSelected;
  final SellPaymentMethodStore store;
  final void Function({
    CurrencyModel? newCurrency,
  })? onSelectedCryptoAsset;

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
            label: intl.actionDeposit_crypto,
            supplement: intl.internal_exchange,
            onTableAssetTap: () {
              showConvertToChooseAssetBottomSheet(
                context: context,
                onChooseAsset: (currency) {
                  if (onSelectedCryptoAsset != null) {
                    onSelectedCryptoAsset?.call(newCurrency: currency);
                  } else {
                    sRouter.push(
                      AmountRoute(
                        tab: AmountScreenTab.convert,
                        asset: asset,
                        toAsset: currency,
                      ),
                    );
                  }
                },
                skipAssetSymbol: asset?.symbol,
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
              supplement: intl.internal_exchange,
              onTableAssetTap: () {
                sAnalytics.tapOnSelectedNewSellToButton(
                  newSellToMethod: account.isClearjuctionAccount ? 'Simple account' : 'Personal account',
                );
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
                  : '${account.balance?.toFormatSum(symbol: account.currency, accuracy: 2)} ',
            ),
          if (store.isCardsAvaible && store.cards.isNotEmpty) ...[
            STextDivider(intl.deposit_by_cards),
            for (final card in store.cards)
              SimpleTableAsset(
                label: card.label ?? 'Simple card',
                supplement: intl.internal_exchange,
                rightValue: getIt<AppStore>().isBalanceHide
                    ? '**** ${card.currency ?? 'EUR'}'
                    : (card.balance ?? Decimal.zero).toFormatSum(
                        accuracy: 2,
                        symbol: card.currency ?? 'EUR',
                      ),
                isCard: true,
                onTableAssetTap: () {
                  sAnalytics.tapOnSelectedNewSellToButton(
                    newSellToMethod: 'card',
                  );
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
