import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/circle/model/circle_card.dart';

import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/providers/service_providers.dart';
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

  final Function(CircleCard) onCardAdded;

  static void push({
    required BuildContext context,
    required Function(CircleCard) onCardAdded,
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
    final intl = useProvider(intlPod);
    final state = useProvider(addCircleCardNotipod);
    final notifier = useProvider(addCircleCardNotipod.notifier);
    final enableButton = useState(true);

    final navigationAllowed =
        (state.loader?.value ?? true) || enableButton.value;

    return WillPopScope(
      onWillPop: () => Future.value(navigationAllowed),
      child: SPageFrame(
        loaderText: intl.circleBillingAddress_pleaseWait,
        loading: state.loader,
        header: SPaddingH24(
          child: SBigHeader(
            onBackButtonTap: () {
              if (navigationAllowed) {
                Navigator.pop(context);
              }
            },
            title: intl.circleBillingAddress_billingAddress,
          ),
        ),
        child: Column(
          children: [
            const CircleProgressIndicator(),
            ScrollingFrame(
              children: [
                SFieldDividerFrame(
                  child: SStandardField(
                    initialValue: state.streetAddress1,
                    labelText: intl.circleBillingAddress_streetAddress,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: notifier.updateAddress1,
                    hideSpace: true,
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    initialValue: state.streetAddress2,
                    labelText: '${intl.circleBillingAddress_streetAddress} 2'
                        ' (${intl.circleBillingAddress_optional})',
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: notifier.updateAddress2,
                    hideSpace: true,
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    initialValue: state.city,
                    labelText: intl.circleBillingAddress_city,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: notifier.updateCity,
                    hideSpace: true,
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    initialValue: state.district,
                    labelText: intl.circleBillingAddress_district,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: notifier.updateDistrict,
                    hideSpace: true,
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    initialValue: state.postalCode,
                    labelText: intl.circleBillingAddress_postalCode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: notifier.updatePostalCode,
                    hideSpace: true,
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
                    name: intl.circleBillingAddress_continue,
                    onTap: () async {
                      sAnalytics.circleContinueAddress();
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
