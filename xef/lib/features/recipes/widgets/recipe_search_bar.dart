import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Barra de búsqueda personalizada para consultar recetas con IA o base de datos local
class RecipeSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearch;

  const RecipeSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.azureMist.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.azureMist.withValues(alpha: 0.1),
        ),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
        onSubmitted: onSearch,
        decoration: InputDecoration(
          hintText: 'Ej: Pechuga a la plancha con quinoa...',
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.6),
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.lightGreen,
            size: 22,
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.lightGreen,
              size: 20,
            ),
            onPressed: () => onSearch(controller.text),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
