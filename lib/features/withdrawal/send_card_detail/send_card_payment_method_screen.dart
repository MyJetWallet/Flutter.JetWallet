import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/store/send_card_payment_method_store.dart';
import 'package:jetwallet/utils/formatting/base/decimal_extension.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'SendCardPaymentMethodRouter')
class SendCardPaymentMethodScreen extends StatelessWidget {
  const SendCardPaymentMethodScreen({
    super.key,
    required this.countryCode,
    required this.currency,
  });

  final String countryCode;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    return Provider<SendCardPaymentMethodStore>(
      create: (context) => SendCardPaymentMethodStore()..init(countryCode),
      builder: (context, child) => SendCardPaymentMethodBody(
        countryCode: countryCode,
        currency: currency,
      ),
    );
  }
}

class SendCardPaymentMethodBody extends StatelessObserverWidget {
  const SendCardPaymentMethodBody({
    super.key,
    required this.countryCode,
    required this.currency,
  });

  final String countryCode;
  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final store = SendCardPaymentMethodStore.of(context);

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      header: GlobalBasicAppBar(
        title: intl.global_send_payment_method_title,
        hasRightIcon: false,
      ),
      child: Column(
        children: [
          if (store.showSearch) ...[
            SInput(
              controller: store.searchController,
              label: intl.actionBottomSheetHeader_search,
              onChanged: (String value) => store.search(value),
              keyboardType: TextInputType.text,
              height: 48.0,
            ),
            const SDivider(),
          ],
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 24.0),
              itemCount: store.filtedGlobalSendMethods.length,
              itemBuilder: (context, i) {
                final maxLim = getIt<FormatService>().convertOneCurrencyToAnotherOne(
                  fromCurrency: store.filtedGlobalSendMethods[i].receiveAsset!,
                  fromCurrencyAmmount: store.filtedGlobalSendMethods[i].maxAmount!,
                  toCurrency: currency.symbol,
                  baseCurrency: sSignalRModules.baseCurrency.symbol,
                  isMin: false,
                );

                return SimpleHistoryTable(
                  label: store.filtedGlobalSendMethods[i].name ?? '',
                  supplement: intl.payment_method_current_limits(
                    maxLim.toFormatCount(
                      accuracy: currency.accuracy,
                      symbol: currency.symbol,
                    ),
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: CachedNetworkImage(
                      imageUrl: iconForPaymentMethod(
                        methodId: store.filtedGlobalSendMethods[i].methodId ?? '',
                      ),
                      height: 40.0,
                      width: 40.0,
                      fit: BoxFit.cover,
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      placeholder: (_, __) {
                        return SSkeletonLoader(
                          width: 40,
                          height: 40,
                          borderRadius: BorderRadius.circular(40),
                        );
                      },
                    ),
                  ),
                  onTap: () async {
                    if (!sRouter.stack.any((rout) => rout.name == SendCardDetailRouter.name)) {
                      await sRouter.push(
                        SendCardDetailRouter(
                          countryCode: countryCode,
                          currency: currency,
                          method: store.filtedGlobalSendMethods[i],
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
