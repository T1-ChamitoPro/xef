import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SelectableCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool centerText;
  final bool compact;

  const SelectableCard({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.centerText = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
          vertical: compact ? 10 : 14,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.lightGreen.withValues(alpha: 0.15)
              : AppColors.azureMist.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.lightGreen
                : AppColors.azureMist.withValues(alpha: 0.08),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Align(
          alignment: centerText ? Alignment.center : Alignment.centerLeft,
          child: Text(
            label,
            textAlign: centerText ? TextAlign.center : TextAlign.left,
            style: TextStyle(
              fontSize: compact ? 12 : 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.lightGreen : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
