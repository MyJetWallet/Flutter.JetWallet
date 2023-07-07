import 'package:flutter/material.dart';
import 'package:jetwallet/features/market/ui/widgets/market_tab_bar_views/components/market_separator.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/widgets/payment_method_card.dart';
import 'package:simple_kit/simple_kit.dart';

class PaymentMethodWidget extends StatelessWidget {
  const PaymentMethodWidget({
    super.key,
    required this.title,
  });

  final String title;

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
            itemCount: 5,
            itemBuilder: (context, i) => PaymentMethodCard.card(
              name: 'test',
              url: '',
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }
}
