import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/user_profile.dart';

/// Tarjeta principal de métricas corporales y cálculo de IMC
class ImcCard extends StatelessWidget {
  final UserProfile? perfil;

  const ImcCard({super.key, required this.perfil});

  @override
  Widget build(BuildContext context) {
    final imcString = perfil?.imcString ?? '22.0';
    final categoria = perfil?.categoriaImc ?? 'Saludable';
    final altura = perfil?.alturaCm ?? 170;
    final peso = perfil?.pesoKg ?? 70.0;
    final sexo = perfil?.sexo ?? 'General';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.sageGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.favorite_rounded,
                    color: AppColors.lightGreen,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'ÍNDICE DE MASA CORPORAL',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightGreen,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.lightGreen.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  categoria,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightGreen,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                imcString,
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'IMC',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.white10),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Altura',
                  '$altura cm',
                  Icons.height_rounded,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Peso',
                  '${peso.toStringAsFixed(0)} kg',
                  Icons.scale_rounded,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Sexo',
                  sexo,
                  Icons.person_outline_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
