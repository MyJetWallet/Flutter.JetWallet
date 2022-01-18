import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/constants.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../notifier/camera_permission/camera_permission_notipod.dart';
import '../../../notifier/choose_documents/choose_documents_state.dart';
import '../../../provider/is_permission_deny_stpod.dart';
import '../upload_documents/upload_kyc_documents.dart';

class AllowCamera extends HookWidget {
  const AllowCamera({
    Key? key,
    required this.activeDocument,
  }) : super(key: key);

  final DocumentsModel activeDocument;

  static void push({
    required BuildContext context,
    required DocumentsModel activeDocument,
  }) {
    navigatorPush(
      context,
      AllowCamera(
        activeDocument: activeDocument,
      ),
    );
  }

  static void pushReplacement({
    required BuildContext context,
    required DocumentsModel activeDocument,
  }) {
    navigatorPushReplacement(
      context,
      AllowCamera(
        //Todo: need refactor, delete activeDocument
        activeDocument: activeDocument,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final notifier = useProvider(cameraPermissionNotipod.notifier);
    final isPermissionDeny = useProvider(isPermissionDenyStPod);

    return SPageFrameWithPadding(
      header: SMegaHeader(
        titleAlign: TextAlign.left,
        title: isPermissionDeny.state
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
          onTap: () async {
            await openAppSettings();
            final result = await notifier.checkCameraStatus();

            if (result) {
              UploadKycDocuments.pushReplacement(
                context: context,
                activeDocument: activeDocument,
              );
            } else {
              isPermissionDeny.state = true;
            }
          },
          name: isPermissionDeny.state ? 'Go to Settings' : 'Enable camera',
          active: true,
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
                if (!isPermissionDeny.state)
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
