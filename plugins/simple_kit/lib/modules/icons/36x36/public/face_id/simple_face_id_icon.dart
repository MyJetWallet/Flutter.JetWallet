import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/36x36/light/face_id/simple_light_face_id_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SFaceIdIcon extends StatelessObserverWidget {
  const SFaceIdIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightFaceIdIcon() : const SimpleLightFaceIdIcon();
  }
}
