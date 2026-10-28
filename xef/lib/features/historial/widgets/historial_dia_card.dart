import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/historial_model.dart';
import 'historial_comidas_section.dart';
import 'historial_ejercicios_section.dart';
import 'historial_resumen_nutricional_section.dart';

class HistorialDiaCard extends StatelessWidget {
  final HistorialDia dia;

  const HistorialDiaCard({super.key, required this.dia});

  @override
  Widget build(BuildContext context) {
    final fechaFormatted =
        "${dia.fecha.day.toString().padLeft(2, '0')}/${dia.fecha.month.toString().padLeft(2, '0')}/${dia.fecha.year}";

    final numCalorias = dia.infoNutricionalResumen?['total_calorias'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.azureMist.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 6,
            ),
            iconColor: AppColors.lightGreen,
            collapsedIconColor: AppColors.textMuted,
            title: Text(
              fechaFormatted,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${dia.comidas.length} comidas  •  ${dia.ejercicios.length} ejercicios  •  $numCalorias kcal',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            children: [
              Divider(
                height: 1,
                color: AppColors.azureMist.withValues(alpha: 0.1),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HistorialComidasSection(comidas: dia.comidas),
                    const SizedBox(height: 18),
                    HistorialEjerciciosSection(ejercicios: dia.ejercicios),
                    const SizedBox(height: 20),
                    Divider(color: AppColors.azureMist.withValues(alpha: 0.1)),
                    const SizedBox(height: 16),
                    HistorialResumenNutricionalSection(
                      infoNutricional: dia.infoNutricionalResumen,
                      infoFisica: dia.infoFisicaResumen,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
