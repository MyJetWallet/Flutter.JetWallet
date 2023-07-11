import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/widgets/payment_method_card.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
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
        const SizedBox(height: 16),
        SPaddingH24(
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1 / .59,
            ),
            itemCount: buyMethod.length,
            itemBuilder: (context, i) {
              return PaymentMethodCard.card(
                name: buyMethod[i].id.name,
                url: '',
                onTap: () {
                  sRouter.push(
                    BuyAmountRoute(
                      asset: asset,
                      currency: currency,
                      method: buyMethod[i],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
