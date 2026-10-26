import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../models/historial_model.dart';
import 'historial_comidas_section.dart';
import 'historial_ejercicios_section.dart';
import 'historial_resumen_nutricional_section.dart'; // <--- 1. Importar

/// Tarjeta expandible que muestra el detalle de un día guardado en el historial
class HistorialDiaCard extends StatelessWidget {
  final HistorialDia dia;

  const HistorialDiaCard({super.key, required this.dia});

  @override
  Widget build(BuildContext context) {
    final fechaFormatted =
        "${dia.fecha.day.toString().padLeft(2, '0')}/${dia.fecha.month.toString().padLeft(2, '0')}/${dia.fecha.year}";

    final numCalorias = dia.infoNutricionalResumen?['total_calorias'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.azureMist.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.azureMist.withValues(alpha: 0.08)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        iconColor: AppColors.lightGreen,
        collapsedIconColor: AppColors.textSecondary,
        title: Text(
          fechaFormatted,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '${dia.comidas.length} comidas | ${dia.ejercicios.length} ejercicios ($numCalorias kcal)',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        children: [
          const Divider(height: 1, color: Colors.white10),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HistorialComidasSection(comidas: dia.comidas),
                const SizedBox(height: 16),
                HistorialEjerciciosSection(ejercicios: dia.ejercicios),
                const SizedBox(height: 20),
                const Divider(color: Colors.white10),
                const SizedBox(height: 12),
                // 2. Nueva sección de resumen al final del día
                HistorialResumenNutricionalSection(
                  infoNutricional: dia.infoNutricionalResumen,
                  infoFisica: dia.infoFisicaResumen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
