import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../simple_kit.dart';

final _loaderRadius = BorderRadius.circular(20.r);

class SActionConfirmSkeletonLoader extends StatefulHookWidget {
  const SActionConfirmSkeletonLoader({Key? key}) : super(key: key);

  @override
  _SActionConfirmSkeletonLoaderState createState() =>
      _SActionConfirmSkeletonLoaderState();
}

class _SActionConfirmSkeletonLoaderState
    extends State<SActionConfirmSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    useListenable(_controller);

    final animation = Tween(
      begin: -40.w,
      end: 100.w,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    return ClipRRect(
      borderRadius: _loaderRadius,
      child: Stack(
        children: [
          Container(
            width: 80.w,
            height: 16.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: const [0.5156, 1],
                colors: [
                  SColorsLight().grey4,
                  SColorsLight().grey5,
                ],
              ),
              borderRadius: _loaderRadius,
            ),
          ),
          Transform.translate(
            offset: Offset(animation.value, 0),
            child: Container(
              width: 16.r,
              height: 16.r,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: SColorsLight().grey5,
                    blurRadius: 10.r,
                    spreadRadius: 10.r,
                  ),
                ],
                borderRadius: _loaderRadius,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
