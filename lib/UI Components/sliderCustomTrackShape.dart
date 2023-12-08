import 'package:flutter/material.dart';
import 'package:nauman/UI%20Components/color.dart';
import 'dart:math' as math;

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class RangeCustomTrackShape extends RoundedRectRangeSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}


// class OurRangeSliderCustomThumbShape extends RoundRangeSliderThumbShape {
//   /// Create a slider thumb that draws a circle.

//   const OurRangeSliderCustomThumbShape({
//     this.enabledThumbRadius = 10.0,
//     required this.disabledThumbRadius,
//     this.elevation = 1.0,
//     this.pressedElevation = 6.0,
//   });

//   /// The preferred radius of the round thumb shape when the slider is enabled.
//   ///
//   /// If it is not provided, then the material default of 10 is used.
//   final double enabledThumbRadius;

//   /// The preferred radius of the round thumb shape when the slider is disabled.
//   ///
//   /// If no disabledRadius is provided, then it is equal to the
//   /// [enabledThumbRadius]
//   final double disabledThumbRadius;
//   double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

//   /// The resting elevation adds shadow to the unpressed thumb.
//   ///
//   /// The default is 1.
//   ///
//   /// Use 0 for no shadow. The higher the value, the larger the shadow. For
//   /// example, a value of 12 will create a very large shadow.
//   ///
//   final double elevation;

//   /// The pressed elevation adds shadow to the pressed thumb.
//   ///
//   /// The default is 6.
//   ///
//   /// Use 0 for no shadow. The higher the value, the larger the shadow. For
//   /// example, a value of 12 will create a very large shadow.
//   final double pressedElevation;

//   @override
//   Size getPreferredSize(bool isEnabled, bool isDiscrete) {
//     return Size.fromRadius(
//         isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
//   }

//   @override
//   void paint(
    
//     PaintingContext context,
//     Offset center, {
//     required Animation<double> activationAnimation,
//     required Animation<double> enableAnimation,
//     required bool isDiscrete,
//     required TextPainter labelPainter,
//     required RenderBox parentBox,
//     required SliderThemeData sliderTheme,
//     required TextDirection textDirection,
//     required double value,
//     required double textScaleFactor,
//     required Size sizeWithOverflow,
//   })
//   {
//     assert(context != null);
//     assert(center != null);
//     assert(enableAnimation != null);
//     assert(sliderTheme != null);
//     assert(sliderTheme.disabledThumbColor != null);
//     assert(sliderTheme.thumbColor != null);
//     assert(!sizeWithOverflow.isEmpty);

//     final Canvas canvas = context.canvas;
//     final Tween<double> radiusTween = Tween<double>(
//       begin: _disabledThumbRadius,
//       end: enabledThumbRadius,
//     );

//     final double radius = radiusTween.evaluate(enableAnimation);

//     final Tween<double> elevationTween = Tween<double>(
//       begin: elevation,
//       end: pressedElevation,
//     );

//     final double evaluatedElevation =
//         elevationTween.evaluate(activationAnimation);

//     {
//       final Path path = Path()
//         ..addArc(
//             Rect.fromCenter(
//                 center: center, width: 1 * radius, height: 1 * radius),
//             0,
//             math.pi * 2);

//       Paint paint = Paint()..color = Colors.white;
//       paint.strokeWidth = 18;

//       paint.style = PaintingStyle.stroke;
//       canvas.drawCircle(
//         center,
//         radius,
//         paint,
//       );

//       {
//         Paint paint = Paint()..color = primaryDark;
//         paint.strokeWidth = 8;
//         paint.style = PaintingStyle.stroke;
//         canvas.drawCircle(
//           center,
//           radius,
//           paint,
//         );
//       }
//       {
//         Paint paint = Paint()..color = primaryDark;
//         paint.strokeWidth = 5;
//         paint.style = PaintingStyle.fill;
//         canvas.drawCircle(
//           center,
//           radius,
//           paint,
//         );
//       }
//     }
//   }
// }



