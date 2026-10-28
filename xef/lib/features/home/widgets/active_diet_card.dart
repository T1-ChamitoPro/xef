import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/section_header.dart';
import '../../../models/diet_model.dart';
import '../../../models/historial_model.dart';
import '../../../providers/historial_provider.dart';

class ActiveDietCard extends StatelessWidget {
  final DietModel? dietaActiva;
  final String diaSemana;
  final VoidCallback? onDelete;

  const ActiveDietCard({
    super.key,
    required this.dietaActiva,
    required this.diaSemana,
    this.onDelete,
  });

  HistorialComida _crearHistorialComida(String tipo, String plato) {
    int calorias = 450;
    double proteinas = 30;
    double carbos = 35;
    double grasas = 15;

    final tipoLower = tipo.toLowerCase();
    if (tipoLower.contains('desayuno')) {
      calorias = 400;
      proteinas = 25;
      carbos = 30;
      grasas = 18;
    } else if (tipoLower.contains('almuerzo')) {
      calorias = 650;
      proteinas = 45;
      carbos = 50;
      grasas = 22;
    } else if (tipoLower.contains('cena')) {
      calorias = 480;
      proteinas = 35;
      carbos = 20;
      grasas = 25;
    }

    return HistorialComida(
      tipoComida: tipo,
      nombre: plato,
      descripcion: plato,
      calorias: calorias,
      proteinasG: proteinas,
      carbohidratosG: carbos,
      grasasG: grasas,
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuHoy = dietaActiva?.getMenuDelDia(diaSemana);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Dieta de hoy',
          icon: Icons.restaurant_menu_rounded,
          badgeText: dietaActiva?.nombre,
          onDelete: dietaActiva != null ? onDelete : null,
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.azureMist.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.azureMist.withValues(alpha: 0.08),
            ),
          ),
          child: dietaActiva != null && menuHoy != null
              ? Consumer<HistorialProvider>(
                  builder: (context, historialProvider, _) {
                    return Column(
                      children: [
                        _buildMealCheckTile(
                          context,
                          historialProvider,
                          'Desayuno',
                          menuHoy.desayuno,
                          Icons.free_breakfast_outlined,
                        ),
                        const Divider(height: 16, color: Colors.white10),
                        _buildMealCheckTile(
                          context,
                          historialProvider,
                          'Almuerzo',
                          menuHoy.almuerzo,
                          Icons.lunch_dining_outlined,
                        ),
                        const Divider(height: 16, color: Colors.white10),
                        _buildMealCheckTile(
                          context,
                          historialProvider,
                          'Cena',
                          menuHoy.cena,
                          Icons.dinner_dining_outlined,
                        ),
                      ],
                    );
                  },
                )
              : const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'No tienes una dieta para hoy.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildMealCheckTile(
    BuildContext context,
    HistorialProvider historialProvider,
    String tipo,
    String? plato,
    IconData icon,
  ) {
    if (plato == null || plato.isEmpty) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              tipo,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Sin asignar',
              style: TextStyle(color: AppColors.textMuted, fontSize: 14),
            ),
          ),
        ],
      );
    }

    final completado = historialProvider.isComidaCompletada(tipo, plato);

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        historialProvider.toggleComida(_crearHistorialComida(tipo, plato));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(top: 2),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: completado
                    ? AppColors.lightGreen
                    : AppColors.lightGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: completado
                      ? AppColors.lightGreen
                      : AppColors.lightGreen.withValues(alpha: 0.4),
                ),
              ),
              child: Icon(
                Icons.check_rounded,
                size: 14,
                color: completado ? AppColors.background : Colors.transparent,
              ),
            ),
            const SizedBox(width: 10),
            Icon(icon, size: 18, color: AppColors.lightGreen),
            const SizedBox(width: 10),
            SizedBox(
              width: 75,
              child: Text(
                tipo,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: completado
                      ? AppColors.lightGreen
                      : AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Text(
                plato,
                style: TextStyle(
                  color: completado
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: completado
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
