import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_input_store.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_permission_store.dart';
import 'package:jetwallet/features/send_by_phone/ui/send_by_phone_input/widgets/send_helper_text.dart';
import 'package:jetwallet/features/send_by_phone/ui/send_by_phone_input/widgets/send_info_text.dart';
import 'package:jetwallet/features/send_by_phone/ui/send_by_phone_input/widgets/show_contact_picker.dart';
import 'package:jetwallet/features/send_by_phone/ui/send_by_phone_input/widgets/show_dial_code_picker/show_dial_code_picker.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

/// BASE FLOW: Input -> Amount -> Preview
/// FLOW 1: BASE FLOW -> Confirm -> Notify if simple account
/// FLOW 2: BASE FLOW -> Confirm -> Home -> Notify if simple account ??
class SendByPhoneInput extends StatefulObserverWidget {
  const SendByPhoneInput({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  State<SendByPhoneInput> createState() => _SendByPhoneInputState();
}

class _SendByPhoneInputState extends State<SendByPhoneInput>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final state = SendByPhonePermission();

      // If returned from Settigns check whether user enabled permission or not
      if (state.userLocation == UserLocation.settings) {
        state.initPermissionState();
        state.updateUserLocation(UserLocation.app);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final input = SendByPhoneInputStore();

    final permission = SendByPhonePermission();

    return SPageFrame(
      color: colors.grey5,
      header: SPaddingH24(
        child: SMegaHeader(
          titleAlign: TextAlign.start,
          title: '${intl.sendByPhoneInput_send} ${widget.currency.description}'
              ' ${intl.sendByPhoneInput_byPhone}',
          onBackButtonTap: () {
            sAnalytics.sendChoosePhoneClose();
            Navigator.pop(context);
          },
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
                              labelText: intl.sendByPhoneInput_code,
                              readOnly: true,
                              hideClearButton: true,
                              controller: input.dialCodeController,
                              hasManualError: input.dialCodeController.text ==
                                  intl.sendByPhoneInput_select,
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
                              labelText: intl.sendByPhoneInput_phoneNumber,
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
              if (!input.isReadyToContinue) const SendHelperText(),
              if (input.dialCodeController.text ==
                  intl.sendByPhoneInput_select) ...[
                const SpaceH20(),
                SPaddingH24(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        width: 2,
                        color: colors.grey4,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SErrorIcon(
                              color: colors.red,
                            ),
                            const SpaceW10(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 126,
                                  child: Text(
                                    intl.sendByPhoneInput_codeLocalNumber,
                                    style: sBodyText1Style.copyWith(
                                      color: colors.black,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 126,
                                  child: Text(
                                    intl.sendByPhoneInput_codeSelectCountry,
                                    style: sBodyText1Style.copyWith(
                                      color: colors.black,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (input.dialCodeController.text.isNotEmpty &&
                  input.phoneNumberController.text.isNotEmpty &&
                  input.dialCodeController
                          .text[input.dialCodeController.text.length - 1] ==
                      input.phoneNumberController.text[0]) ...[
                const SpaceH20(),
                SPaddingH24(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        width: 2,
                        color: colors.grey4,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SErrorIcon(
                              color: colors.black,
                            ),
                            const SpaceW10(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 126,
                                  child: Text(
                                    intl.sendByPhoneInput_makeSureIsCorrect,
                                    style: sBodyText1Style.copyWith(
                                      color: colors.black,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SpaceH20(),
              if (permission.permissionStatus == PermissionStatus.denied)
                SendInfoText(
                  onTap: permission.onHelperTextTap,
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
                active: input.isReadyToContinue &&
                    !(input.dialCodeController.text ==
                        intl.sendByPhoneInput_select),
                name: intl.sendByPhoneInput_continue,
                onTap: () {
                  sAnalytics.sendContinuePhone();
                  sAnalytics.sendViews();

                  sRouter.push(
                    SendByPhoneAmountRouter(
                      currency: widget.currency,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
