import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../core/widgets/background_glow.dart';
import '../../core/widgets/confirmation_dialog.dart';
import '../../providers/auth_provider.dart';
import '../../providers/diet_provider.dart';
import '../../providers/routine_provider.dart';
import 'widgets/active_diet_card.dart';
import 'widgets/active_routine_card.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/imc_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _cerrarSesion(BuildContext context) async {
    final confirmar = await showAppConfirmationDialog(
      context: context,
      title: '¿Cerrar sesión?',
      message: '¿Estás seguro de que quieres salir de tu cuenta?',
    );

    if (confirmar != true || !context.mounted) return;

    await context.read<AuthProvider>().cerrarSesion();
  }

  Future<void> _eliminarDieta(BuildContext context) async {
    final confirmar = await showAppConfirmationDialog(
      context: context,
      title: '¿Eliminar dieta activa?',
      message: 'Esta acción eliminará tu plan nutricional actual. Podrás generar uno nuevo en cualquier momento.',
    );

    if (confirmar != true || !context.mounted) return;

    final success = await context.read<DietProvider>().eliminarDieta();
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dieta eliminada correctamente')),
      );
    }
  }

  Future<void> _eliminarRutina(BuildContext context) async {
    final confirmar = await showAppConfirmationDialog(
      context: context,
      title: '¿Eliminar rutina activa?',
      message: 'Esta acción eliminará tu rutina de ejercicios actual. Podrás generar una nueva en cualquier momento.',
    );

    if (confirmar != true || !context.mounted) return;

    final success = await context.read<RoutineProvider>().eliminarRutina();
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rutina eliminada correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final dietProvider = context.watch<DietProvider>();
    final routineProvider = context.watch<RoutineProvider>();

    final isInitialLoading =
        authProvider.isLoading && authProvider.perfil == null;

    if (isInitialLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.lightGreen),
        ),
      );
    }

    final diaSemana = AppDateUtils.getDiaActual();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const BackgroundGlow(opacity: 0.1),
          SafeArea(
            child: RefreshIndicator(
              color: AppColors.lightGreen,
              backgroundColor: AppColors.cardBg,
              onRefresh: () async {
                await Future.wait([
                  authProvider.cargarPerfil(),
                  dietProvider.cargarDietaActiva(),
                  routineProvider.cargarRutinaActiva(),
                ]);
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header + botón de cerrar sesión
                    Row(
                      children: [
                        Expanded(
                          child: DashboardHeader(perfil: authProvider.perfil),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => _cerrarSesion(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.redAccent.withValues(alpha: 0.25),
                              ),
                            ),
                            child: const Icon(
                              Icons.logout_rounded,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ImcCard(perfil: authProvider.perfil),
                    const SizedBox(height: 28),
                    ActiveDietCard(
                      dietaActiva: dietProvider.dietaActiva,
                      diaSemana: diaSemana,
                      onDelete: () => _eliminarDieta(context),
                    ),
                    const SizedBox(height: 28),
                    ActiveRoutineCard(
                      rutinaActiva: routineProvider.rutinaActiva,
                      diaSemana: diaSemana,
                      onDelete: () => _eliminarRutina(context),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
