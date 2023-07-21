import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/l10n/i10n.dart';

@RoutePage(name: 'GiftOrderSummuryRouter')
class GiftOrderSummury extends StatelessWidget {
  const GiftOrderSummury({super.key});

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      header: const SPaddingH24(
        child: SSmallHeader(
          title: 'Order Summary',
        ),
      ),
      child: SPaddingH24(
        child: Column(
          children: [
            const Column(
              children: [
                Text(
                  'Your gift',
                  style: TextStyle(
                    color: Color(0xFF777C85),
                    fontSize: 16,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                
                  ),
                ),
                Text(
                  '200 USDT',
                  style: TextStyle(
                    color: Color(0xFF374CFA),
                    fontSize: 24,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w600,
                    
                  ),
                ),
              ],
            ),
            const SpaceH24(),
            const SDivider(),
            const SpaceH19(),
            const SActionConfirmText(
              name: 'To',
              value: 'maksim.k@simple.app',
              baseline: 24,
            ),
            const SpaceH16(),
            const SActionConfirmText(
              name: 'Payment method',
              value: 'Simple Gift',
              baseline: 24,
            ),
            const SpaceH16(),
            const SActionConfirmText(
              name: 'Fee',
              value: '0 USDT',
              baseline: 24,
            ),
            const SpaceH19(),
            const SDivider(),
            const SpaceH19(),
            const SActionConfirmText(
              name: 'Total pay',
              value: '200 USDT',
              baseline: 24,
              valueColor: Color(0xFF374CFA),
            ),
            const SpaceH56(),
            SPrimaryButton2(
              active: true,
              name: intl.previewBuyWithAsset_confirm,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
