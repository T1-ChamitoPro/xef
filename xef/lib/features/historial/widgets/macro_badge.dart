import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class MacroBadge extends StatelessWidget {
  final String label;
  final String valor;
  final String unidad;
  final IconData icon;

  const MacroBadge({
    super.key,
    required this.label,
    required this.valor,
    required this.unidad,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.azureMist.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.azureMist.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 14, color: AppColors.textMuted),
            const SizedBox(height: 6),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: valor,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: ' $unidad',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
