import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/diet_model.dart';

/// Tarjeta que muestra el desglose de comidas (desayuno, almuerzo, cena) para un día específico
class DietDayMenuCard extends StatelessWidget {
  final String dia;
  final DietMealDay comidas;

  const DietDayMenuCard({super.key, required this.dia, required this.comidas});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.azureMist.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.azureMist.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.lightGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  dia.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightGreen,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const Divider(height: 20, color: Colors.white10),
            if (comidas.desayuno != null)
              _buildMealRow(
                'DESAYUNO',
                comidas.desayuno!,
                Icons.free_breakfast_outlined,
              ),
            if (comidas.almuerzo != null) ...[
              const SizedBox(height: 10),
              _buildMealRow(
                'ALMUERZO',
                comidas.almuerzo!,
                Icons.lunch_dining_outlined,
              ),
            ],
            if (comidas.cena != null) ...[
              const SizedBox(height: 10),
              _buildMealRow(
                'CENA',
                comidas.cena!,
                Icons.dinner_dining_outlined,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMealRow(String tipo, String descripcion, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.sageGreen),
        const SizedBox(width: 8),
        SizedBox(
          width: 85,
          child: Text(
            tipo,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            descripcion,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
