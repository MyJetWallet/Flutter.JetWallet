import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

class SSkeletonQrCodeLoader extends StatefulWidget {
  const SSkeletonQrCodeLoader({
    super.key,
    required this.size,
  });

  final double size;

  @override
  State<SSkeletonQrCodeLoader> createState() => _SSkeletonQrCodeLoaderState();
}

class _SSkeletonQrCodeLoaderState extends State<SSkeletonQrCodeLoader>
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
    final animation = Tween(
      begin: -300.0,
      end: 300.0,
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
            width: widget.size,
            height: widget.size,
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
              width: 100.0,
              height: 200.0,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: SColorsLight().grey5,
                    blurRadius: 100.0,
                    spreadRadius: 10.0,
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
