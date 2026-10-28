import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import 'macro_badge.dart';

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
    final proteinas = infoNutricional?['total_proteinas_g'] ?? 0;
    final carbos = infoNutricional?['total_carbohidratos_g'] ?? 0;
    final grasas = infoNutricional?['total_grasas_g'] ?? 0;

    // Búsqueda flexible de la llave del gasto calórico
    final num gastoCalorias =
        infoFisica?['gasto_calorias_estimado'] ??
        infoFisica?['calorias_quemadas'] ??
        infoFisica?['total_calorias_quemadas'] ??
        infoFisica?['gasto_calorias'] ??
        0;

    final num gastoGrasa =
        infoFisica?['gasto_grasa_estimado_g'] ??
        infoFisica?['grasa_quemada_g'] ??
        0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado
        const Row(
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 18,
              color: AppColors.lightGreen,
            ),
            SizedBox(width: 8),
            Text(
              'Resumen del Día',
              style: TextStyle(
                color: AppColors.lightGreen,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Badges de consumo nutricional
        Row(
          children: [
            MacroBadge(
              label: 'Consumido',
              valor: '$calorias',
              unidad: 'kcal',
              icon: Icons.restaurant_rounded,
            ),
            const SizedBox(width: 8),
            MacroBadge(
              label: 'Proteínas',
              valor: '$proteinas',
              unidad: 'g',
              icon: Icons.fitness_center_rounded,
            ),
            const SizedBox(width: 8),
            MacroBadge(
              label: 'Carbos',
              valor: '$carbos',
              unidad: 'g',
              icon: Icons.grain_rounded,
            ),
            const SizedBox(width: 8),
            MacroBadge(
              label: 'Grasas',
              valor: '$grasas',
              unidad: 'g',
              icon: Icons.water_drop_rounded,
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Tarjeta de Gasto Físico Estimado
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.lightGreen.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.lightGreen.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.lightGreen.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  size: 20,
                  color: AppColors.lightGreen,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gasto Estimado en Entrenamiento',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                        children: [
                          TextSpan(
                            text: '~$gastoCalorias kcal ',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.lightGreen,
                            ),
                          ),
                          const TextSpan(
                            text: 'quemadas',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          if (gastoGrasa > 0) ...[
                            const TextSpan(text: ' • '),
                            TextSpan(
                              text: '~$gastoGrasa g grasa',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
