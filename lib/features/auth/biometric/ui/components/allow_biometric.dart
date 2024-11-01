import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/auth/biometric/store/biometric_store.dart';
import 'package:jetwallet/features/kyc/allow_camera/store/allow_camera_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'AllowBiometricRoute')
class AllowBiometric extends StatelessWidget {
  const AllowBiometric({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<BiometricStore>(
      create: (context) => BiometricStore(),
      builder: (context, child) => const _AllowBiometricScreenBody(),
    );
  }
}

class _AllowBiometricScreenBody extends StatefulObserverWidget {
  const _AllowBiometricScreenBody();

  @override
  State<_AllowBiometricScreenBody> createState() => _AllowCameraScreenBodyState();
}

class _AllowCameraScreenBodyState extends State<_AllowBiometricScreenBody> with WidgetsBindingObserver {
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
      final state = BiometricStore.of(context);

      if (state.userLocation == UserLocation.settings) {
        state.handleBiometricPermissionAfterSettingsChange(
          context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final deviceInfo = sDeviceInfo;
    final notifier = BiometricStore.of(context);

    late String headerText;
    late String bottomText;
    late String image;

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

    final deviceSize = sDeviceSize;
    final size = MediaQuery.of(context).size;

    return SPageFrameWithPadding(
      loaderText: intl.register_pleaseWait,
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
        child: SButton.blue(
          callback: () async {
            await notifier.handleBiometricPermission();
          },
          text: intl.allowCamera_goToSettings,
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
