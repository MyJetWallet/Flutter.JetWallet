import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../notifier/enter_card_details_notipod.dart';
import 'components/country_selector_button.dart';
import 'components/show_country_selector.dart';

class EnterCardDetails extends HookWidget {
  const EnterCardDetails({
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
      EnterCardDetails(
        onCardAdded: onCardAdded,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final state = useProvider(enterCardDetailsNotipod);
    final notifier = useProvider(enterCardDetailsNotipod.notifier);
    final enableButton = useState(true);

    final isButtonActive = (state.loader?.value ?? true) || enableButton.value;

    return WillPopScope(
      onWillPop: () => Future.value(isButtonActive),
      child: SPageFrame(
        loading: state.loader,
        header: SPaddingH24(
          child: SBigHeader(
            customIconButton: SIconButton(
              onTap: () {
                if (isButtonActive) {
                  Navigator.pop(context);
                }
              },
              defaultIcon: const SCloseIcon(),
              pressedIcon: const SClosePressedIcon(),
            ),
            title: 'Enter card details',
          ),
        ),
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                SFieldDividerFrame(
                  child: SStandardField(
                    labelText: 'Card number',
                    onChanged: (string) {
                      notifier.updateCardNumber(string);
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SFieldDividerFrame(
                        child: SStandardField(
                          labelText: 'Expiry Date',
                          onChanged: (string) {
                            notifier.updateExpiryDate(string);
                          },
                        ),
                      ),
                    ),
                    const SDivider(
                      width: 1.0,
                      height: 88.0,
                    ),
                    Expanded(
                      child: SFieldDividerFrame(
                        child: SStandardField(
                          labelText: 'CVV',
                          onChanged: (string) {
                            notifier.updateCvv(string);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    labelText: 'Card name',
                    onChanged: (string) {
                      notifier.updateCardName(string);
                    },
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    labelText: 'Cardholder name',
                    onChanged: (string) {
                      notifier.updateCardholderName(string);
                    },
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    labelText: 'Street Address',
                    onChanged: (string) {
                      notifier.updateAddress1(string);
                    },
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    labelText: 'Street Address 2 (optional)',
                    onChanged: (string) {
                      notifier.updateAddress2(string);
                    },
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    labelText: 'City',
                    onChanged: (string) {
                      notifier.updateCity(string);
                    },
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    labelText: 'District',
                    onChanged: (string) {
                      notifier.updateDistrict(string);
                    },
                  ),
                ),
                SFieldDividerFrame(
                  child: SStandardField(
                    labelText: 'Postal code',
                    onChanged: (string) {
                      notifier.updatePostalCode(string);
                    },
                  ),
                ),
                CountrySelectorButton(
                  country: state.selectedCountry!,
                  onTap: () => showCountrySelector(context),
                ),
                const SpaceH136()
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Material(
                color: colors.grey5,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SPrimaryButton2(
                    active: isButtonActive,
                    name: 'Continue',
                    onTap: () async {
                      enableButton.value = false;
                      await notifier.addCard();
                      enableButton.value = true;
                      onCardAdded();
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
