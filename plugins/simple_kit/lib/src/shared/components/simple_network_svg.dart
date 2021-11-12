import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NetworkSvgW24 extends StatelessWidget {
  const NetworkSvgW24({
    Key? key,
    this.color,
    required this.url,
  }) : super(key: key);

  final Color? color;
  final String url;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      url,
      width: 24.w,
      height: 24.w,
      color: color,
    );
  }
}

class NetworkSvgR24 extends StatelessWidget {
  const NetworkSvgR24({
    Key? key,
    this.color,
    required this.url,
  }) : super(key: key);

  final Color? color;
  final String url;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(
      url,
      width: 24.r,
      height: 24.r,
      color: color,
    );
  }
}
