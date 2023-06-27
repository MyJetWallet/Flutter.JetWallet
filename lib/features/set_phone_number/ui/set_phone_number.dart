import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/phone_verification/ui/phone_verification.dart';
import 'package:jetwallet/features/set_phone_number/store/set_phone_number_store.dart';
import 'package:jetwallet/features/set_phone_number/ui/widgets/show_country_phone_number_picker.dart';
import 'package:jetwallet/widgets/show_verification_modal.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/primary_button/public/simple_primary_button_4.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../pin_screen/model/pin_flow_union.dart';

@RoutePage(name: 'SetPhoneNumberRouter')
class SetPhoneNumber extends StatelessWidget {
  const SetPhoneNumber({
    super.key,
    this.then,
    this.isChangePhone = false,
    this.fromRegister = false,
    required this.successText,
  });

  final Function()? then;
  final String successText;
  final bool isChangePhone;
  final bool fromRegister;

  @override
  Widget build(BuildContext context) {
    return Provider<SetPhoneNumberStore>(
      create: (context) => SetPhoneNumberStore()..setFromRegister(fromRegister),
      builder: (context, child) => SetPhoneNumberBody(
        then: then,
        isChangePhone: isChangePhone,
        fromRegister: fromRegister,
        successText: successText,
      ),
    );
  }
}

/// Called in 2 cases:
/// 1. when we want to change number
/// 2. when we are enabling 2FA but we haven't added phone number yet
class SetPhoneNumberBody extends StatelessObserverWidget {
  const SetPhoneNumberBody({
    super.key,
    this.then,
    this.isChangePhone = false,
    this.fromRegister = false,
    required this.successText,
  }) : super();

  final Function()? then;
  final String successText;
  final bool isChangePhone;
  final bool fromRegister;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final store = Provider.of<SetPhoneNumberStore>(context, listen: false);

    return SPageFrame(
      key: UniqueKey(),
      loaderText: intl.setPhoneNumber_pleaseWait,
      loading: store.loader,
      color: colors.grey5,
      header: SPaddingH24(
        child: SBigHeader(
          title: intl.setPhoneNumber_phoneNumber,
          isSmallSize: true,
          customIconButton: fromRegister
              ? SIconButton(
                  onTap: () {
                    showModalVerification(context);
                  },
                  defaultIcon: const SCloseIcon(),
                  pressedIcon: const SClosePressedIcon(),
                )
              : null,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      showCountryPhoneNumberPicker(context);
                    },
                    child: SizedBox(
                      width: 76,
                      child: AbsorbPointer(
                        child: SStandardField(
                          labelText: intl.setPhoneNumber_code,
                          readOnly: true,
                          hideClearButton: true,
                          focusNode: store.dialFocusNode,
                          controller: store.dialCodeController,
                        ),
                      ),
                    ),
                  ),
                ),
                Observer(
                  builder: (context) {
                    return Expanded(
                      child: SPaddingH24(
                        child: GestureDetector(
                          onLongPress: () => store.pasteCode(),
                          onDoubleTap: () => store.pasteCode(),
                          child: SStandardField(
                            autofocus: true,
                            labelText: intl.setPhoneNumber_phoneNumber,
                            focusNode: store.focusNode,
                            autofillHints: const [
                              AutofillHints.telephoneNumber,
                            ],
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            onChanged: (String phone) {
                              store.updatePhoneNumber(phone);
                            },
                            controller: store.phoneNumberController,
                            suffixIcons: store.phoneInput.isNotEmpty
                                ? [
                                    SIconButton(
                                      onTap: () => store.clearPhone(),
                                      defaultIcon: const SEraseIcon(),
                                      pressedIcon: const SErasePressedIcon(),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Spacer(),
          Observer(
            builder: (context) {
              return SPaddingH24(
                child: SPrimaryButton4(
                  active: store.isButtonActive,
                  name: intl.setPhoneNumber_continue,
                  onTap: () {
                    //FocusScope.of(context).unfocus();
                    if (sUserInfo.phone == store.phoneNumber()) {
                      sRouter.pop();

                      return;
                    }

                    if (store.canCLick) {
                      store.toggleClick(false);

                      Timer(
                        const Duration(
                          seconds: 2,
                        ),
                        () => store.toggleClick(true),
                      );
                    } else {
                      return;
                    }

                    void finalSend({required String newPin}) {
                      store.updatePin(newPin);
                      store.sendCode(
                        then: () {
                          sRouter.push(
                            PhoneVerificationRouter(
                              args: PhoneVerificationArgs(
                                phoneNumber: store.phoneNumber(),
                                activeDialCode: store.activeDialCode,
                                sendCodeOnInitState: false,
                                onVerified: () {
                                  final userInfoN = sUserInfo;

                                  userInfoN.updatePhoneVerified(
                                    phoneVerifiedValue: true,
                                  );
                                  userInfoN.updateTwoFaStatus(enabled: true);
                                  userInfoN.updatePhone(store.phoneNumber());

                                  store.phoneNumberController.text = '';

                                  then!();
                                },
                              ),
                            ),
                          );
                        },
                      );
                    }

                    if (isChangePhone) {
                      sRouter.replace(
                        PinScreenRoute(
                          union: const Change(),
                          isChangePhone: true,
                          onChangePhone: (String newPin) {
                            finalSend(newPin: newPin);
                          },
                        ),
                      );
                    } else {
                      finalSend(newPin: '');
                    }
                  },
                ),
              );
            },
          ),
          const SpaceH42(),
        ],
      ),
    );
  }
}
