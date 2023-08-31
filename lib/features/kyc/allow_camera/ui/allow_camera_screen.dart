import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/kyc/allow_camera/store/allow_camera_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'AllowCameraRoute')
class AllowCameraScreen extends StatelessWidget {
  const AllowCameraScreen({
    Key? key,
    required this.permissionDescription,
    required this.then,
  }) : super(key: key);

  final String permissionDescription;
  final void Function() then;

  @override
  Widget build(BuildContext context) {
    return Provider<AllowCameraStore>(
      create: (context) => AllowCameraStore(),
      builder: (context, child) => _AllowCameraScreenBody(
        permissionDescription: permissionDescription,
        then: then,
      ),
      dispose: (context, state) => state.dispose(),
    );
  }
}

class _AllowCameraScreenBody extends StatefulObserverWidget {
  const _AllowCameraScreenBody({
    Key? key,
    required this.permissionDescription,
    required this.then,
  }) : super(key: key);

  final String permissionDescription;
  final void Function() then;

  @override
  State<_AllowCameraScreenBody> createState() => _AllowCameraScreenBodyState();
}

class _AllowCameraScreenBodyState extends State<_AllowCameraScreenBody>
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
      // If returned from Settings check whether user enabled permission or not
      if (AllowCameraStore.of(context).userLocation == UserLocation.settings) {
        AllowCameraStore.of(context).handleCameraPermissionAfterSettingsChange(
          context,
          widget.then,
        );
      }
    }
  }

  String _headerTitle(bool status, BuildContext context) {
    return status
        ? intl.allowCamera_headerTitle1
        : intl.allowCamera_headerTitle2;
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final deviceSize = getIt.get<DeviceSize>().size;

    final size = MediaQuery.of(context).size;

    return SPageFrameWithPadding(
      loaderText: intl.register_pleaseWait,
      header: deviceSize.when(
        small: () {
          return SSmallHeader(
            title: _headerTitle(
              AllowCameraStore.of(context).permissionDenied,
              context,
            ),
          );
        },
        medium: () {
          return SMegaHeader(
            titleAlign: TextAlign.left,
            title: _headerTitle(
              AllowCameraStore.of(context).permissionDenied,
              context,
            ),
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
            await AllowCameraStore.of(context).handleCameraPermission(context);
          },
          name: AllowCameraStore.of(context).permissionDenied
              ? intl.allowCamera_goToSettings
              : intl.allowCamera_enableCamera,
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
                  allowCameraAsset,
                  height: size.width * 0.6,
                ),
                const Spacer(),
                if (!AllowCameraStore.of(context).permissionDenied)
                  Baseline(
                    baseline: 48,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      '${intl.allowCamera_text1}.',
                      maxLines: 3,
                      style: sBodyText1Style.copyWith(
                        color: colors.grey1,
                      ),
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Baseline(
                        baseline: 48,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          widget.permissionDescription,
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
