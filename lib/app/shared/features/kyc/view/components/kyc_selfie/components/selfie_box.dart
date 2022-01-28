import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../notifier/kyc_selfie/kyc_selfie_notipod.dart';

class SelfieBox extends HookWidget {
  const SelfieBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final state = useProvider(kycSelfieNotipod);
    final notifier = useProvider(kycSelfieNotipod.notifier);

    return Stack(
      children: [
        Container(
          height: 225,
          width: 225,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: colors.grey4,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.file(
              File(state.selfie!.path),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 8.0,
          top: 8.0,
          child: GestureDetector(
            onTap: () {
              notifier.removeSelfie();
            },
            child: const SizedBox(
              height: 28,
              width: 28,
              child: SCloseWithBorderIcon(),
            ),
          ),
        ),
      ],
    );
  }
}
