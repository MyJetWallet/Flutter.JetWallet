import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../helper/masked_text_input_formatter.dart';
import '../notifier/add_circle_card_notipod.dart';
import 'circle_billing_address/circle_billing_address.dart';

class AddCircleCard extends HookWidget {
  const AddCircleCard({
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
      AddCircleCard(
        onCardAdded: onCardAdded,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final state = useProvider(addCircleCardNotipod);
    final notifier = useProvider(addCircleCardNotipod.notifier);

    return SPageFrame(
      loading: state.loader,
      header: const SPaddingH24(
        child: SBigHeader(
          title: 'Enter card details',
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 4.0,
                  color: colors.blue,
                ),
              ),
              const Spacer(),
            ],
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
                            labelText: 'Card number',
                            keyboardType: TextInputType.number,
                            errorNotifier: state.cardNumberError,
                            disableErrorOnChanged: false,
                            // In formatting \u2005 is used instead of \u0020
                            // to avoid \u0020 input from the user
                            inputFormatters: [
                              MaskedTextInputFormatter(
                                mask:
                                    'xxxx\u{2005}xxxx\u{2005}xxxx\u{2005}xxxx',
                                separator: '\u{2005}',
                              ),
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9\u2005]'),
                              ),
                            ],
                            onChanged: notifier.updateCardNumber,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SFieldDividerFrame(
                                child: SStandardField(
                                  labelText: 'Expiry Date',
                                  keyboardType: TextInputType.number,
                                  errorNotifier: state.expiryDateError,
                                  enableinteractiveSelection: false,
                                  disableErrorOnChanged: false,
                                  inputFormatters: [
                                    MaskedTextInputFormatter(
                                      mask: 'xx/xx',
                                      separator: '/',
                                    ),
                                  ],
                                  onChanged: notifier.updateExpiryDate,
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
                                  keyboardType: TextInputType.number,
                                  errorNotifier: state.cvvError,
                                  enableinteractiveSelection: false,
                                  disableErrorOnChanged: false,
                                  inputFormatters: [
                                    MaskedTextInputFormatter(
                                      mask: 'xxx',
                                      separator: '',
                                    ),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: notifier.updateCvv,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Material(
                          color: colors.white,
                          child: SPaddingH24(
                            child: SStandardField(
                              labelText: 'Cardholder name',
                              onChanged: notifier.updateCardholderName,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Material(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: SPrimaryButton2(
                              active: state.isCardDetailsValid,
                              name: 'Continue',
                              onTap: () async {
                                CircleBillingAddress.push(
                                  context: context,
                                  onCardAdded: onCardAdded,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
