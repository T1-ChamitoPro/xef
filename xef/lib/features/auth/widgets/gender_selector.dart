import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

/// Selector desplegable para el sexo biológico.
class GenderSelector extends StatelessWidget {
  final String selectedValue;
  final ValueChanged<String> onChanged;

  const GenderSelector({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Elimina opciones duplicadas para evitar errores de Flutter.
    final opciones = AppConstants.opcionesSexo.toSet().toList();

    // Busca el valor real de la lista sin distinguir mayúsculas.
    String? valorSeleccionado;

    for (final opcion in opciones) {
      if (opcion.trim().toLowerCase() == selectedValue.trim().toLowerCase()) {
        valorSeleccionado = opcion;
        break;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.textPrimary.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.wc, color: AppColors.lightGreen),
          const SizedBox(width: 12),
          const Text(
            'Sexo:',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: valorSeleccionado,
                isExpanded: true,
                hint: const Text('Seleccionar'),
                dropdownColor: AppColors.cardBg,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.lightGreen,
                ),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    onChanged(newValue);
                  }
                },
                items: opciones.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
