import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../notifier/add_circle_card_notipod.dart';
import '../components/circle_progress_indicator.dart';
import '../components/continue_button_frame.dart';
import '../components/scrolling_frame.dart';
import 'components/country_selector_button.dart';
import 'components/show_country_selector.dart';

class CircleBillingAddress extends HookWidget {
  const CircleBillingAddress({
    Key? key,
    required this.onCardAdded,
  }) : super(key: key);

  final VoidCallback onCardAdded;

  static void push({
    required BuildContext context,
    required VoidCallback onCardAdded,
  }) {
    navigatorPush(
      context,
      CircleBillingAddress(
        onCardAdded: onCardAdded,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = useProvider(addCircleCardNotipod);
    final notifier = useProvider(addCircleCardNotipod.notifier);
    final enableButton = useState(true);

    final navigationAllowed =
        (state.loader?.value ?? true) || enableButton.value;

    return WillPopScope(
      onWillPop: () => Future.value(navigationAllowed),
      child: SPageFrame(
        loading: state.loader,
        header: SPaddingH24(
          child: SBigHeader(
            onBackButtonTap: () {
              if (navigationAllowed) {
                Navigator.pop(context);
              }
            },
            title: 'Billing address',
          ),
        ),
        child: Column(
          children: [
            const CircleProgressIndicator(),
            ScrollingFrame(
              children: [
                SFieldDividerFrame(
                  child: SStandardField(
                    labelText: 'Street Address',
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: notifier.updateAddress1,
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    labelText: 'Street Address 2 (optional)',
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: notifier.updateAddress2,
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    labelText: 'City',
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: notifier.updateCity,
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    labelText: 'District',
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: notifier.updateDistrict,
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    labelText: 'Postal code',
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: notifier.updatePostalCode,
                  ),
                ),
                CountrySelectorButton(
                  country: state.selectedCountry!,
                  onTap: () => showCountrySelector(context),
                ),
                const Spacer(),
                ContinueButtonFrame(
                  child: SPrimaryButton2(
                    active: navigationAllowed && state.isBillingAddressValid,
                    name: 'Continue',
                    onTap: () async {
                      enableButton.value = false;
                      await notifier.addCard(
                        onSuccess: onCardAdded,
                        onError: () {
                          Navigator.pop(context);
                          notifier.clearBillingDetails();
                          enableButton.value = true;
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
