import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;

  const AppLogo({
    super.key,
    this.size = 48,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? (size * 0.24);

    Widget image = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        AppConstants.appIconAsset,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );

    if (boxShadow != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: boxShadow,
        ),
        child: image,
      );
    }

    return image;
  }
}
