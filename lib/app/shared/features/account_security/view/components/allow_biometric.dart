import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/constants.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../auth/screens/biometric/notifier/biometric_notipod.dart';
import '../../../../../../shared/providers/device_info_pod.dart';
import '../../../kyc/notifier/camera_permission/camera_permission_state.dart';

class AllowBiometric extends StatefulHookWidget {
  const AllowBiometric({
    Key? key,
  }) : super(key: key);

  static void push({
    required BuildContext context,
  }) {
    navigatorPush(
      context,
      const AllowBiometric(),
    );
  }

  @override
  State<AllowBiometric> createState() => _AllowBiometricState();
}

class _AllowBiometricState extends State<AllowBiometric> with
    WidgetsBindingObserver {
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
      final state = context.read(biometricNotipod);
      final notifier = context.read(biometricNotipod.notifier);

      if (state.userLocation == UserLocation.settings) {
        notifier.handleBiometricPermissionAfterSettingsChange(
          context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final notifier = useProvider(biometricNotipod.notifier);

    late String headerText;
    late String bottomText;
    late String image;

    final deviceInfo = context.read(deviceInfoPod);
    final iosLatest = deviceInfo.marketingName.contains('iPhone 11') ||
        deviceInfo.marketingName.contains('iPhone 12') ||
        deviceInfo.marketingName.contains('iPhone 13') ||
        deviceInfo.marketingName.contains('iPhone 14') ||
        deviceInfo.marketingName.contains('iPhone X') ||
        deviceInfo.marketingName.contains('iPhone x');

    if (iosLatest) {
      headerText = intl.allowBiometric_headerTitle1;
      bottomText = intl.allowBiometric_headerTitle2;
      image = bioFaceId;
    } else {
      headerText = intl.allowBiometric_headerTitle1;
      bottomText = intl.allowBiometric_headerTitle2;
      image = bioTouchId;
    }

    final deviceSize = useProvider(deviceSizePod);
    final size = MediaQuery.of(context).size;

    return SPageFrameWithPadding(
      header: deviceSize.when(
        small: () {
          return SSmallHeader(
            title: headerText,
          );
        },
        medium: () {
          return SMegaHeader(
            titleAlign: TextAlign.left,
            title: headerText,
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 24,
          top: 40,
          left: 24,
          right: 24,
        ),
        child: SPrimaryButton2(
          active: true,
          onTap: () async {
            await notifier.handleBiometricPermission();
          },
          name: intl.allowCamera_goToSettings,
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Image.asset(
                  image,
                  height: size.width * 0.6,
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Baseline(
                        baseline: 48,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          bottomText,
                          maxLines: 3,
                          style: sBodyText1Style.copyWith(
                            color: colors.grey1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
