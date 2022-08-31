import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/constants.dart';
import '../../../shared/helpers/navigator_push.dart';
import '../../../shared/providers/device_info_pod.dart';
import '../../../shared/providers/service_providers.dart';
import 'notifier/biometric_notipod.dart';
import 'notifier/biometric_status_notifier.dart';

class Biometric extends HookWidget {
  const Biometric({
    Key? key,
    this.isAccSettings = false,
  }) : super(key: key);

  final bool isAccSettings;

  static const routeName = '/bio';

  static void push({
    required BuildContext context,
    bool isAccSettings = false,
  }) {
    navigatorPush(
      context,
      Biometric(isAccSettings: isAccSettings),
    );
  }

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final biometricStatus = useProvider(biometricStatusFpod);
    final biometric = useProvider(biometricNotipod.notifier);
    final deviceInfo = useProvider(deviceInfoPod);
    late String headerText;
    late String buttonText;
    late String image;

    final iosLatest = deviceInfo.marketingName.contains('iPhone 11') ||
        deviceInfo.marketingName.contains('iPhone 12') ||
        deviceInfo.marketingName.contains('iPhone 13') ||
        deviceInfo.marketingName.contains('iPhone 14') ||
        deviceInfo.marketingName.contains('iPhone X') ||
        deviceInfo.marketingName.contains('iPhone x');
    if (biometricStatus.data?.value == BiometricStatus.face || iosLatest) {
      headerText = intl.bio_screen_face_id_title;
      buttonText = intl.bio_screen_face_id_button_text;
      image = bioFaceId;
    } else {
      headerText = intl.bio_screen_touch_id_title;
      buttonText = intl.bio_screen_touch_id_button_text;
      image = bioTouchId;
    }
    return SPageFrame(
      header: SAuthHeader(
        customIconButton: const SpaceH24(),
        title: headerText,
      ),
      child: SPaddingH24(
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              image,
              height: 225,
              width: 225,
            ),
            const Spacer(),
            Text(
              intl.bio_screen_text,
              maxLines: 2,
              style: sBodyText1Style.copyWith(
                color: colors.grey1,
              ),
            ),
            const SpaceH40(),
            SPrimaryButton4(
              active: true,
              name: buttonText,
              onTap: () {
                biometric.useBio(
                  useBio: true,
                  isAccSettings: isAccSettings,
                  context: context,
                );
              },
            ),
            const SpaceH10(),
            STextButton1(
              active: true,
              name: intl.bio_screen_button_late_text,
              onTap: () async {
                if (isAccSettings) {
                  Navigator.pop(context);
                } else {
                  await makeAuthWithBiometrics(
                    intl.pinScreen_weNeedYouToConfirmYourIdentity,
                  );
                  biometric.useBio(
                    useBio: false,
                    context: context,
                  );
                }
              },
            ),
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
