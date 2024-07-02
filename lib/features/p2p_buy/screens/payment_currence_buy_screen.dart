import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/countries_service.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/prevent_duplication_events_servise.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logger/logger.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/wallet_api/models/p2p_methods/p2p_methods_responce_model.dart';
import 'package:visibility_detector/visibility_detector.dart';

@RoutePage(name: 'PaymentCurrenceBuyRouter')
class PaymentCurrenceBuyScreen extends StatefulWidget {
  const PaymentCurrenceBuyScreen({super.key, required this.currency});

  final CurrencyModel currency;

  @override
  State<PaymentCurrenceBuyScreen> createState() => _PaymentCurrenceBuyScreenState();
}

class _PaymentCurrenceBuyScreenState extends State<PaymentCurrenceBuyScreen> {
  List<P2PMethodModel> p2pMethods = [];

  @override
  void initState() {
    super.initState();

    loadP2PMethods();
  }

  Future<void> loadP2PMethods() async {
    try {
      final responce = await sNetwork.getWalletModule().getP2PMethods();

      final result = responce.data?.methods ?? [];

      p2pMethods.addAll(result);
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.info,
            place: 'PaymentCurrenceBuyScreen loadP2PMethods',
            message: e.toString(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableCurrency = getP2PPaymentAssetsList();
    final countryService = CountriesService();

    return VisibilityDetector(
      key: const Key('payment_currence_buy_screen'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          getIt.get<PreventDuplicationEventsService>().sendEvent(
                id: 'payment_currence_buy_screen',
                event: () {
                  sAnalytics.ptpBuyPaymentCurrencyScreenView(asset: widget.currency.symbol);
                },
              );
        }
      },
      child: SPageFrame(
        loaderText: '',
        header: SPaddingH24(
          child: SSmallHeader(
            title: intl.buy_payment_currency,
            onBackButtonTap: () {
              sAnalytics.tapOnTheBackFromPTPBuyPaymentCurrencyButton(asset: widget.currency.symbol);
              sRouter.maybePop();
            },
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
                    sAnalytics.tapOnThePTPBuyCurrencyButton(
                      asset: widget.currency.symbol,
                      ptpCurrency: availableCurrency[index].asset,
                    );

                    final p2pMethodsForCurrency = p2pMethods
                        .where(
                          (method) => method.asset == availableCurrency[index].asset,
                        )
                        .toList();

                    sRouter.push(
                      BuyP2pPeymentMethodRouter(
                        currency: widget.currency,
                        paymentCurrecy: availableCurrency[index],
                        methods: p2pMethodsForCurrency,
                      ),
                    );
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
      ),
    );
  }

  List<PaymentAsset> getP2PPaymentAssetsList() {
    final availableCurrency = <PaymentAsset>[];

    final baseCurrency = sSignalRModules.baseCurrency;

    final p2pBuyMethod =
        widget.currency.buyMethods.firstWhere((buyMethod) => buyMethod.id == PaymentMethodType.paymeP2P);

    availableCurrency.addAll(p2pBuyMethod.paymentAssets ?? []);

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
