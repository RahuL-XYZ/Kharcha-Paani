import 'package:flutter/material.dart';

/// Primitive rectangular skeleton placeholder block.
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white, // Color is masked by Shimmer.fromColors
        borderRadius: borderRadius ?? BorderRadius.circular(16),
      ),
    );
  }
}

/// Primitive circular skeleton placeholder (avatars, icons).
class ShimmerCircle extends StatelessWidget {
  final double size;
  final EdgeInsetsGeometry? margin;

  const ShimmerCircle({
    super.key,
    required this.size,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: margin,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Primitive line placeholder representing text skeletons.
class ShimmerLine extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;

  const ShimmerLine({
    super.key,
    this.width,
    this.height = 12,
    this.margin,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(6),
      ),
    );
  }
}

/// Skeleton container matching M3 Expressive card style.
class ShimmerCard extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final double borderRadius;

  const ShimmerCard({
    super.key,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.child,
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
