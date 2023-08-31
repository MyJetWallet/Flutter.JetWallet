import 'package:flutter/material.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/buy_flow/store/payment_method_store.dart';
import 'package:jetwallet/features/currency_buy/helper/formatted_circle_card.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/widgets/payment_method_card.dart';
import 'package:jetwallet/utils/helpers/capitalize_text.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

class PaymentMethodSearchOut extends StatelessWidget {
  const PaymentMethodSearchOut({
    super.key,
    required this.title,
    required this.list,
    required this.asset,
    required this.currency,
  });

  final String title;
  final List<PaymentMethodSearchModel> list;
  final CurrencyModel asset;
  final PaymentAsset currency;

  @override
  Widget build(BuildContext context) {
    final store = PaymentMethodStore.of(context);

    return ResponsiveGridList(
      horizontalGridSpacing: 12,
      verticalGridSpacing: 12,
      horizontalGridMargin: 24,
      minItemsPerRow: 2,
      maxItemsPerRow: 2,
      minItemWidth: 157,
      listViewBuilderOptions: ListViewBuilderOptions(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
      ),
      children: list.map(
        (e) {
          if (e.type == 0) {
            final formatted = formattedCircleCard(
              e.card!,
              sSignalRModules.baseCurrency,
            );

            return PaymentMethodCard.bankCard(
              network: e.card!.network,
              name: e.card!.cardLabel ?? '',
              subName: formatted.last4Digits,
              onTap: () {
                sRouter.push(
                  BuyAmountRoute(
                    asset: asset,
                    currency: currency,
                    method: store.cardsMethods.first,
                    card: e.card!,
                  ),
                );
              },
            );
          } else {
            return PaymentMethodCard.card(
              name: e.method?.name ??
                  capitalizeText(
                    e.method!.id.name ?? '  ',
                  ),
              url: iconForPaymentMethod(
                methodId: e.method!.id.name,
              ),
              onTap: () {
                sRouter.push(
                  BuyAmountRoute(
                    asset: asset,
                    currency: currency,
                    method: e.method!,
                  ),
                );
              },
            );
          }
        },
      ).toList(),
    );
  }
}
