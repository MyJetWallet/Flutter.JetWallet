import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../helpers/is_card_expired.dart';
import '../../add_circle_card/view/add_circle_card.dart';
import '../../card_limits/notifier/card_limits_notipod.dart';
import '../../kyc/model/kyc_operation_status_model.dart';
import '../../kyc/notifier/kyc/kyc_notipod.dart';
import '../notifier/payment_methods_notipod.dart';
import 'components/add_button.dart';
import 'components/card_limit.dart';
import 'components/payment_card_item.dart';

class PaymentMethods extends HookWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  static void push(BuildContext context) {
    navigatorPush(context, const PaymentMethods());
  }

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    final colors = useProvider(sColorPod);
    final state = useProvider(paymentMethodsNotipod);
    final notifier = useProvider(paymentMethodsNotipod.notifier);
    final loader = useValueNotifier(StackLoaderNotifier());
    final kycState = useProvider(kycNotipod);
    final cardLimitsState = useProvider(cardLimitsNotipod);
    final kycHandler = useProvider(kycAlertHandlerPod(context));

    void showDeleteDisclaimer({required VoidCallback onDelete}) {
      return sShowAlertPopup(
        context,
        primaryText: '${intl.paymentMethod_showAlertPopupPrimaryText}?',
        secondaryText: '${intl.paymentMethod_showAlertPopupSecondaryText}?',
        primaryButtonName: intl.paymentMethod_delete,
        secondaryButtonName: intl.paymentMethod_cancel,
        primaryButtonType: SButtonType.primary3,
        onPrimaryButtonTap: onDelete,
        onSecondaryButtonTap: () => Navigator.pop(context),
      );
    }

    void _onAddCardTap() {
      AddCircleCard.push(
        context: context,
        onCardAdded: (_) {
          Navigator.pop(context);
          Navigator.pop(context);
          notifier.getCards();
        },
      );
    }

    void checkKyc() {
      final status = kycOperationStatus(KycStatus.allowed);
      if (kycState.depositStatus == status) {
        _onAddCardTap();
      } else {
        kycHandler.handle(
          status: kycState.depositStatus,
          kycVerified: kycState,
          isProgress: kycState.verificationInProgress,
          currentNavigate: () => _onAddCardTap(),
        );
      }
    }

    return SPageFrame(
      loaderText: intl.paymentMethods_pleaseWait,
      loading: loader.value,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.paymentMethods_paymentMethods,
        ),
      ),
      child: state.union.maybeWhen(
        success: () {
          if (state.cards.isEmpty) {
            return Column(
              children: [
                const Spacer(),
                Text(
                  intl.paymentMethods_noSavedCards,
                  style: sTextH3Style,
                ),
                Text(
                  intl.paymentMethod_text,
                  style: sBodyText1Style.copyWith(
                    color: colors.grey1,
                  ),
                ),
                const Spacer(),
                SPaddingH24(
                  child: AddButton(
                    onTap: () => checkKyc(),
                  ),
                ),
                const SpaceH24(),
              ],
            );
          } else {
            return Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.only(
                    bottom: 100.0,
                  ),
                  children: [
                    if (cardLimitsState.cardLimits != null)
                      CardLimit(cardLimit: cardLimitsState.cardLimits!),
                    const SpaceH10(),
                    for (final card in state.cards)
                      PaymentCardItem(
                        name: '${card.network} •••• ${card.last4}',
                        expirationDate: 'Exp. ${card.expMonth}/${card.expYear}',
                        expired: isCardExpired(card.expMonth, card.expYear),
                        onDelete: () => showDeleteDisclaimer(
                          onDelete: () async {
                            loader.value.startLoading();
                            Navigator.pop(context);
                            await notifier.deleteCard(card.id);
                            loader.value.finishLoading();
                          },
                        ),
                        removeDivider: card.id == state.cards.last.id,
                      ),
                  ],
                ),
                SFloatingButtonFrame(
                  button: AddButton(
                    onTap: () => checkKyc(),
                  ),
                ),
              ],
            );
          }
        },
        orElse: () {
          return const LoaderSpinner();
        },
      ),
    );
  }
}
