import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/historial_model.dart';

/// Sección visual y compacta de comidas consumidas
class HistorialComidasSection extends StatelessWidget {
  final List<HistorialComida> comidas;

  const HistorialComidasSection({super.key, required this.comidas});

  @override
  Widget build(BuildContext context) {
    if (comidas.isEmpty) {
      return const Text(
        'Sin comidas registradas',
        style: TextStyle(color: AppColors.textMuted, fontSize: 13),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.restaurant, size: 16, color: AppColors.lightGreen),
            SizedBox(width: 8),
            Text(
              'Comidas consumidas',
              style: TextStyle(
                color: AppColors.lightGreen,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...comidas.map(
          (c) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    c.tipoComida.toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.lightGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    c.nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
