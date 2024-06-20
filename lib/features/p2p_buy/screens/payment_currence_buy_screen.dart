import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/countries_service.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/buy_flow/store/payment_method_store.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

@RoutePage(name: 'PaymentCurrenceBuyRouter')
class PaymentCurrenceBuyScreen extends StatelessWidget {
  const PaymentCurrenceBuyScreen({super.key, required this.currency});

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final availableCurrency = getP2PPaymentAssetsList();
    final countryService = CountriesService();

    return SPageFrame(
      loaderText: '',
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.buy_payment_currency,
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverList.builder(
            itemCount: availableCurrency.length,
            itemBuilder: (context, index) {
              final curr = getIt.get<FormatService>().findCurrency(
                    findInHideTerminalList: true,
                    assetSymbol: availableCurrency[index].asset,
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
                            availableCurrency[index].asset,
                          )
                          .flagAssetName(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                spaceBIandText: 10,
                height: 69,
                onTap: () {
                  sRouter.push(BuyP2pPeymentMethodRouter(currency: currency, paymentCurrecy: availableCurrency[index]));
                },
                needSpacer: true,
                rightIcon: Text(
                  availableCurrency[index].asset,
                  style: sSubtitle3Style.copyWith(
                    color: sKit.colors.grey2,
                  ),
                ),
                amount: '',
                description: '',
                name: curr.description,
              );
            },
          ),
        ],
      ),
    );
  }

  List<PaymentAsset> getP2PPaymentAssetsList() {
    final availableCurrency = <PaymentAsset>[];

    final baseCurrency = sSignalRModules.baseCurrency;

    for (var i = 0; i < currency.buyMethods.length; i++) {
      for (var g = 0; g < currency.buyMethods[i].paymentAssets!.length; g++) {
        if (!checkIsCurrencyAlreadyAdd(
          currency.buyMethods[i].paymentAssets![g].asset,
          availableCurrency,
        )) {
          final isLimitNotReach = currency.buyMethods[i].paymentAssets![g].maxAmount != Decimal.zero;

          if (currency.buyMethods[i].category == PaymentMethodCategory.cards) {
            if (!isCardReachLimit(currency.buyMethods[i].paymentAssets![g]) && isLimitNotReach) {
              availableCurrency.add(currency.buyMethods[i].paymentAssets![g]);
            }
          } else {
            if (isLimitNotReach) {
              availableCurrency.add(currency.buyMethods[i].paymentAssets![g]);
            }
          }
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

    return availableCurrency;
  }

  bool checkIsCurrencyAlreadyAdd(String asset, List<PaymentAsset> availableCurrency) {
    final ind = availableCurrency.indexWhere((element) => element.asset == asset);

    return ind != -1;
  }
}
