import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/jar/jar_response_model.dart';

extension JarIcon on JarResponseModel {
  Widget getIcon({double? height, double? width}) {
    if (status == JarStatus.closed) {
      return Assets.images.jar.jarClosed.simpleImg(height: height, width: width);
    } else {
      if (balance == 0) {
        return Assets.images.jar.jarEmpty.simpleImg(height: height, width: width);
      } else if (balance >= target) {
        return Assets.images.jar.jarFull.simpleImg(height: height, width: width);
      } else {
        return Assets.images.jar.jarProgress.simpleImg(height: height, width: width);
      }
    }
  }
}
