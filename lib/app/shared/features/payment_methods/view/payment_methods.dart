import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../helpers/is_card_expired.dart';
import '../../../helpers/last_n_chars.dart';
import '../../add_circle_card/view/add_circle_card.dart';
import '../notifier/payment_methods_notipod.dart';
import 'components/add_button.dart';
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

    void showDeleteDisclaimer({required VoidCallback onDelete}) {
      return sShowAlertPopup(
        context,
        primaryText: '${intl.paymentMethod_showAlertPopupPrimaryText}?',
        secondaryText: '${intl.paymentMethod_showAlertPopupSecondaryText}?',
        primaryButtonName: intl.delete,
        secondaryButtonName: intl.cancel,
        primaryButtonType: SButtonType.primary3,
        onPrimaryButtonTap: onDelete,
        onSecondaryButtonTap: () => Navigator.pop(context),
      );
    }

    void onAddCardTap() {
      AddCircleCard.push(
        context: context,
        onCardAdded: () {
          Navigator.pop(context);
          Navigator.pop(context);
          notifier.getCards();
        },
      );
    }

    return SPageFrame(
      loaderText: intl.pleaseWait,
      loading: loader.value,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.paymentMethods,
        ),
      ),
      child: state.union.maybeWhen(
        success: () {
          if (state.cards.isEmpty) {
            return Column(
              children: [
                const Spacer(),
                Text(
                  intl.noSavedCards,
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
                    onTap: onAddCardTap,
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
                    SPaddingH24(
                      child: Text(
                        intl.savedCards,
                        style: sSubtitle3Style.copyWith(
                          color: colors.grey1,
                        ),
                      ),
                    ),
                    const SpaceH30(),
                    for (final card in state.cards)
                      PaymentCardItem(
                        name: '${card.network} •••• '
                            '${lastNChars(card.cardName, 4)}',
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
                    onTap: onAddCardTap,
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
