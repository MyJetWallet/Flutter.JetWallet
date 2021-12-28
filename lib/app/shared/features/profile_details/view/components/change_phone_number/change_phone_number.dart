import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/shared/features/send_by_phone/notifier/send_by_phone_input_notifier/send_by_phone_input_notipod.dart';
import 'package:jetwallet/app/shared/features/send_by_phone/notifier/send_by_phone_permission_notifier/send_by_phone_permission_notipod.dart';
import 'package:jetwallet/app/shared/features/send_by_phone/notifier/send_by_phone_permission_notifier/send_by_phone_permission_state.dart';
import 'package:jetwallet/app/shared/features/send_by_phone/view/screens/send_by_phone_amount.dart';
import 'package:jetwallet/app/shared/features/send_by_phone/view/screens/send_by_phone_input/components/send_helper_text.dart';
import 'package:jetwallet/app/shared/features/send_by_phone/view/screens/send_by_phone_input/components/send_info_text.dart';
import 'package:jetwallet/app/shared/features/send_by_phone/view/screens/send_by_phone_input/components/show_contact_picker.dart';
import 'package:jetwallet/app/shared/features/send_by_phone/view/screens/send_by_phone_input/components/show_dial_code_picker.dart';
import 'package:jetwallet/shared/helpers/navigator_push.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../../shared/features/phone_verification/phone_verification_confirm/view/phone_verification_confirm.dart';
import '../../../../../../../shared/features/phone_verification/phone_verification_enter/components/phone_number_bottom_sheet.dart';
import '../../../../../../../shared/features/phone_verification/phone_verification_enter/components/phone_number_search.dart';
import '../../../../../../../shared/features/phone_verification/phone_verification_enter/components/phone_verification_block.dart';
import '../../../../../../../shared/notifiers/phone_number_notifier/phone_number_notipod.dart';
import '../../../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../notifier/change_phone_notifier/change_phone_notipod.dart';


class ChangePhoneNumber extends StatefulHookWidget {
  const ChangePhoneNumber({
    Key? key,
  }) : super(key: key);

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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final state = context.read(sendByPhonePermissionNotipod);
      final notifier = context.read(sendByPhonePermissionNotipod.notifier);

