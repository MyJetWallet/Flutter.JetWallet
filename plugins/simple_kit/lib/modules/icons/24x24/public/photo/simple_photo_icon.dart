import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/photo/simple_light_photo_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SPhotoIcon extends StatelessObserverWidget {
  const SPhotoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark ? const SimpleLightPhotoIcon() : const SimpleLightPhotoIcon();
  }
}
