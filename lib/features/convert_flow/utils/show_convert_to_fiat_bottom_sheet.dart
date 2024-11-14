import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/convert_flow/store/globa_convert_to_store.dart';
import 'package:jetwallet/utils/formatting/base/decimal_extension.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

void showConvertToFiatBottomSheet({
  required BuildContext context,
  required CurrencyModel fromAsset,
}) {
  final store = GlobaConvertToStore();

  showBasicBottomSheet(
    context: context,
    header: BasicBottomSheetHeaderWidget(
      title: intl.convert_choose_account,
    ),
    children: [
      Observer(
        builder: (context) {
          return Column(
            children: [
              if (store.accounts.isNotEmpty) ...[
                STextDivider(intl.deposit_by_accounts),
                for (final account in store.accounts)
                  SimpleTableAsset(
                    label: account.label ?? 'Account 1',
                    supplement: intl.internal_exchange,
                    rightValue: getIt<AppStore>().isBalanceHide
                        ? '**** ${account.currency ?? 'EUR'}'
                        : (account.balance ?? Decimal.zero).toFormatSum(
                            accuracy: 2,
                            symbol: account.currency ?? 'EUR',
                          ),
                    assetIcon: Assets.svg.assets.fiat.account.simpleSvg(
                      width: 24,
                    ),
                    onTableAssetTap: () {
                      sRouter.push(
                        AmountRoute(
                          tab: AmountScreenTab.sell,
                          asset: fromAsset,
                          account: account,
                        ),
                      );
                    },
                  ),
              ],
              if (store.cards.isNotEmpty) ...[
                STextDivider(intl.deposit_by_cards),
                for (final card in store.cards)
                  SimpleTableAsset(
                    label: card.label ?? '',
                    supplement: intl.internal_exchange,
                    rightValue: getIt<AppStore>().isBalanceHide
                        ? '**** ${card.currency ?? 'EUR'}'
                        : (card.balance ?? Decimal.zero).toFormatSum(
                            accuracy: 2,
                            symbol: card.currency ?? 'EUR',
                          ),
                    isCard: true,
                    onTableAssetTap: () {
                      sRouter.push(
                        AmountRoute(
                          tab: AmountScreenTab.sell,
                          asset: fromAsset,
                          simpleCard: card,
                        ),
                      );
                    },
                  ),
              ],
            ],
          );
        },
      ),
      const SpaceH42(),
    ],
  );
}
