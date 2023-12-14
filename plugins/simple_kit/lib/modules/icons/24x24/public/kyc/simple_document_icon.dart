import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/light/kyc/simple_light_document_icon.dart';
import 'package:simple_kit/utils/enum.dart';

class SDocumentIcon extends StatelessObserverWidget {
  const SDocumentIcon({
    Key? key,
    this.color,
  }) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightDocumentIcon(
            color: color,
          )
        : SimpleLightDocumentIcon(
            color: color,
          );
  }
}
