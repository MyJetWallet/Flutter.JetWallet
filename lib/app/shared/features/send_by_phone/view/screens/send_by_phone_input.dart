import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../models/currency_model.dart';
import '../../notifier/send_by_phone_input_notifier/send_by_phone_input_notipod.dart';
import '../../notifier/send_by_phone_input_notifier/send_by_phone_input_state.dart';

/// BASE FLOW: Input -> Amount -> Preview
/// FLOW 1: BASE FLOW -> Confirm -> Notify if simple account
/// FLOW 2: BASE FLOW -> Confirm -> Home -> Notify if simple account ??
class SendByPhoneInput extends StatefulHookWidget {
  const SendByPhoneInput({
    Key? key,
    this.currency,
  }) : super(key: key);

  final CurrencyModel? currency;

  @override
  State<SendByPhoneInput> createState() => _SendByPhoneInputState();
}

class _SendByPhoneInputState extends State<SendByPhoneInput>
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
      final state = context.read(sendByPhoneInputNotipod);
      final notifier = context.read(sendByPhoneInputNotipod.notifier);

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
    final codeController = useTextEditingController(text: '+380');
    final state = useProvider(sendByPhoneInputNotipod);
    final notifier = useProvider(sendByPhoneInputNotipod.notifier);

    return SPageFrame(
      color: colors.grey5,
      header: const SPaddingH24(
        child: SMegaHeader(
          titleAlign: TextAlign.start,
          // title: 'Send ${currency.description} by phone',
          title: 'Send Bitcoin by phone',
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
                        onTap: () {},
                        child: SizedBox(
                          width: 100,
                          child: AbsorbPointer(
                            child: SStandardField(
                              labelText: 'Code',
                              readOnly: true,
                              controller: codeController,
                              hideClearButton: true,
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: SStandardField(
                          labelText: 'Phone number',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SPaddingH24(
                child: Baseline(
                  baseline: 32.0,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    'Start typing phone number or name from your phonebook',
                    maxLines: 2,
                    style: sCaptionTextStyle.copyWith(
                      color: colors.grey1,
                    ),
                  ),
                ),
              ),
              const SpaceH20(),
              if (state.permissionStatus == PermissionStatus.denied)
                GestureDetector(
                  onTap: notifier.onHelperTextTap,
                  child: SPaddingH24(
                    child: Row(
                      children: [
                        SInfoIcon(
                          color: colors.blue,
                        ),
                        const SpaceW10(),
                        Baseline(
                          baseline: 16.0,
                          baselineType: TextBaseline.alphabetic,
                          child: Text(
                            'I want to use my phonebook',
                            style: sCaptionTextStyle.copyWith(
                              color: colors.blue,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
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
                active: true,
                name: 'Continue',
                onTap: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}
