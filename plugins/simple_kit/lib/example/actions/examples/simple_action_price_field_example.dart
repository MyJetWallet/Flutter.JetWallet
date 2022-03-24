import 'package:flutter/material.dart';

import '../../../simple_kit.dart';

class SimpleActionPriceFieldExample extends StatelessWidget {
  const SimpleActionPriceFieldExample({Key? key}) : super(key: key);

  static const routeName = '/simple_action_price_field_example';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                const SActionPriceField(
                  isSmall: false,
                  price: '0.1 DASH',
                  helper: '≈ 11.50643382 ALGO (\$22.82)',
                  error: 'Enter a higher amount',
                  isErrorActive: false,
                ),
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 60.0,
                      color: Colors.green.withOpacity(0.2),
                      child: const Text(
                        '60px',
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 24.0,
                      color: Colors.red.withOpacity(0.2),
                      child: const Text(
                        '24px',
                        textAlign: TextAlign.end,
                      ),
                    )
                  ],
                )
              ],
            ),
            const SpaceH20(),
            const SActionPriceField(
              isSmall: false,
              price: '0.1 DASH',
              helper: '≈ 11.50643382 ALGO (\$22.82)',
              error: 'Enter a higher amount',
              isErrorActive: false,
            ),
            const SpaceH20(),
            const SActionPriceField(
              isSmall: false,
              price: '0.1 DASH',
              helper: '≈ 11.50643382 ALGO (\$22.82)',
              error: 'Enter a higher amount',
              isErrorActive: true,
            )
          ],
        ),
      ),
    );
  }
}