      // If returned from Settigns check whether user enabled permission or not
      if (state.userLocation == UserLocation.settings) {
        notifier.initPermissionState();
        notifier.updateUserLocation(UserLocation.app);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final input = useProvider(sendByPhoneInputNotipod);
    final permission = useProvider(sendByPhonePermissionNotipod);
    final permissionN = useProvider(sendByPhonePermissionNotipod.notifier);
    final userInfoN = useProvider(userInfoNotipod.notifier);
    useListenable(input.phoneNumberController);
    useListenable(input.dialCodeController);

    return SPageFrame(
      color: colors.grey5,
      header: SPaddingH24(
        child: SMegaHeader(
          titleAlign: TextAlign.start,
          title: 'by phone',
        ),
      ),
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Material(
                color: colors.white,
                child: SPaddingH24(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialCodePicker(context);
                        },
                        child: SizedBox(
                          width: 100,
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
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showContactPicker(context);
                          },
                          child: AbsorbPointer(
                            child: SStandardField(
                              labelText: 'Phone number',
                              readOnly: true,
                              hideClearButton: true,
                              controller: input.phoneNumberController,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SendHelperText(),
              const SpaceH20(),
              if (permission.permissionStatus == PermissionStatus.denied)
                SendInfoText(
                  onTap: permissionN.onHelperTextTap,
                )
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

                  print('input.phoneNumberController.text ${input.dialCodeController.text} ${ input.phoneNumberController.text}');

                  PhoneVerificationConfirm.push(
                    context: context,
                    onVerified: () {

                      print('input.phoneNumberController.text ${input.phoneNumberController.text}');

                      userInfoN.updatePhone('${input.dialCodeController.text}${input.phoneNumberController.text}');
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


// class ChangePhoneNumber extends HookWidget {
//   const ChangePhoneNumber({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final phoneNumber = useProvider(phoneNumberNotipod);
//     final phoneNumberN = useProvider(phoneNumberNotipod.notifier);
//     final changePhoneN = useProvider(changePhoneNotipod.notifier);
//     final changePhone = useProvider(changePhoneNotipod);
//     final userInfoN = useProvider(userInfoNotipod.notifier);
//     final colors = useProvider(sColorPod);
//     final input = useProvider(sendByPhoneInputNotipod);
//     final permission = useProvider(sendByPhonePermissionNotipod);
//     final permissionN = useProvider(sendByPhonePermissionNotipod.notifier);
//     useListenable(input.phoneNumberController);
//     useListenable(input.dialCodeController);
//
//     return SPageFrame(
//       color: colors.grey5,
//       header: const SPaddingH24(
//         child: SMegaHeader(
//           titleAlign: TextAlign.start,
//           title: 'Send by phone',
//         ),
//       ),
//       child: Stack(
//         children: [
//
//           Positioned(
//             top: 160,
//             child: PhoneVerificationBlock(
//               onErase: () {
//                 phoneNumberN.updatePhoneNumber('');
//               },
//               onChanged: (String phone) {
//                 changePhoneN.updatePhone(phone);
//                 phoneNumberN.updatePhoneNumber(phone);
//               },
//               showBottomSheet: () {
//                 phoneNumberN.sortClearCountriesCode();
//
//                 final sortWithActiveCountryCode =
//                 phoneNumberN.sortActiveCountryCode();
//
//                 sShowBasicModalBottomSheet(
//                   context: context,
//                   removePinnedPadding: true,
//                   horizontalPinnedPadding: 0,
//
//                   /// TODO isn't optimized for small devices
//                   // minHeight: 635.0,
//                   scrollable: true,
//                   pinned: PhoneNumberSearch(
//                     onErase: () {
//                       phoneNumberN.sortClearCountriesCode();
//                     },
//                     onChange: (String countryCode) {
//                       changePhoneN.updateIsoCode(countryCode);
//                       if (countryCode.isNotEmpty && countryCode.length > 1) {
//                         phoneNumberN.sortCountriesCode(countryCode);
//                       } else {
//                         phoneNumberN.sortClearCountriesCode();
//                       }
//                     },
//                   ),
//                   children: [
//                     PhoneNumberBottomSheet(
//                       countriesCodeList: sortWithActiveCountryCode,
//                       onTap: (SPhoneNumber country) {
//                         changePhoneN.updateIsoCode(country.countryCode);
//                         phoneNumberN.updateCountryCode(country.countryCode);
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ],
//                 );
//               },
//               countryCode: phoneNumber.countryCode ?? '',
//             ),
//           ),
//           ListView(
//             padding: EdgeInsets.zero,
//             children: [
//               Material(
//                 color: colors.white,
//                 child: SPaddingH24(
//                   child: Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           showDialCodePicker(context);
//                         },
//                         child: SizedBox(
//                           width: 100,
//                           child: AbsorbPointer(
//                             child: SStandardField(
//                               labelText: 'Code',
//                               readOnly: true,
//                               hideClearButton: true,
//                               controller: input.dialCodeController,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Column(
//                           children: [
//                             Container(
//                               height: 88.0,
//                               width: 250.0,
//                               padding: const EdgeInsets.only(left: 25.0),
//                               child: SStandardField(
//                                 onErase: () {
//                                   phoneNumberN.updatePhoneNumber('');
//                                 },
//                                 labelText: 'Phone number',
//                                 autofocus: true,
//                                 autofillHints: const [AutofillHints.telephoneNumber],
//                                 keyboardType: TextInputType.phone,
//                                 textInputAction: TextInputAction.next,
//                                 alignLabelWithHint: true,
//                                 controller: input.phoneNumberController,
//                                 // onChanged: (String phone) {
//                                 //   changePhoneN.updatePhone(phone);
//                                 //   phoneNumberN.updatePhoneNumber(phone);
//                                 // },
//                               ),
//                             ),
//                           ],
//                         ),
//
//
//                         // GestureDetector(
//                         //   onTap: () {
//                         //     showContactPicker(context);
//                         //   },
//                         //   child: AbsorbPointer(
//                         //     child: SStandardField(
//                         //       labelText: 'Phone number',
//                         //       readOnly: true,
//                         //       hideClearButton: true,
//                         //       controller: input.phoneNumberController,
//                         //     ),
//                         //   ),
//                         // ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SendHelperText(),
//               const SpaceH20(),
//             ],
//           ),
//           Positioned(
//             left: 24.0,
//             right: 24.0,
//             bottom: 124.0,
//             child: Material(
//               color: Colors.transparent,
//               child: SPrimaryButton2(
//                 active: input.isReadyToContinue,
//                 name: 'Continue',
//                 onTap: () {
//                   // navigatorPush(
//                   //   context,
//                   //   SendByPhoneAmount(
//                   //     currency: widget.currency,
//                   //   ),
//                   // );
//                 },
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//
//
//
//
//
//
//     return SPageFrame(
//       header: SPaddingH24(
//         child: SSmallHeader(
//           title: 'Enter phone number',
//           onBackButtonTap: () => Navigator.pop(context),
//         ),
//       ),
//       child: Column(
//         children: [
//           PhoneVerificationBlock(
//             onErase: () {
//               phoneNumberN.updatePhoneNumber('');
//             },
//             onChanged: (String phone) {
//               changePhoneN.updatePhone(phone);
//               phoneNumberN.updatePhoneNumber(phone);
//             },
//             showBottomSheet: () {
//               phoneNumberN.sortClearCountriesCode();
//
//               final sortWithActiveCountryCode =
//                   phoneNumberN.sortActiveCountryCode();
//
//               sShowBasicModalBottomSheet(
//                 context: context,
//                 removePinnedPadding: true,
//                 horizontalPinnedPadding: 0,
//
//                 /// TODO isn't optimized for small devices
//                 // minHeight: 635.0,
//                 scrollable: true,
//                 pinned: PhoneNumberSearch(
//                   onErase: () {
//                     phoneNumberN.sortClearCountriesCode();
//                   },
//                   onChange: (String countryCode) {
//                     changePhoneN.updateIsoCode(countryCode);
//                     if (countryCode.isNotEmpty && countryCode.length > 1) {
//                       phoneNumberN.sortCountriesCode(countryCode);
//                     } else {
//                       phoneNumberN.sortClearCountriesCode();
//                     }
//                   },
//                 ),
//                 children: [
//                   PhoneNumberBottomSheet(
//                     countriesCodeList: sortWithActiveCountryCode,
//                     onTap: (SPhoneNumber country) {
//                       changePhoneN.updateIsoCode(country.countryCode);
//                       phoneNumberN.updateCountryCode(country.countryCode);
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               );
//             },
//             countryCode: phoneNumber.countryCode ?? '',
//           ),
//           SPaddingH24(
//             child: Baseline(
//               baselineType: TextBaseline.alphabetic,
//               baseline: 24,
//               child: Text(
//                 'This allow you to send and receive crypto by phone',
//                 style: sCaptionTextStyle.copyWith(
//                   color: colors.grey1,
//                 ),
//               ),
//             ),
//           ),
//           const Spacer(),
//           SPaddingH24(
//             child: SPrimaryButton2(
//               active: phoneNumberN.setActiveCode(),
//               name: 'Continue',
//               onTap: () {
//                 PhoneVerificationConfirm.push(
//                   context: context,
//                   onVerified: () {
//                     userInfoN.updatePhone(changePhone.phoneNumber);
//                     SuccessScreen.push(
//                       context: context,
//                       secondaryText: 'New phone number set',
//                     );
//                   },
//                   isChangeTextAlert: false,
//                 );
//               },
//             ),
//           ),
//           const SpaceH24(),
//         ],
//       ),
//     );
//   }
// }
