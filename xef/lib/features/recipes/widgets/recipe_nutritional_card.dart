import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Tarjeta de desglose de información nutricional de la receta
class RecipeNutritionalCard extends StatelessWidget {
  final String resumen;

  const RecipeNutritionalCard({
    super.key,
    required this.resumen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.sageGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: AppColors.lightGreen,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'INFORMACIÓN NUTRICIONAL',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightGreen,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            resumen.isNotEmpty
                ? resumen
                : 'Aporta los macronutrientes necesarios para una dieta equilibrada.',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
