import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/providers/service_providers.dart';
import '../../../../../models/currency_model.dart';
import '../../../notifier/send_by_phone_input_notifier/send_by_phone_input_notipod.dart';
import '../../../notifier/send_by_phone_permission_notifier/send_by_phone_permission_notipod.dart';
import '../../../notifier/send_by_phone_permission_notifier/send_by_phone_permission_state.dart';
import '../send_by_phone_amount.dart';
import 'components/send_helper_text.dart';
import 'components/send_info_text.dart';
import 'components/show_contact_picker.dart';
import 'components/show_dial_code_picker/show_dial_code_picker.dart';

/// BASE FLOW: Input -> Amount -> Preview
/// FLOW 1: BASE FLOW -> Confirm -> Notify if simple account
/// FLOW 2: BASE FLOW -> Confirm -> Home -> Notify if simple account ??
class SendByPhoneInput extends StatefulHookWidget {
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
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
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
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final input = useProvider(sendByPhoneInputNotipod);
    final permission = useProvider(sendByPhonePermissionNotipod);
    final permissionN = useProvider(sendByPhonePermissionNotipod.notifier);
    useListenable(input.phoneNumberController);
    useListenable(input.dialCodeController);

    return SPageFrame(
      color: colors.grey5,
      header: SPaddingH24(
        child: SMegaHeader(
          titleAlign: TextAlign.start,
          title: '${intl.send} ${widget.currency.description} ${intl.byPhone}',
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
                              labelText: intl.code,
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
                              labelText: intl.phoneNumber,
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
                name: intl.continueText,
                onTap: () {
                  navigatorPush(
                    context,
                    SendByPhoneAmount(
                      currency: widget.currency,
                    ),
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
