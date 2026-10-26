import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/selectable_card.dart';

/// Formulario para configurar parámetros y generar rutinas con IA
class RoutineFormView extends StatelessWidget {
  final Set<String> diasSeleccionados;
  final String modalidadSeleccionada;
  final String objetivoSeleccionado;

  final void Function(String dia, bool selected) onDiaToggle;
  final ValueChanged<String> onModalidadChanged;
  final ValueChanged<String> onObjetivoChanged;
  final VoidCallback onGenerar;

  const RoutineFormView({
    super.key,
    required this.diasSeleccionados,
    required this.modalidadSeleccionada,
    required this.objetivoSeleccionado,
    required this.onDiaToggle,
    required this.onModalidadChanged,
    required this.onObjetivoChanged,
    required this.onGenerar,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.lightGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.fitness_center_rounded,
                  color: AppColors.lightGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Rutinas Inteligentes',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Diseña un plan de acondicionamiento físico adaptado a tus metas y disponibilidad.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),

          // Selección de Días
          const SectionHeader(
            title: 'Días de entrenamiento',
            icon: Icons.calendar_month_rounded,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: AppConstants.diasSemana.map((dia) {
              final selected = diasSeleccionados.contains(dia);
              return ChoiceChip(
                label: Text(
                  dia.substring(0, 3),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: selected
                        ? AppColors.textDark
                        : AppColors.textPrimary,
                  ),
                ),
                selected: selected,
                selectedColor: AppColors.lightGreen,
                backgroundColor: AppColors.azureMist.withValues(alpha: 0.05),
                side: BorderSide(
                  color: selected
                      ? AppColors.lightGreen
                      : AppColors.azureMist.withValues(alpha: 0.12),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (val) => onDiaToggle(dia, val),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Modalidad
          const SectionHeader(
            title: 'Modalidad de entrenamiento',
            icon: Icons.home_repair_service_rounded,
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: AppConstants.modalidadesRutina.length,
            itemBuilder: (context, index) {
              final mod = AppConstants.modalidadesRutina[index];
              final selected = modalidadSeleccionada == mod;
              return SelectableCard(
                label: mod,
                isSelected: selected,
                centerText: true,
                compact: true,
                onTap: () => onModalidadChanged(mod),
              );
            },
          ),
          const SizedBox(height: 28),

          // Objetivo
          const SectionHeader(
            title: 'Objetivo de tu entrenamiento',
            icon: Icons.track_changes_rounded,
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: AppConstants.objetivosRutina.length,
            itemBuilder: (context, index) {
              final obj = AppConstants.objetivosRutina[index];
              final selected = objetivoSeleccionado == obj;
              return SelectableCard(
                label: obj,
                isSelected: selected,
                centerText: true,
                onTap: () => onObjetivoChanged(obj),
              );
            },
          ),
          const SizedBox(height: 36),

          // Botón de Acción
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.flash_on_rounded, size: 22),
              label: const Text('Generar rutinas con IA'),
              onPressed: onGenerar,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
