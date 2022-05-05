import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/asset_model.dart';

import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../crypto_deposit/view/crypto_deposit.dart';
import '../helpers/show_currency_search.dart';
import '../shared/components/action_bottom_sheet_header.dart';
import '../shared/notifier/action_search_notipod.dart';
import 'components/deposit_category_description.dart';
import 'components/deposit_options.dart';

void showDepositAction(BuildContext context) {
  final showSearch = showDepositCurrencySearch(context);
  Navigator.pop(context);
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: ActionBottomSheetHeader(
      name: 'Choose asset to deposit',
      showSearch: showSearch,
      onChanged: (String value) {
        context.read(actionSearchNotipod.notifier).search(value);
      },
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [const _ActionDeposit()],
  );
}

class _ActionDeposit extends HookWidget {
  const _ActionDeposit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(actionSearchNotipod);

    final fiat = state.filteredCurrencies.where(
      (e) => e.type == AssetType.fiat && e.supportsAtLeastOneFiatDepositMethod,
    );
    final crypto = state.filteredCurrencies.where(
      (e) => e.type == AssetType.crypto && e.supportsCryptoDeposit,
    );

    return Column(
      children: [
        if (fiat.isNotEmpty) ...[
          const SpaceH10(),
          const DepositCategoryDescription(
            text: 'Fiat',
          ),
          for (final currency in fiat)
            SWalletItem(
              removeDivider: currency.symbol == crypto.last.symbol,
              icon: SNetworkSvg24(
                url: currency.iconUrl,
              ),
              primaryText: currency.description,
              secondaryText: currency.symbol,
              onTap: () {
                showDepositOptions(context, currency);
              },
            ),
        ],
        if (crypto.isNotEmpty) ...[
          if (fiat.isEmpty) const SpaceH10(),
          const DepositCategoryDescription(
            text: 'Crypto',
          ),
          for (final currency in crypto)
            SWalletItem(
              removeDivider: currency.symbol == crypto.last.symbol,
              icon: SNetworkSvg24(
                url: currency.iconUrl,
              ),
              primaryText: currency.description,
              secondaryText: currency.symbol,
              onTap: () {
                sAnalytics.depositCryptoView(currency.description);

                navigatorPushReplacement(
                  context,
                  CryptoDeposit(
                    header: 'Deposit',
                    currency: currency,
                  ),
                );
              },
            ),
        ],
      ],
    );
  }
}
