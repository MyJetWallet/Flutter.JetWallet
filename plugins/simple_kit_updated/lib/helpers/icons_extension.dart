import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';

extension GetSvg on SvgGenImage {
  SvgPicture simpleSvg({double? height, double? width, Color? color}) {
    return this.svg(
      height: height,
      width: width,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(
              color,
              BlendMode.srcIn,
            ),
      package: 'simple_kit_updated',
    );
  }
}

extension GetPng on AssetGenImage {
  Image simpleImg({
    double? height,
    double? width,
    Color? color,
    BoxFit? fit,
    AlignmentGeometry? alignment,
  }) {
    return image(
      fit: fit,
      alignment: alignment ?? Alignment.center,
      height: height,
      width: width,
      color: color,
      package: 'simple_kit_updated',
    );
  }
}
