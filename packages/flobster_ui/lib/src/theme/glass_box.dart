import 'dart:ui';
import 'package:flutter/material.dart';
import 'colors.dart';

/// A modern translucent container with dynamic backdrop blurring.
/// Perfect for Line of Business panels, sidebar segments, and modal cards.
class GlassBox extends StatelessWidget {
  final Widget child;
  final double blur;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const GlassBox({
    Key? key,
    required this.child,
    this.blur = 15.0,
    this.borderRadius = 16.0,
    this.padding,
    this.margin,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          margin: margin,
          decoration: BoxDecoration(
            color: FlobsterColors.surfaceGlass,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: FlobsterColors.borderGlass,
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
