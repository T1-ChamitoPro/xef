import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_snack_bar.dart';
import '../../../core/widgets/background_glow.dart';
import '../../../models/recipe_model.dart';
import '../../../providers/recipe_provider.dart';
import 'widgets/recipe_ingredients_section.dart';
import 'widgets/recipe_steps_section.dart';

class RecipeDetailScreen extends StatelessWidget {
  final RecipeModel receta;

  const RecipeDetailScreen({super.key, required this.receta});

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom + 100.0;

    final Map<String, dynamic>? info = receta.infoNutricional;
    final int calorias = (info?['calorias'] as num?)?.toInt() ?? 0;
    final double proteinas = (info?['proteinas_g'] as num?)?.toDouble() ?? 0.0;
    final double carbos = (info?['carbohidratos_g'] as num?)?.toDouble() ?? 0.0;
    final double grasas = (info?['grasas_g'] as num?)?.toDouble() ?? 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          receta.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Consumer<RecipeProvider>(
            builder: (context, recipeProvider, _) {
              final esFav = recipeProvider.esFavorita(receta.nombre);

              return IconButton(
                onPressed: () async {
                  await recipeProvider.toggleFavorita(receta);
                  if (context.mounted) {
                    showAppSnackBar(
                      context,
                      message: esFav
                          ? 'Receta eliminada de guardadas'
                          : '¡Receta guardada correctamente!',
                    );
                  }
                },
                icon: Icon(
                  esFav
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: esFav ? Colors.redAccent : AppColors.textSecondary,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          const BackgroundGlow(opacity: 0.1),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: bottomPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.azureMist.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.azureMist.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          receta.nombre,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (receta.descripcion != null &&
                            receta.descripcion!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            receta.descripcion!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              height: 1.3,
                            ),
                          ),
                        ],
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              size: 16,
                              color: AppColors.lightGreen,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${receta.tiempoPreparacionMin} min',
                              style: const TextStyle(
                                color: AppColors.lightGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 14),
                            if (receta.dificultad != null) ...[
                              const Icon(
                                Icons.bar_chart_rounded,
                                size: 16,
                                color: AppColors.sageGreen,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                receta.dificultad!,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const Divider(height: 24, color: Colors.white10),

                        const Text(
                          'Aporte Nutricional',
                          style: TextStyle(
                            color: AppColors.lightGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildNutritionalBadge(
                              'Calorías',
                              '$calorias kcal',
                              Icons.local_fire_department_rounded,
                            ),
                            const SizedBox(width: 8),
                            _buildNutritionalBadge(
                              'Proteínas',
                              '${proteinas.toStringAsFixed(0)}g',
                              Icons.fitness_center_rounded,
                            ),
                            const SizedBox(width: 8),
                            _buildNutritionalBadge(
                              'Carbos',
                              '${carbos.toStringAsFixed(0)}g',
                              Icons.grain_rounded,
                            ),
                            const SizedBox(width: 8),
                            _buildNutritionalBadge(
                              'Grasas',
                              '${grasas.toStringAsFixed(0)}g',
                              Icons.opacity_rounded,
                            ),
                          ],
                        ),
                        if (receta.resumenNutricional != null &&
                            receta.resumenNutricional!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (receta.ingredientes.isNotEmpty) ...[
                    RecipeIngredientsSection(ingredientes: receta.ingredientes),
                    const SizedBox(height: 24),
                  ],

                  RecipeStepsSection(pasos: receta.pasos),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionalBadge(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.lightGreen.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.lightGreen.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 14, color: AppColors.lightGreen),
            const SizedBox(height: 4),
            Text(
              value,
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
