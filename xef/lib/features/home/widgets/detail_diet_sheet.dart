import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/confirmation_dialog.dart';
import '../../../models/diet_model.dart';
import '../../../providers/diet_provider.dart';

class DetailDietSheet extends StatelessWidget {
  final DietModel dieta;

  const DetailDietSheet({super.key, required this.dieta});

  Future<void> _eliminar(BuildContext context) async {
    final confirmar = await showAppConfirmationDialog(
      context: context,
      title: '¿Eliminar esta dieta?',
      message:
          'Se eliminará permanentemente "${dieta.nombre}". Esta acción no se puede deshacer.',
    );

    if (confirmar != true || !context.mounted) return;

    final success = await context.read<DietProvider>().eliminarDietaPorId(
      dieta.id,
    );

    if (context.mounted) {
      Navigator.pop(context); // cerrar el sheet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Dieta eliminada' : 'Error al eliminar'),
          backgroundColor: success ? AppColors.oliveLeaf : AppColors.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        dieta.nombre,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  children: [
                    ...dieta.menu.entries.map((entry) {
                      final dia = entry.key;
                      final menu = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dia,
                              style: const TextStyle(
                                color: AppColors.lightGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _comidaItem('Desayuno', menu.desayuno),
                            _comidaItem('Almuerzo', menu.almuerzo),
                            _comidaItem('Cena', menu.cena),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 12),

                    // ===== BOTÓN ELIMINAR =====
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.errorRed,
                          side: const BorderSide(color: AppColors.errorRed),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                        ),
                        label: const Text(
                          'Eliminar esta dieta',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        onPressed: () => _eliminar(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _comidaItem(String tipo, String? plato) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              tipo,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              plato ?? 'Sin asignar',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
