import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/circle/model/circle_card.dart';
import 'package:simple_networking/services/signal_r/model/asset_payment_methods.dart';

import '../../../../../../shared/providers/service_providers.dart';
import '../../../add_circle_card/view/add_circle_card.dart';

void showAddPaymentBottomSheet({
  required BuildContext context,
  required List<PaymentMethod> paymentMethods,
  required SimpleColors colors,
  required Function(CircleCard) onCircleCardAdded,
  PaymentMethod? selectedPaymentMethod,
}) {
  final intl = context.read(intlPod);

  sShowBasicModalBottomSheet(
    context: context,
    removePinnedPadding: true,
    pinned: SPaddingH24(
      child: SBottomSheetHeader(
        name: intl.currencyBuy_addPaymentMethod,
      ),
    ),
    horizontalPinnedPadding: 0,
    scrollable: true,
    children: [
      const SpaceH24(),
      for (final method in paymentMethods)
        if (method.type == PaymentMethodType.simplex) ...[
          Builder(
            builder: (context) {
              final isSelected = selectedPaymentMethod?.type ==
                  PaymentMethodType.simplex;
              return SActionItem(
                isSelected: isSelected,
                icon: SActionDepositIcon(
                  color: colors.blue,
                ),
                name: intl.curencyBuy_actionItemName,
                description: intl.curencyBuy_actionItemDescription,
                onTap: () => Navigator.pop(context, method),
                helper: '≈10-30 ${intl.min}',
              );
            },
          ),
        ] else if (method.type == PaymentMethodType.circleCard) ...[
          SActionItem(
            icon: SActionDepositIcon(
              color: colors.blue,
            ),
            name: '${intl.currencyBuy_addBankCard} - Circle',
            description: 'Visa, Mastercard, Apple Pay',
            onTap: () {
              sAnalytics.circleTapAddCard();
              AddCircleCard.pushReplacement(
                context: context,
                onCardAdded: (card) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  onCircleCardAdded(card);
                },
              );
            },
            helper: '≈10-30 ${intl.min}',
          ),
        ],
    ],
  );
}
