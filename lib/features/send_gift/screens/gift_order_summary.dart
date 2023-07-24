import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/l10n/i10n.dart';
import '../store/general_send_gift_store.dart';
import '../widgets/simple_action_confirm_text_with_icon.dart';

@RoutePage(name: 'GiftOrderSummuryRouter')
class GiftOrderSummury extends StatelessWidget {
  const GiftOrderSummury({super.key, required this.sendGiftStore});
  final GeneralSendGiftStore sendGiftStore;

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
            Column(
              children: [
                const Text(
                  'Your gift',
                  style: TextStyle(
                    color: Color(0xFF777C85),
                    fontSize: 16,
                    fontFamily: 'Gilroy',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  volumeFormat(
                    prefix: sendGiftStore.currency.prefixSymbol,
                    decimal: sendGiftStore.amount,
                    accuracy: sendGiftStore.currency.accuracy,
                    symbol: sendGiftStore.currency.symbol,
                  ),
                  style: const TextStyle(
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
            SActionConfirmText(
              name: 'To',
              value: sendGiftStore.receiverContact,
              baseline: 24,
            ),
            const SpaceH16(),
            const SActionConfirmTextWiyhIcon(
              name: 'Payment method',
              value: 'Simple Gift',
              baseline: 24,
              icon: SizedBox(
                width: 16,
                height: 16,
                child: SGiftSendIcon(),
              ),
            ),
            const SpaceH16(),
            SActionConfirmText(
              name: 'Fee',
              value: volumeFormat(
                prefix: sendGiftStore.currency.prefixSymbol,
                decimal: sendGiftStore.currency.fees.withdrawalFee?.size ??
                    Decimal.zero,
                accuracy: sendGiftStore.currency.accuracy,
                symbol: sendGiftStore.currency.symbol,
              ),
              baseline: 24,
            ),
            const SpaceH19(),
            const SDivider(),
            const SpaceH19(),
            SActionConfirmText(
              name: 'Total pay',
              value: volumeFormat(
                prefix: sendGiftStore.currency.prefixSymbol,
                decimal: sendGiftStore.amount,
                accuracy: sendGiftStore.currency.accuracy,
                symbol: sendGiftStore.currency.symbol,
              ),
              baseline: 24,
              valueColor: const Color(0xFF374CFA),
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
