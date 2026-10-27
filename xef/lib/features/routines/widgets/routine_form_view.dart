import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/selectable_card.dart';

class RoutineFormView extends StatelessWidget {
  final Set<String> diasSeleccionados;
  final String modalidadSeleccionada;
  final String objetivoSeleccionado;
  final String nivelExperiencia;
  final Set<String> gruposMuscularesSeleccionados;
  final String observacionesEspeciales;

  final void Function(String dia, bool selected) onDiaToggle;
  final ValueChanged<String> onModalidadChanged;
  final ValueChanged<String> onObjetivoChanged;
  final ValueChanged<String> onNivelChanged;
  final void Function(String grupo, bool selected) onGrupoToggle;
  final ValueChanged<String> onObservacionesChanged;
  final VoidCallback onGenerar;

  const RoutineFormView({
    super.key,
    required this.diasSeleccionados,
    required this.modalidadSeleccionada,
    required this.objetivoSeleccionado,
    required this.nivelExperiencia,
    required this.gruposMuscularesSeleccionados,
    required this.observacionesEspeciales,
    required this.onDiaToggle,
    required this.onModalidadChanged,
    required this.onObjetivoChanged,
    required this.onNivelChanged,
    required this.onGrupoToggle,
    required this.onObservacionesChanged,
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

          // Días
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
                  dia.substring(0, 3).toUpperCase(),
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

          // Modalidad (2 columnas para evitar overflow)
          const SectionHeader(
            title: 'Modalidad de entrenamiento',
            icon: Icons.home_repair_service_rounded,
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: AppConstants.modalidadesRutina.length,
            itemBuilder: (context, index) {
              final mod = AppConstants.modalidadesRutina[index];
              return SelectableCard(
                label: mod,
                isSelected: modalidadSeleccionada == mod,
                centerText: true,
                compact: true,
                onTap: () => onModalidadChanged(mod),
              );
            },
          ),
          const SizedBox(height: 28),

          // Objetivo (2 columnas optimizadas)
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
              childAspectRatio: 2.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: AppConstants.objetivosRutina.length,
            itemBuilder: (context, index) {
              final obj = AppConstants.objetivosRutina[index];
              return SelectableCard(
                label: obj,
                isSelected: objetivoSeleccionado == obj,
                centerText: true,
                compact: true,
                onTap: () => onObjetivoChanged(obj),
              );
            },
          ),
          const SizedBox(height: 28),

          // Nivel de experiencia
          const SectionHeader(
            title: 'Nivel de experiencia',
            icon: Icons.stairs_rounded,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: AppConstants.nivelesExperiencia.map((nivel) {
              final selected = nivelExperiencia == nivel;
              return ChoiceChip(
                label: Text(nivel),
                selected: selected,
                selectedColor: AppColors.lightGreen,
                backgroundColor: AppColors.azureMist.withValues(alpha: 0.05),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? AppColors.textDark : AppColors.textPrimary,
                ),
                side: BorderSide(
                  color: selected
                      ? AppColors.lightGreen
                      : AppColors.azureMist.withValues(alpha: 0.12),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (_) => onNivelChanged(nivel),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Grupos musculares
          const SectionHeader(
            title: 'Grupos musculares a priorizar',
            icon: Icons.accessibility_new_rounded,
          ),
          const SizedBox(height: 8),
          const Text(
            'Selecciona los que quieras enfatizar (opcional)',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: AppConstants.gruposMusculares.map((grupo) {
              final selected = gruposMuscularesSeleccionados.contains(grupo);
              return FilterChip(
                label: Text(grupo),
                selected: selected,
                selectedColor: AppColors.lightGreen.withValues(alpha: 0.85),
                backgroundColor: AppColors.azureMist.withValues(alpha: 0.05),
                checkmarkColor: AppColors.textDark,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: selected ? AppColors.textDark : AppColors.textPrimary,
                ),
                side: BorderSide(
                  color: selected
                      ? AppColors.lightGreen
                      : AppColors.azureMist.withValues(alpha: 0.12),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (val) => onGrupoToggle(grupo, val),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          // Observaciones
          const SectionHeader(
            title: 'Observaciones especiales',
            icon: Icons.notes_rounded,
          ),
          const SizedBox(height: 12),
          TextField(
            maxLines: 3,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Ej: Lesión de rodilla, prefiero poco material, evitar impacto...',
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.6),
              ),
              filled: true,
              fillColor: AppColors.azureMist.withValues(alpha: 0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: AppColors.azureMist.withValues(alpha: 0.12),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: AppColors.azureMist.withValues(alpha: 0.12),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.lightGreen),
              ),
            ),
            onChanged: onObservacionesChanged,
            controller: TextEditingController(text: observacionesEspeciales)
              ..selection = TextSelection.collapsed(
                offset: observacionesEspeciales.length,
              ),
          ),
          const SizedBox(height: 36),

          // Botón
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
