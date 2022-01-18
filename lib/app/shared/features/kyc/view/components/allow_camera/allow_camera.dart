import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/constants.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../notifier/camera_permission/camera_permission_notipod.dart';
import '../../../notifier/camera_permission/camera_permission_state.dart';
import '../../../notifier/choose_documents/choose_documents_state.dart';

class AllowCamera extends StatefulHookWidget {
  const AllowCamera({Key? key}) : super(key: key);

  static void push({
    required BuildContext context,
    required DocumentsModel activeDocument,
  }) {
    navigatorPush(
      context,
      const AllowCamera(),
    );
  }

  static void pushReplacement({
    required BuildContext context,
    required DocumentsModel activeDocument,
  }) {
    navigatorPushReplacement(
      context,
      const AllowCamera(),
    );
  }

  @override
  State<AllowCamera> createState() => _AllowCameraState();
}

class _AllowCameraState extends State<AllowCamera> with WidgetsBindingObserver {
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
      final state = context.read(cameraPermissionNotipod);
      final notifier = context.read(cameraPermissionNotipod.notifier);

      // If returned from Settings check whether user enabled permission or not
      if (state.userLocation == UserLocation.settings) {
        notifier.handleCameraPermissionAfterSettingsChange(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final state = useProvider(cameraPermissionNotipod);
    final notifier = useProvider(cameraPermissionNotipod.notifier);

    return SPageFrameWithPadding(
      header: SMegaHeader(
        titleAlign: TextAlign.left,
        title: state.permissionDenied
            ? 'Give permission to\nallow to use camera'
            : 'Allow camera access',
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
            await notifier.handleCameraPermission(context);
          },
          name: state.permissionDenied ? 'Go to Settings' : 'Enable camera',
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
                ),
                const Spacer(),
                if (state.permissionDenied)
                  Baseline(
                    baseline: 48,
                    baselineType: TextBaseline.alphabetic,
                    child: Text(
                      'When prompted, you must enable camera access '
                      'to continue.',
                      maxLines: 3,
                      style: sBodyText1Style.copyWith(
                        color: colors.grey1,
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Baseline(
                      baseline: 48,
                      baselineType: TextBaseline.alphabetic,
                      child: Text(
                        'We cannot verify you without using your\ncamera',
                        maxLines: 3,
                        style: sBodyText1Style.copyWith(
                          color: colors.grey1,
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
