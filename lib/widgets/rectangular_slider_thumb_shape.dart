import 'package:flutter/material.dart';

class RectangularSliderThumbShape extends SliderComponentShape {
  final Size thumbSize;

  const RectangularSliderThumbShape({this.thumbSize = const Size(20, 12)});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => thumbSize;

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
    final Canvas canvas = context.canvas;
    final Paint paint = Paint()..color = sliderTheme.thumbColor ?? Colors.blue;

    final Rect thumbRect = Rect.fromCenter(
      center: center,
      width: thumbSize.width,
      height: thumbSize.height,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(thumbRect, Radius.circular(20)),
      paint,
    );
  }
}
