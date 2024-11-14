import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/prevent_duplication_events_servise.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/global_loader.dart';
import 'package:jetwallet/utils/formatting/base/decimal_extension.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logger/logger.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/wallet_api/models/p2p_methods/p2p_methods_responce_model.dart';
import 'package:visibility_detector/visibility_detector.dart';

@RoutePage(name: 'BuyP2pPeymentMethodRouter')
class BuyP2pPeymentMethodScreen extends StatefulWidget {
  const BuyP2pPeymentMethodScreen({
    super.key,
    required this.currency,
    required this.paymentCurrecy,
    this.methods = const [],
  });

  final CurrencyModel currency;
  final PaymentAsset paymentCurrecy;
  final List<P2PMethodModel> methods;

  @override
  State<BuyP2pPeymentMethodScreen> createState() => _BuyP2pPeymentMethodScreenState();
}

class _BuyP2pPeymentMethodScreenState extends State<BuyP2pPeymentMethodScreen> {
  List<P2PMethodModel> methods = [];

  @override
  void initState() {
    if (widget.methods.isNotEmpty) {
      methods.addAll(widget.methods);

      methods.sort((a, b) => a.weight.compareTo(b.weight));
    } else {
      loadP2PMethods();
    }
    super.initState();
  }

  Future<void> loadP2PMethods() async {
    try {
      getIt.get<GlobalLoader>().setLoading(true);
      final responce = await sNetwork.getWalletModule().getP2PMethods();

      final result = (responce.data?.methods.where(
                (method) => method.asset == widget.paymentCurrecy.asset,
              ) ??
              [])
          .toList();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          methods.addAll(result);
          methods.sort((a, b) => a.weight.compareTo(b.weight));
        });
      });
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.info,
            place: 'PaymentCurrenceBuyScreen loadP2PMethods',
            message: e.toString(),
          );
    } finally {
      getIt.get<GlobalLoader>().setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('buy_p2p_peyment_method_screen'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          getIt.get<PreventDuplicationEventsService>().sendEvent(
                id: 'buy_p2p_peyment_method_screen',
                event: () {
                  sAnalytics.ptpBuyPaymentMethodScreenView(
                    asset: widget.currency.symbol,
                    ptpCurrency: widget.paymentCurrecy.asset,
                  );
                },
              );
        }
      },
      child: SPageFrame(
        loaderText: '',
        header: SPaddingH24(
          child: SSmallHeader(
            title: intl.buy_flow_payment_method,
            onBackButtonTap: () {
              sRouter.maybePop();
            },
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 24.0),
                itemCount: methods.length,
                itemBuilder: (context, i) {
                  final maxLim = getIt<FormatService>().convertOneCurrencyToAnotherOne(
                    fromCurrency: methods[i].asset,
                    fromCurrencyAmmount: methods[i].maxAmount!,
                    toCurrency: widget.currency.symbol,
                    baseCurrency: sSignalRModules.baseCurrency.symbol,
                    isMin: false,
                  );

                  return SimpleHistoryTable(
                    label: methods[i].name,
                    supplement: intl.payment_method_current_limits(
                      maxLim.toFormatCount(
                        accuracy: widget.currency.accuracy,
                        symbol: widget.currency.symbol,
                      ),
                    ),
                    icon: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CachedNetworkImage(
                        height: 40.0,
                        width: 40.0,
                        imageUrl: iconForPaymentMethod(
                          methodId: methods[i].methodId,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    onTap: () {
                      sAnalytics.tapOnThePTPBuyMethodButton(
                        asset: widget.currency.symbol,
                        ptpCurrency: widget.paymentCurrecy.asset,
                        ptpBuyMethod: methods[i].name,
                      );
                      sRouter.push(
                        P2PBuyAmountRouter(
                          currency: widget.currency,
                          p2pMethod: methods[i],
                          paymentCurrecy: widget.paymentCurrecy,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
