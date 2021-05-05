import 'dart:async';
import 'package:flutter/material.dart';

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({
    required this.buttonController,
    Key? key,
  })  : buttonSqueezeAnimation = Tween(
          begin: 320.0,
          end: 70.0,
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: const Interval(
              0,
              0.150,
            ),
          ),
        ),
        buttonZoomOut = Tween(
          begin: 70.0,
          end: 1000.0,
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: const Interval(
              0.550,
              0.999,
              curve: Curves.bounceOut,
            ),
          ),
        ),
        containerCircleAnimation = EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 50.0),
          end: const EdgeInsets.only(),
        ).animate(
          CurvedAnimation(
            parent: buttonController,
            curve: const Interval(
              0.500,
              0.800,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);

  final AnimationController buttonController;
  final Animation<EdgeInsets> containerCircleAnimation;
  final Animation buttonSqueezeAnimation;
  final Animation buttonZoomOut;

  Future<void> _playAnimation() async {
    try {
      await buttonController.forward();
      await buttonController.reverse();
    } on TickerCanceled {
      //TODO(Vova): Error handling
    }
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Padding(
      padding: buttonZoomOut.value == 70.0
          ? const EdgeInsets.only(bottom: 50.0)
          : containerCircleAnimation.value,
      child: InkWell(
          onTap: _playAnimation,
          child: Hero(
            tag: 'fade',
            child: buttonZoomOut.value as double <= 300
                ? Container(
                    width: buttonZoomOut.value == 70.0
                        ? buttonSqueezeAnimation.value as double
                        : buttonZoomOut.value as double,
                    height: buttonZoomOut.value == 70.0
                        ? 60.0
                        : buttonZoomOut.value as double,
                    alignment: FractionalOffset.center,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(247, 64, 106, 1),
                      borderRadius: buttonZoomOut.value as double < 400.0
                          ? const BorderRadius.all(Radius.circular(30))
                          : const BorderRadius.all(Radius.circular(0)),
                    ),
                    child: buttonSqueezeAnimation.value as double > 75.0
                        ? const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.3,
                            ),
                          )
                        : buttonZoomOut.value as double < 300.0
                            ? const CircularProgressIndicator(
                                strokeWidth: 1,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : null)
                : Container(
                    width: buttonZoomOut.value as double,
                    height: buttonZoomOut.value as double,
                    decoration: BoxDecoration(
                      shape: buttonZoomOut.value as double < 500
                          ? BoxShape.circle
                          : BoxShape.rectangle,
                      color: const Color.fromRGBO(247, 64, 106, 1),
                    ),
                  ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    buttonController.addListener(() {
      if (buttonController.isCompleted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: buttonController,
    );
  }
}
