import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../models/user_profile.dart';
import '../edit_profile_screen.dart';

/// Encabezado del Dashboard con saludo personalizado y avatar interactivo
class DashboardHeader extends StatelessWidget {
  final UserProfile? perfil;

  const DashboardHeader({super.key, required this.perfil});

  @override
  Widget build(BuildContext context) {
    final primerNombre = perfil?.primerNombre ?? 'Usuario';
    final inicial = perfil?.inicial ?? 'U';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, $primerNombre 👋',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Resumen de tu progreso diario',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProfileScreen()),
            );
          },
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.lightGreen, width: 1.5),
                ),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.lightGreen.withValues(alpha: 0.15),
                  child: Text(
                    inicial,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightGreen,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: AppColors.lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    size: 11,
                    color: AppColors.background,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
