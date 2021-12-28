import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../../shared/features/phone_verification/phone_verification_confirm/view/phone_verification_confirm.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/notifiers/phone_number_notifier/phone_number_notipod.dart';
import '../../../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../send_by_phone/notifier/send_by_phone_input_notifier/send_by_phone_input_notipod.dart';
import '../../../../send_by_phone/view/screens/send_by_phone_input/components/show_dial_code_picker.dart';

class ChangePhoneNumber extends StatefulHookWidget {
  const ChangePhoneNumber({
    Key? key,
    required this.onVerified,
  }) : super(key: key);

  final Function() onVerified;

  static void push({
    required BuildContext context,
    required Function() onVerified,
  }) {
    navigatorPush(
      context,
      ChangePhoneNumber(
        onVerified: onVerified,
      ),
    );
  }

  @override
  State<ChangePhoneNumber> createState() => _ChangePhoneNumberState();
}

class _ChangePhoneNumberState extends State<ChangePhoneNumber>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final input = useProvider(sendByPhoneInputNotipod);
    final userInfoN = useProvider(userInfoNotipod.notifier);
    final phoneNumberN = useProvider(phoneNumberNotipod.notifier);
    useListenable(input.phoneNumberController);
    useListenable(input.dialCodeController);

    return SPageFrame(
      color: colors.grey5,
      header: const SPaddingH24(
        child: SSmallHeader(
          title: 'Enter phone number',
        ),
      ),
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Material(
                color: colors.white,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        left: 24,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            color: colors.grey4,
                          ),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          print('GestureDetectorGestureDetector');
                          // ScaffoldMessenger.of(context).showMaterialBanner()

                          showDialCodePicker(context);
                        },
                        child: SizedBox(
                          width: 76,
                          child: AbsorbPointer(
                            child: SStandardField(
                              labelText: 'Code',
                              readOnly: true,
                              hideClearButton: true,
                              controller: input.dialCodeController,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SPaddingH24(
                        child: SStandardField(
                          labelText: 'Phone number',
                          autofocus: true,
                          autofillHints: const [AutofillHints.telephoneNumber],
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          alignLabelWithHint: true,
                          controller: input.phoneNumberController,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SPaddingH24(
                child: Baseline(
                  baselineType: TextBaseline.alphabetic,
                  baseline: 24,
                  child: Text(
                    'This allow you to send and receive crypto by phone',
                    style: sCaptionTextStyle.copyWith(
                      color: colors.grey1,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 24.0,
            right: 24.0,
            bottom: 24.0,
            child: Material(
              color: Colors.transparent,
              child: SPrimaryButton2(
                active: input.isReadyToContinue,
                name: 'Continue',
                onTap: () {
                  phoneNumberN.updateCountryCode(
                    input.dialCodeController.text,
                  );
                  phoneNumberN.updatePhoneNumber(
                    input.phoneNumberController.text,
                  );
                  PhoneVerificationConfirm.push(
                    context: context,
                    onVerified: () {
                      userInfoN.updatePhone(
                        '${input.dialCodeController.text}'
                        '${input.phoneNumberController.text}',
                      );
                      SuccessScreen.push(
                        context: context,
                        secondaryText: 'New phone number set',
                      );
                    },
                    isChangeTextAlert: false,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
