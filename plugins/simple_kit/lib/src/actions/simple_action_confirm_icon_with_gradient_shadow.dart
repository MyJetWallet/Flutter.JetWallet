import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SActionConfirmIconWithGradientShadow extends StatelessWidget {
  const SActionConfirmIconWithGradientShadow({
    Key? key,
    required this.iconUrl,
  }) : super(key: key);

  final String iconUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 200.r,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120.r,
                  height: 120.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(44.r),
                    gradient: const RadialGradient(
                      center: Alignment.topLeft,
                      radius: 1.5,
                      // TODO: temp Colors (Alex will change them on 15.11)
                      colors: [
                        Color(0xFFD990B4),
                        Color(0xFFD5C3D9),
                        Color(0xFFBAD5F9),
                        Color(0xFFFFEBFB),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20.0.r,
              sigmaY: 20.0.r,
            ),
            child: const SizedBox(),
          ),
          SizedBox(
            width: double.infinity,
            height: 200.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.network(
                  iconUrl,
                  width: 48.r,
                  height: 48.r,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
