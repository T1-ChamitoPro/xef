import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/historial_model.dart';

/// Sección visual de ejercicios realizados en formato píldora
class HistorialEjerciciosSection extends StatelessWidget {
  final List<HistorialEjercicio> ejercicios;

  const HistorialEjerciciosSection({super.key, required this.ejercicios});

  @override
  Widget build(BuildContext context) {
    if (ejercicios.isEmpty) {
      return const Text(
        'Sin ejercicios registrados',
        style: TextStyle(color: AppColors.textMuted, fontSize: 13),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.fitness_center, size: 16, color: AppColors.lightGreen),
            SizedBox(width: 8),
            Text(
              'Ejercicios realizados',
              style: TextStyle(
                color: AppColors.lightGreen,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ejercicios.map((e) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.lightGreen.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.lightGreen.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 14,
                    color: AppColors.lightGreen,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      e.nombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
