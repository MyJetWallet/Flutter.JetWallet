import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/buy_flow/store/sell_payment_method_store.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/payment_methods_widgets/balances_widget.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

void showSellPayWithBottomSheet({
  required BuildContext context,
  CurrencyModel? currency,
  void Function({
    SimpleBankingAccount? account,
  })? onSelected,
  bool hideCards = false,
}) {
  final store = SellPaymentMethodStore()
    ..init(
      asset: currency,
    );

  if (store.accounts.isNotEmpty) {
    sShowBasicModalBottomSheet(
      context: context,
      then: (value) {},
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
  })? onSelected;
  final SellPaymentMethodStore store;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (store.accounts.isNotEmpty) ...[
            const SpaceH24(),
            BalancesWidget(
              onTap: (account) {
                if (onSelected != null) {
                  onSelected!(account: account);
                } else {
                  sRouter.push(
                    AmountRoute(
                      tab: AmountScreenTab.buy,
                      asset: asset!,
                      account: account,
                    ),
                  );
                }
              },
              accounts: store.accounts,
            ),
          ],
          const SpaceH45(),
        ],
      ),
    );
  }
}
