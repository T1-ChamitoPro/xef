import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xef/features/home/widgets/detail_diet_sheet.dart';
import 'package:xef/features/home/widgets/detail_routine_sheet.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/section_header.dart';
import '../../../models/diet_model.dart';
import '../../../models/routine_model.dart';
import '../../../providers/diet_provider.dart';
import '../../../providers/routine_provider.dart';
import 'plan_tile.dart';

class MyPlansSection extends StatelessWidget {
  const MyPlansSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dietProvider = context.watch<DietProvider>();
    final routineProvider = context.watch<RoutineProvider>();

    final dietas = dietProvider.todasLasDietas;
    final rutinas = routineProvider.todasLasRutinas;

    if (dietas.isEmpty && rutinas.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Mis planes guardados',
          icon: Icons.folder_special_rounded,
        ),
        const SizedBox(height: 14),

        // ===== DIETAS =====
        if (dietas.isNotEmpty) ...[
          const Text(
            'Dietas',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...dietas.map((dieta) {
            final diaHoy = AppDateUtils.getDiaActual().toUpperCase();
            final esDeHoy = dieta.diasSemana.any(
              (d) => d.toUpperCase() == diaHoy,
            );

            return PlanTile(
              titulo: dieta.nombre,
              subtitulo: dieta.diasSemana.join(' • '),
              icon: Icons.restaurant_menu_rounded,
              esActiva: esDeHoy, // ← ahora es "es de hoy"
              onTap: () => _mostrarDetalleDieta(context, dieta),
            );
          }),
          const SizedBox(height: 18),
        ],

        // ===== RUTINAS =====
        if (rutinas.isNotEmpty) ...[
          const Text(
            'Rutinas',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...rutinas.map((rutina) {
            final diaHoy = AppDateUtils.getDiaActual().toUpperCase();
            final esDeHoy = rutina.diasSemana.any(
              (d) => d.toUpperCase() == diaHoy,
            );

            return PlanTile(
              titulo: rutina.nombre,
              subtitulo: rutina.diasSemana.join(' • '),
              icon: Icons.fitness_center_rounded,
              esActiva: esDeHoy, // ← ahora es "es de hoy"
              onTap: () => _mostrarDetalleRutina(context, rutina),
            );
          }),
        ],
      ],
    );
  }

  void _mostrarDetalleDieta(BuildContext context, DietModel dieta) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DetailDietSheet(dieta: dieta),
    );
  }

  void _mostrarDetalleRutina(BuildContext context, RoutineModel rutina) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DetailRoutineSheet(rutina: rutina),
    );
  }
}
