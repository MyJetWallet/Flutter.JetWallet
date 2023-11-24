import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';

import '../../../../core/di/di.dart';
import '../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../utils/formatting/base/market_format.dart';
import '../../../../utils/helpers/currencies_helpers.dart';
import '../../../../utils/models/currency_model.dart';
import '../../../actions/helpers/show_currency_search.dart';
import '../../../actions/store/action_search_store.dart';

@RoutePage(name: 'ChooseAssetRouter')
class ChooseAssetScreen extends StatefulObserverWidget {
  const ChooseAssetScreen({super.key, required this.onChooseAsset});

  final void Function(CurrencyModel currency) onChooseAsset;

  @override
  State<ChooseAssetScreen> createState() => _ChooseAssetScreenState();
}

class _ChooseAssetScreenState extends State<ChooseAssetScreen> {
  final searchStore = getIt.get<ActionSearchStore>();

  @override
  void initState() {
    super.initState();

    searchStore.searchController = TextEditingController();

    final currenciesList = sSignalRModules.currenciesList.where((currency) {
      return currency.buyMethods.any((buyMethod) {
        return buyMethod.id == PaymentMethodType.bankCard || buyMethod.id == PaymentMethodType.ibanTransferUnlimint;
      });
    }).toList();

    searchStore.init(
      customCurrencies: currenciesList,
    );
    searchStore.refreshSearch();
  }

  @override
  Widget build(BuildContext context) {
    final showSearch = showBuyCurrencySearch(
      context,
      fromCard: true,
      searchStore: searchStore,
    );
    sortByBalanceAndWeight(searchStore.buyFromCardCurrencies);

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.choose_asser_screan_header,
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (showSearch)
              SPaddingH24(
                child: Column(
                  children: [
                    SStandardField(
                      controller: searchStore.searchController,
                      hintText: intl.actionBottomSheetHeader_search,
                      onChanged: (String value) {
                        searchStore.search(value);
                      },
                      maxLines: 1,
                      height: 44,
                    ),
                    const SDivider(),
                  ],
                ),
              ),
            Observer(
              builder: (context) {
                return ChooseAssetBody(
                  searchStore: searchStore,
                  onChooseAsset: widget.onChooseAsset,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChooseAssetBody extends StatelessObserverWidget {
  const ChooseAssetBody({
    required this.searchStore,
    required this.onChooseAsset,
  });

  final ActionSearchStore searchStore;
  final void Function(CurrencyModel currency) onChooseAsset;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final state = searchStore;

    sortByBalanceAndWeight(state.fCurrencies);

    return Column(
      children: [
        for (final currency in state.buyFromCardCurrencies) ...[
          if (currency.supportsAtLeastOneBuyMethod && currency.type == AssetType.crypto)
            SMarketItem(
              icon: SNetworkSvg24(
                url: currency.iconUrl,
              ),
              name: currency.description,
              price: marketFormat(
                decimal: baseCurrency.symbol == currency.symbol ? Decimal.one : currency.currentPrice,
                symbol: baseCurrency.symbol,
                accuracy: baseCurrency.accuracy,
              ),
              ticker: currency.symbol,
              last: true,
              percent: currency.dayPercentChange,
              onTap: () => onChooseAsset(currency),
              height: 80,
            ),
        ],
        const SpaceH42(),
      ],
    );
  }
}
