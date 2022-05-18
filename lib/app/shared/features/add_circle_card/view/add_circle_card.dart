import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../helper/masked_text_input_formatter.dart';
import '../notifier/add_circle_card_notipod.dart';
import 'circle_billing_address/circle_billing_address.dart';
import 'components/circle_progress_indicator.dart';
import 'components/continue_button_frame.dart';
import 'components/scrolling_frame.dart';

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
    final intl = context.read(intlPod);
    final colors = useProvider(sColorPod);
    final state = useProvider(addCircleCardNotipod);
    final notifier = useProvider(addCircleCardNotipod.notifier);

    return SPageFrame(
      loaderText: intl.pleaseWait,
      loading: state.loader,
      header: SPaddingH24(
        child: SBigHeader(
          title: intl.addCircleCard_bigHeaderTitle,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                child: CircleProgressIndicator(),
              ),
              Spacer(),
            ],
          ),
          ScrollingFrame(
            children: [
              SFieldDividerFrame(
                child: SStandardField(
                  labelText: intl.cardNumber,
                  keyboardType: TextInputType.number,
                  errorNotifier: state.cardNumberError,
                  disableErrorOnChanged: false,
                  // In formatting \u2005 is used instead of \u0020
                  // to avoid \u0020 input from the user
                  inputFormatters: [
                    MaskedTextInputFormatter(
                      mask: 'xxxx\u{2005}xxxx\u{2005}xxxx\u{2005}xxxx',
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
                        labelText: intl.expiryDate,
                        keyboardType: TextInputType.number,
                        errorNotifier: state.expiryDateError,
                        enableInteractiveSelection: false,
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
                        enableInteractiveSelection: false,
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
                    labelText: intl.cardholderName,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: notifier.updateCardholderName,
                  ),
                ),
              ),
              const Spacer(),
              ContinueButtonFrame(
                child: SPrimaryButton2(
                  active: state.isCardDetailsValid,
                  name: intl.continueText,
                  onTap: () async {
                    CircleBillingAddress.push(
                      context: context,
                      onCardAdded: onCardAdded,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
