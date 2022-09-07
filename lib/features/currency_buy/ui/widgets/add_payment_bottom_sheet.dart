import 'package:flutter/cupertino.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

void showAddPaymentBottomSheet({
  required BuildContext context,
  required List<PaymentMethod> paymentMethods,
  required SimpleColors colors,
  required Function(CircleCard) onCircleCardAdded,
  PaymentMethod? selectedPaymentMethod,
}) {
  sShowBasicModalBottomSheet(
    context: context,
    removePinnedPadding: true,
    pinned: SPaddingH24(
      child: SBottomSheetHeader(
        name: intl.currencyBuy_choosePaymentMethod,
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
              return SActionItem(
                icon: SActionDepositIcon(
                  color: colors.blue,
                ),
                name: intl.curencyBuy_actionItemName,
                description: intl.curencyBuy_actionItemDescription,
                onTap: () {
                  Navigator.pop(context, method);
                  Navigator.pop(context, method);
                },
                helper: '≈10-30 ${intl.min}',
              );
            },
          ),
        ] else if (method.type == PaymentMethodType.circleCard) ...[
          SActionItem(
            icon: SActionDepositIcon(
              color: colors.blue,
            ),
            name: intl.currencyBuy_addBankCard,
            description: intl.curencyBuy_actionItemDescription,
            onTap: () {
              sAnalytics.circleTapAddCard();

              sRouter.navigate(
                AddCircleCardRouter(
                  onCardAdded: (card) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    onCircleCardAdded(card);
                  },
                ),
              );
            },
            helper: '≈10-30 ${intl.min}',
          ),
        ],
      for (final method in paymentMethods)
        if (method.type == PaymentMethodType.unlimintCard) ...[
          Builder(
            builder: (context) {
              return SActionItem(
                icon: SActionDepositIcon(
                  color: colors.blue,
                ),
                name: intl.curencyBuy_unlimint,
                description:
                    intl.curencyBuy_actionItemDescriptionWithoutApplePay,
                onTap: () {
                  Navigator.pop(context, method);
                  Navigator.pop(context, method);
                },
                helper: '≈10-30 ${intl.min}',
              );
            },
          ),
        ],
    ],
  );
}
