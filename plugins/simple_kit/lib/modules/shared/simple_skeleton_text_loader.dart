// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

final _loaderRadius = BorderRadius.circular(20.0);

class SSkeletonTextLoader extends StatefulWidget {
  const SSkeletonTextLoader({
    Key? key,
    this.borderRadius,
    required this.height,
    required this.width,
  }) : super(key: key);

  final double height;
  final double width;
  final BorderRadius? borderRadius;

  @override
  _SActionConfirmSkeletonLoaderState createState() =>
      _SActionConfirmSkeletonLoaderState();
}

class _SActionConfirmSkeletonLoaderState extends State<SSkeletonTextLoader>
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
    //useListenable(_controller);

    final animation = Tween(
      begin: -40.0,
      end: 100.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    return ClipRRect(
      borderRadius: widget.borderRadius ?? _loaderRadius,
      child: Stack(
        children: [
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: const [0.5156, 1],
                colors: [
                  SColorsLight().grey4,
                  SColorsLight().grey5,
                ],
              ),
              borderRadius: widget.borderRadius ?? _loaderRadius,
            ),
          ),
          Transform.translate(
            offset: Offset(animation.value, 0),
            child: Container(
              width: 16.0,
              height: widget.height,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: SColorsLight().grey5,
                    blurRadius: 10.0,
                    spreadRadius: 10.0,
                  ),
                ],
                borderRadius: widget.borderRadius ?? _loaderRadius,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
