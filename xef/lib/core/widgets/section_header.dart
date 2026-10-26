import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Encabezado estándar para secciones en Dashboard, Dietas, Rutinas y Recetas.
class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? badgeText;
  final VoidCallback? onDelete;
  final Widget? trailing;
  final Color? iconColor;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.badgeText,
    this.onDelete,
    this.trailing,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor ?? AppColors.sageGreen, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        if (badgeText != null) ...[
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              badgeText!,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.lightGreen,
              ),
            ),
          ),
        ] else if (trailing != null) ...[
          const Spacer(),
          trailing!,
        ] else ...[
          const Spacer(),
        ],
        if (onDelete != null)
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.errorRed,
              size: 20,
            ),
            tooltip: 'Eliminar',
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }
}
