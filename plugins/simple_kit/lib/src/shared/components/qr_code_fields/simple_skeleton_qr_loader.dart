import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../simple_kit.dart';

class SSkeletonQrCodeLoader extends StatefulHookWidget {
  const SSkeletonQrCodeLoader({Key? key}) : super(key: key);

  @override
  _SActionConfirmSkeletonLoaderState createState() =>
      _SActionConfirmSkeletonLoaderState();
}

class _SActionConfirmSkeletonLoaderState extends State<SSkeletonQrCodeLoader>
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
      begin: -300.r,
      end: 300.r,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    return ClipRRect(
      child: Stack(
        children: [
          Container(
            width: 200.r,
            height: 200.r,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: const [0.5156, 1],
                colors: [
                  SColorsLight().grey4,
                  SColorsLight().grey5,
                ],
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(animation.value, 0),
            child: Container(
              width: 100.r,
              height: 200.r,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: SColorsLight().grey5,
                    blurRadius: 100.r,
                    spreadRadius: 10.r,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
