import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/section_header.dart';
import '../../../models/historial_model.dart';
import '../../../models/routine_model.dart';
import '../../../providers/historial_provider.dart';

class ActiveRoutineCard extends StatelessWidget {
  final RoutineModel? rutinaActiva;
  final String diaSemana;
  final VoidCallback? onDelete;

  const ActiveRoutineCard({
    super.key,
    required this.rutinaActiva,
    required this.diaSemana,
    this.onDelete,
  });

  HistorialEjercicio _parsearEjercicio(String texto) {
    final exp = RegExp(r'(\d+)\s*x\s*(\d+)');
    final match = exp.firstMatch(texto);

    int? series;
    int? repeticiones;

    if (match != null) {
      series = int.tryParse(match.group(1) ?? '');
      repeticiones = int.tryParse(match.group(2) ?? '');
    }

    return HistorialEjercicio(
      nombre: texto,
      series: series ?? 3,
      repeticiones: repeticiones ?? 10,
      tiempoSegundos: 60,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ejerciciosHoy = rutinaActiva?.getEjerciciosDelDia(diaSemana) ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Rutina de hoy',
          icon: Icons.fitness_center_rounded,
          onDelete: rutinaActiva != null ? onDelete : null,
        ),
        const SizedBox(height: 12),
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
          child: rutinaActiva != null && ejerciciosHoy.isNotEmpty
              ? Consumer<HistorialProvider>(
                  builder: (context, historialProvider, _) {
                    return Column(
                      children: ejerciciosHoy.map((ej) {
                        final completado = historialProvider
                            .isEjercicioCompletado(ej);

                        return InkWell(
                          splashColor: Colors.transparent, // Sin bloom blanco
                          highlightColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            historialProvider.toggleEjercicio(
                              _parsearEjercicio(ej),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 4,
                            ),
                            child: Row(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: completado
                                        ? AppColors.lightGreen
                                        : AppColors.lightGreen.withValues(
                                            alpha: 0.1,
                                          ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: completado
                                          ? AppColors.lightGreen
                                          : AppColors.lightGreen.withValues(
                                              alpha: 0.4,
                                            ),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.check_rounded,
                                    size: 14,
                                    color: completado
                                        ? AppColors.background
                                        : Colors.transparent,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    ej,
                                    style: TextStyle(
                                      color: completado
                                          ? AppColors.textSecondary
                                          : AppColors.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      decoration: completado
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                )
              : const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'No tienes una rutina activa o programada.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
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
