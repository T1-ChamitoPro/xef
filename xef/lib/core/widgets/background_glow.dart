import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Widget reutilizable que proyecta un resplandor ambiental orgánico en el fondo de las pantallas.
class BackgroundGlow extends StatelessWidget {
  final double topOffsetRatio;
  final double rightOffsetRatio;
  final double sizeRatio;
  final double blurSigma;
  final double opacity;
  final Color? glowColor;

  const BackgroundGlow({
    super.key,
    this.topOffsetRatio = -0.2,
    this.rightOffsetRatio = -0.15,
    this.sizeRatio = 0.75,
    this.blurSigma = 70.0,
    this.opacity = 0.12,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final color = glowColor ?? AppColors.lightGreen;

    return Positioned(
      top: size.width * topOffsetRatio,
      right: size.width * rightOffsetRatio,
      child: Container(
        width: size.width * sizeRatio,
        height: size.width * sizeRatio,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: const SizedBox(),
        ),
      ),
    );
  }
}
