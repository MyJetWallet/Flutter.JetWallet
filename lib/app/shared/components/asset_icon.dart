import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssetIcon extends StatelessWidget {
  const AssetIcon({
    Key? key,
    this.width,
    this.height,
    required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      imageUrl,
      width: width ?? 30.r,
      height: height ?? 30.r,
      placeholderBuilder: (_) {
        return Icon(
          Icons.error,
          size: 30.r,
        );
      },
    );
  }
}
