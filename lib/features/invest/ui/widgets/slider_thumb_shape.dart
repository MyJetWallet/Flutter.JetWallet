import 'package:flutter/material.dart';

class SliderThumbShape extends SliderComponentShape {
  /// Create a slider thumb that draws a circle.

  const SliderThumbShape({
    this.enabledThumbRadius = 8.0,
    required this.disabledThumbRadius,
    this.elevation = 1.0,
    this.pressedElevation = 6.0,
  });

  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the material default of 10 is used.
  final double enabledThumbRadius;

  /// The preferred radius of the round thumb shape when the slider is disabled.
  ///
  /// If no disabledRadius is provided, then it is equal to the
  /// [enabledThumbRadius]
  final double disabledThumbRadius;
  double get _disabledThumbRadius => disabledThumbRadius;

  /// The resting elevation adds shadow to the unpressed thumb.
  ///
  /// The default is 1.
  ///
  /// Use 0 for no shadow. The higher the value, the larger the shadow. For
  /// example, a value of 12 will create a very large shadow.
  ///
  final double elevation;

  /// The pressed elevation adds shadow to the pressed thumb.
  ///
  /// The default is 6.
  ///
  /// Use 0 for no shadow. The higher the value, the larger the shadow. For
  /// example, a value of 12 will create a very large shadow.
  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
      isEnabled == true ? enabledThumbRadius : _disabledThumbRadius,
    );
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);
    assert(!sizeWithOverflow.isEmpty);

    final canvas = context.canvas;
    final radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );

    radiusTween.evaluate(enableAnimation);

    final elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    elevationTween.evaluate(activationAnimation);

    {
      final paint = Paint()..color = Colors.black;
      paint.strokeWidth = 8;
      paint.style = PaintingStyle.stroke;
      canvas.drawCircle(
        center,
        3,
        paint,
      );
      {
        final paint = Paint()..color = Colors.white;
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(
          center,
          5,
          paint,
        );
      }
    }
  }
}
