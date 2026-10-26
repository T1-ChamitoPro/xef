import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/selectable_card.dart';

/// Formulario de configuración de parámetros para la generación de dietas con IA
class DietFormView extends StatelessWidget {
  final Set<String> diasSeleccionados;
  final String objetivoSeleccionado;
  final String estiloVidaSeleccionado;
  final String tipoDietaSeleccionada;
  final Set<String> intoleranciasSeleccionadas;

  final void Function(String dia, bool selected) onDiaToggle;
  final ValueChanged<String> onObjetivoChanged;
  final ValueChanged<String> onEstiloVidaChanged;
  final ValueChanged<String> onTipoDietaChanged;
  final void Function(String intolerancia, bool selected) onIntoleranciaToggle;
  final VoidCallback onGenerar;

  const DietFormView({
    super.key,
    required this.diasSeleccionados,
    required this.objetivoSeleccionado,
    required this.estiloVidaSeleccionado,
    required this.tipoDietaSeleccionada,
    required this.intoleranciasSeleccionadas,
    required this.onDiaToggle,
    required this.onObjetivoChanged,
    required this.onEstiloVidaChanged,
    required this.onTipoDietaChanged,
    required this.onIntoleranciaToggle,
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
                  Icons.set_meal_rounded,
                  color: AppColors.lightGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Plan Nutricional IA',
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
            'Configura tu perfil metabólico para recibir un menú semanal a tu medida.',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),

          // Selección de Días
          const SectionHeader(
            title: 'Días cubiertos',
            icon: Icons.calendar_today_rounded,
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

          // Objetivo Principal
          const SectionHeader(
            title: 'Objetivo nutricional',
            icon: Icons.ads_click_rounded,
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: AppConstants.objetivosNutricionales.length,
            itemBuilder: (context, index) {
              final obj = AppConstants.objetivosNutricionales[index];
              final selected = objetivoSeleccionado == obj;
              return SelectableCard(
                label: obj,
                isSelected: selected,
                centerText: true,
                onTap: () => onObjetivoChanged(obj),
              );
            },
          ),
          const SizedBox(height: 28),

          // Estilo de Vida y Tipo de Dieta
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(
                      title: 'Estilo de vida',
                      icon: Icons.directions_run_rounded,
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: AppConstants.estilosVida.map((estilo) {
                        final selected = estiloVidaSeleccionado == estilo;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SelectableCard(
                            label: estilo,
                            isSelected: selected,
                            compact: true,
                            onTap: () => onEstiloVidaChanged(estilo),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(
                      title: 'Tipo de dieta',
                      icon: Icons.restaurant_rounded,
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: AppConstants.tiposDieta.map((tipo) {
                        final selected = tipoDietaSeleccionada == tipo;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SelectableCard(
                            label: tipo,
                            isSelected: selected,
                            compact: true,
                            onTap: () => onTipoDietaChanged(tipo),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Intolerancias / Alergias
          const SectionHeader(
            title: 'Intolerancias / Alergias',
            icon: Icons.no_food_rounded,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.intolerancias.map((item) {
              final selected = intoleranciasSeleccionadas.contains(item);
              return FilterChip(
                label: Text(
                  item,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                selected: selected,
                selectedColor: AppColors.errorRed.withValues(alpha: 0.8),
                backgroundColor: AppColors.azureMist.withValues(alpha: 0.05),
                side: BorderSide(
                  color: selected
                      ? AppColors.errorRed
                      : AppColors.azureMist.withValues(alpha: 0.12),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (val) => onIntoleranciaToggle(item, val),
              );
            }).toList(),
          ),
          const SizedBox(height: 36),

          // Botón de Acción
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.bolt_rounded, size: 22),
              label: const Text('Generar dieta con IA'),
              onPressed: onGenerar,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
