import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Sección que muestra el resumen de macros y el gasto calórico de entrenamiento
class HistorialResumenNutricionalSection extends StatelessWidget {
  final Map<String, dynamic>? infoNutricional;
  final Map<String, dynamic>? infoFisica;

  const HistorialResumenNutricionalSection({
    super.key,
    this.infoNutricional,
    this.infoFisica,
  });

  @override
  Widget build(BuildContext context) {
    final calorias = infoNutricional?['total_calorias'] ?? 0;
    final proteinas =
        (infoNutricional?['total_proteinas_g'] as num?)?.toDouble() ?? 0.0;
    final carbos =
        (infoNutricional?['total_carbohidratos_g'] as num?)?.toDouble() ?? 0.0;
    final grasas =
        (infoNutricional?['total_grasas_g'] as num?)?.toDouble() ?? 0.0;

    final numEjercicios = infoFisica?['total_ejercicios'] ?? 0;
    final caloriasQuemadas = numEjercicios * 45;
    final grasaQuemadaG = (caloriasQuemadas / 7.7).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 16,
              color: AppColors.lightGreen,
            ),
            SizedBox(width: 8),
            Text(
              'Resumen y Estimaciones Diarias',
              style: TextStyle(
                color: AppColors.lightGreen,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Fila de Macronutrientes Principales
        Row(
          children: [
            _buildStatBadge(
              'Calorías',
              '$calorias kcal',
              Icons.local_fire_department_rounded,
            ),
            const SizedBox(width: 8),
            _buildStatBadge(
              'Proteínas',
              '${proteinas.toStringAsFixed(0)}g',
              Icons.fitness_center_rounded,
            ),
            const SizedBox(width: 8),
            _buildStatBadge(
              'Carbos',
              '${carbos.toStringAsFixed(0)}g',
              Icons.grain_rounded,
            ),
            const SizedBox(width: 8),
            _buildStatBadge(
              'Grasas',
              '${grasas.toStringAsFixed(0)}g',
              Icons.opacity_rounded,
            ),
          ],
        ),
        if (numEjercicios > 0) ...[
          const SizedBox(height: 12),
          // Tarjeta exclusiva de Gasto Energético
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.bolt_rounded,
                      size: 18,
                      color: Colors.orangeAccent,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Gasto en entreno: ~$caloriasQuemadas kcal',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  '~$grasaQuemadaG g grasa',
                  style: const TextStyle(
                    color: AppColors.lightGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatBadge(String label, String val, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.lightGreen.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.lightGreen.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 14, color: AppColors.lightGreen),
            const SizedBox(height: 4),
            Text(
              val,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
