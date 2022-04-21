import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/helpers/navigator_push.dart';
import '../../notifier/add_circle_card_notipod.dart';
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
    final colors = useProvider(sColorPod);
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
            Container(
              height: 4.0,
              color: colors.blue,
            ),
            Expanded(
              child: Container(
                color: colors.grey5,
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        children: [
                          SFieldDividerFrame(
                            child: SStandardField(
                              labelText: 'Street Address',
                              onChanged: notifier.updateAddress1,
                            ),
                          ),
                          SFieldDividerFrame(
                            child: SStandardField(
                              labelText: 'Street Address 2 (optional)',
                              onChanged: notifier.updateAddress2,
                            ),
                          ),
                          SFieldDividerFrame(
                            child: SStandardField(
                              labelText: 'City',
                              onChanged: notifier.updateCity,
                            ),
                          ),
                          SFieldDividerFrame(
                            child: SStandardField(
                              labelText: 'District',
                              onChanged: notifier.updateDistrict,
                            ),
                          ),
                          SFieldDividerFrame(
                            child: SStandardField(
                              labelText: 'Postal code',
                              onChanged: notifier.updatePostalCode,
                            ),
                          ),
                          CountrySelectorButton(
                            country: state.selectedCountry!,
                            onTap: () => showCountrySelector(context),
                          ),
                          const Spacer(),
                          Material(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: SPrimaryButton2(
                                active: navigationAllowed &&
                                    state.isBillingAddressValid,
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
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
