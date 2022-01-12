import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/constants.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';

class AllowCamera extends HookWidget {
  const AllowCamera({Key? key}) : super(key: key);

  static void push({
    required BuildContext context,
  }) {
    navigatorPush(
      context,
      const AllowCamera(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return SPageFrameWithPadding(
      header: const SBigHeader(
        title: 'Allow camera access',
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 24,
          top: 40,
          left: 24,
          right: 24,
        ),
        child: SPrimaryButton2(
          onTap: () {
            AllowCamera.push(
              context: context,
            );
          },
          name: 'Enable camera',
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
                Baseline(
                  baseline: 48,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    'When prompted, you must enable camera access to continue.',
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
                        'We cannot verify you without using your camera',
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
