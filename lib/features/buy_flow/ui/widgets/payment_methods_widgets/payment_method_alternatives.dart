import 'package:flutter/material.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/widgets/payment_method_card.dart';
import 'package:jetwallet/utils/helpers/capitalize_text.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

class PaymentMethodAltWidget extends StatelessWidget {
  const PaymentMethodAltWidget({
    super.key,
    required this.title,
    required this.buyMethod,
    required this.asset,
    required this.currency,
  });

  final String title;
  final List<BuyMethodDto> buyMethod;
  final CurrencyModel asset;
  final PaymentAsset currency;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        MarketSeparator(text: title),
        const SpaceH16(),
        ResponsiveGridList(
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
          children: buyMethod.map(
            (e) {
              return PaymentMethodCard.card(
                name: e.name ?? capitalizeText(e.id.name),
                url: iconForPaymentMethod(
                  methodId: e.id.name,
                ),
                onTap: () {
                  sRouter.push(
                    BuyAmountRoute(
                      asset: asset,
                      currency: currency,
                      method: e,
                    ),
                  );
                },
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
