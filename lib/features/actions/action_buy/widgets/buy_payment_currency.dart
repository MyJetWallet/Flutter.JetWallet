import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/countries_service.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/utils/helpers/flag_asset_name.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_kit/modules/bottom_sheets/components/basic_bottom_sheet/show_basic_modal_bottom_sheet.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

void showBuyPaymentCurrencyBottomSheet(
  BuildContext context,
  CurrencyModel currency,
) {
  final availableCurrency = <PaymentAsset>[];

  final baseCurrency = sSignalRModules.baseCurrency;

  bool checkIsCurrencyAlreadyAdd(String asset) {
    final ind =
        availableCurrency.indexWhere((element) => element.asset == asset);

    return ind == -1 ? false : true;
  }

  for (var i = 0; i < currency.buyMethods.length; i++) {
    for (var g = 0; g < currency.buyMethods[i].paymentAssets!.length; g++) {
      if (!checkIsCurrencyAlreadyAdd(
        currency.buyMethods[i].paymentAssets![g].asset,
      )) {
        availableCurrency.add(currency.buyMethods[i].paymentAssets![g]);
      }
    }
  }

  availableCurrency.sort(
    (a, b) {
      if (a.asset == baseCurrency.symbol) {
        return 0.compareTo(1);
      } else if (b.asset == baseCurrency.symbol) {
        return 1.compareTo(0);
      }

      return (a.orderId ?? 0).compareTo(b.orderId ?? 0);
    },
  );

  log(availableCurrency.toString());

  final searchStore = ActionSearchStore();
  searchStore.newBuySearchInit(availableCurrency);

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: availableCurrency.length >= 7,
    expanded: availableCurrency.length >= 7,
    then: (value) {},
    pinned: ActionBottomSheetHeader(
      name: intl.buy_payment_currency,
      showSearch: availableCurrency.length >= 7,
      onChanged: (String value) {
        searchStore.newBuySearch(value);
      },
      needBottomPadding: false,
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      _BuyPaymentCurrency(
        asset: currency,
        searchStore: searchStore,
      ),
      const SpaceH42(),
    ],
  );
}

class _BuyPaymentCurrency extends StatelessObserverWidget {
  const _BuyPaymentCurrency({
    super.key,
    required this.asset,
    required this.searchStore,
  });

  final CurrencyModel asset;
  final ActionSearchStore searchStore;

  @override
  Widget build(BuildContext context) {
    var countryService = CountriesService();

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: searchStore.filtredNewBuyPaymentCurrency.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final curr = getIt.get<FormatService>().findCurrency(
              findInHideTerminalList: true,
              assetSymbol:
                  searchStore.filtredNewBuyPaymentCurrency[index].asset,
            );

        return SCardRow(
          icon: SizedBox(
            height: 24,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              height: 24,
              width: 24,
              child: SvgPicture.asset(
                countryService
                    .findCountryByCurrency(
                      searchStore.filtredNewBuyPaymentCurrency[index].asset,
                    )
                    .flagAssetName(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          spaceBIandText: 10,
          height: 69,
          onTap: () {
            sRouter.push(
              BuyPaymentMethodRoute(
                asset: asset,
                currency: searchStore.filtredNewBuyPaymentCurrency[index],
              ),
            );
          },
          needSpacer: true,
          rightIcon: Text(
            searchStore.filtredNewBuyPaymentCurrency[index].asset,
            style: sSubtitle3Style.copyWith(
              color: sKit.colors.grey2,
            ),
          ),
          amount: '',
          description: '',
          name: curr.description,
        );
      },
    );
  }
}
