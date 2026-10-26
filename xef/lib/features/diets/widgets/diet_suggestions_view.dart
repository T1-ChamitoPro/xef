import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/diet_model.dart';
import 'diet_day_menu_card.dart';

/// Vista para explorar y seleccionar sugerencias de dieta generadas por IA
class DietSuggestionsView extends StatefulWidget {
  final List<DietSuggestion> sugerencias;
  final VoidCallback onBack;
  final ValueChanged<DietSuggestion> onSave;
  final bool isSaving;

  const DietSuggestionsView({
    super.key,
    required this.sugerencias,
    required this.onBack,
    required this.onSave,
    required this.isSaving,
  });

  @override
  State<DietSuggestionsView> createState() => _DietSuggestionsViewState();
}

class _DietSuggestionsViewState extends State<DietSuggestionsView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.sugerencias.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No se generaron sugerencias',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: widget.onBack,
              child: const Text('Volver'),
            ),
          ],
        ),
      );
    }

    final dietaActual = widget.sugerencias[_selectedIndex];

    return Column(
      children: [
        // Header de regreso
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
                onPressed: widget.onBack,
              ),
              const SizedBox(width: 8),
              const Text(
                'Planes Propuestos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),

        // Tabs de opciones
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: List.generate(widget.sugerencias.length, (index) {
              final isSelected = _selectedIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ChoiceChip(
                  label: Text('Opción ${index + 1}'),
                  selected: isSelected,
                  selectedColor: AppColors.lightGreen,
                  backgroundColor: AppColors.azureMist.withValues(alpha: 0.05),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.textDark
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.lightGreen
                        : AppColors.sageGreen.withValues(alpha: 0.3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  onSelected: (_) => setState(() => _selectedIndex = index),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 12),

        // Detalle del menú diario
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
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
                      Text(
                        dietaActual.titulo,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (dietaActual.descripcion.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          dietaActual.descripcion,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Desglose por días y comidas
                ...dietaActual.menu.entries.map((entry) {
                  return DietDayMenuCard(
                    dia: entry.key,
                    comidas: entry.value,
                  );
                }),
              ],
            ),
          ),
        ),

        // Botón Guardar / Registrar
        Padding(
          padding: const EdgeInsets.all(24),
          child: widget.isSaving
              ? const CircularProgressIndicator(color: AppColors.lightGreen)
              : SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.bookmark_added_rounded, size: 22),
                    label: const Text('Guardar esta dieta'),
                    onPressed: () => widget.onSave(dietaActual),
                  ),
                ),
        ),
      ],
    );
  }
}
