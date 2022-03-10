import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../enter_card_details/view/enter_card_details.dart';
import '../notifier/payment_methods_notipod.dart';
import 'components/payment_card_item.dart';

class PaymentMethods extends HookWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  static void push(BuildContext context) {
    navigatorPush(context, const PaymentMethods());
  }

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final state = useProvider(paymentMethodsNotipod);
    final notifier = useProvider(paymentMethodsNotipod.notifier);

    return SPageFrame(
      header: const SPaddingH24(
        child: SSmallHeader(
          title: 'Payment methods',
        ),
      ),
      child: state.union.maybeWhen(
        success: () {
          return Stack(
            children: [
              ListView(
                padding: const EdgeInsets.only(
                  bottom: 100.0,
                ),
                children: [
                  SPaddingH24(
                    child: Text(
                      'Saved cards',
                      style: sSubtitle3Style.copyWith(
                        color: colors.grey1,
                      ),
                    ),
                  ),
                  const SpaceH30(),
                  PaymentCardItem(
                    name: 'Visa •••• 2812',
                    expirationDate: 'Exp. 07/21',
                    expired: false,
                    onDelete: () {
                      sShowAlertPopup(
                        context,
                        primaryText: 'Delete card?',
                        secondaryText: 'Are you sure you want to '
                            'delete your saved card?',
                        primaryButtonName: 'Delete',
                        secondaryButtonName: 'Cancel',
                        primaryButtonType: SButtonType.primary3,
                        onPrimaryButtonTap: () => notifier.deleteCard(),
                        onSecondaryButtonTap: () => Navigator.pop(context),
                      );
                    },
                  ),
                  PaymentCardItem(
                    name: 'Mastercard •••• 3785',
                    expirationDate: 'Exp. 01/21',
                    expired: true,
                    removeDivider: true,
                    onDelete: () {},
                  )
                ],
              ),
              SFloatingButtonFrame(
                button: SSecondaryButton1(
                  active: true,
                  name: 'Add bank card',
                  onTap: () {
                    EnterCardDetails.push(context);
                  },
                ),
              )
            ],
          );
        },
        orElse: () {
          return const LoaderSpinner();
        },
      ),
    );
  }
}
