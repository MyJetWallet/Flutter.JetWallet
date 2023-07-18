import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/buy_flow/store/payment_method_store.dart';
import 'package:jetwallet/features/currency_buy/helper/formatted_circle_card.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/widgets/payment_method_card.dart';
import 'package:jetwallet/utils/helpers/capitalize_text.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
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

    return SPaddingH24(
      child: DynamicHeightGridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        builder: (ctx, i) {
          if (list[i].type == 0) {
            final formatted = formattedCircleCard(
              list[i].card!,
              sSignalRModules.baseCurrency,
            );

            return PaymentMethodCard.bankCard(
              network: list[i].card!.network,
              name: list[i].card!.cardLabel ?? '',
              subName: formatted.last4Digits,
              onTap: () {
                sRouter.push(
                  BuyAmountRoute(
                    asset: asset,
                    currency: currency,
                    method: store.cardsMethods.first,
                    card: list[i].card!,
                  ),
                );
              },
            );
          } else {
            return PaymentMethodCard.card(
              name: capitalizeText(
                list[i].method!.id.name ?? '  ',
              ),
              url: iconForPaymentMethod(
                methodId: list[i].method!.id.name,
              ),
              onTap: () {
                sRouter.push(
                  BuyAmountRoute(
                    asset: asset,
                    currency: currency,
                    method: list[i].method!,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
