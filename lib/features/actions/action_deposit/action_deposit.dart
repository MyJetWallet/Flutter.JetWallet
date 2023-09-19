import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/actions/action_deposit/widgets/deposit_category_description.dart';
import 'package:jetwallet/features/actions/action_deposit/widgets/deposit_options.dart';
import 'package:jetwallet/features/actions/helpers/show_currency_search.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

void showDepositAction(BuildContext context) {
  final showSearch = showDepositCurrencySearch(context);
  Navigator.pop(context);
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: ActionBottomSheetHeader(
      name: intl.actionDeposit_bottomSheetHeaderName1,
      showSearch: showSearch,
      onChanged: (String value) {
        getIt.get<ActionSearchStore>().search(value);
      },
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [const _ActionDeposit()],
  );
}

class _ActionDeposit extends StatelessObserverWidget {
  const _ActionDeposit();

  @override
  Widget build(BuildContext context) {
    final state = getIt.get<ActionSearchStore>();

    final fiat = state.fCurrencies.where(
      (e) => e.type == AssetType.fiat && e.supportsAtLeastOneFiatDepositMethod,
    );
    final crypto = state.fCurrencies.where(
      (e) => e.type == AssetType.crypto && e.supportsCryptoDeposit,
    );

    return Column(
      children: [
        if (fiat.isNotEmpty) ...[
          const SpaceH10(),
          DepositCategoryDescription(
            text: intl.actionDeposit_fiat,
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
          DepositCategoryDescription(
            text: intl.actionDeposit_crypto,
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
                getIt.get<AppRouter>().navigate(
                      CryptoDepositRouter(
                        header: intl.actionDeposit_deposit,
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
