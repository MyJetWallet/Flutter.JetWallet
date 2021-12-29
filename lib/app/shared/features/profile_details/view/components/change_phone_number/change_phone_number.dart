import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../../shared/features/phone_verification/phone_verification_confirm/view/phone_verification_confirm.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/notifiers/phone_number_notifier/phone_number_notipod.dart';
import '../../../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../bottom_sheet/change_phone_dial_code_picker.dart';

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
    final phoneNumberInput = useProvider(phoneNumberNotipod);
    final phoneNumberN = useProvider(phoneNumberNotipod.notifier);
    final userInfoN = useProvider(userInfoNotipod.notifier);

    useListenable(phoneNumberInput.phoneNumberController);
    useListenable(phoneNumberInput.dialCodeController);

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
                          changePhoneDialCodePicker(context);
                        },
                        child: SizedBox(
                          width: 76,
                          child: AbsorbPointer(
                            child: SStandardField(
                              labelText: 'Code',
                              readOnly: true,
                              hideClearButton: true,
                              controller: phoneNumberInput.dialCodeController,
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
                          controller: phoneNumberInput.phoneNumberController,
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
                active: phoneNumberInput.isReadyToContinue,
                name: 'Continue',
                onTap: () {
                  phoneNumberN.updateCountryCode(
                    phoneNumberInput.dialCodeController.text,
                  );
                  phoneNumberN.updatePhoneNumber(
                    phoneNumberInput.phoneNumberController.text,
                  );
                  PhoneVerificationConfirm.push(
                    context: context,
                    onVerified: () {
                      userInfoN.updatePhone(
                        '${phoneNumberInput.dialCodeController.text}'
                        '${phoneNumberInput.phoneNumberController.text}',
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
