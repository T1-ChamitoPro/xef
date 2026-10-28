import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xef/features/home/widgets/my_plans_section.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../core/widgets/background_glow.dart';
import '../../core/widgets/confirmation_dialog.dart';
import '../../providers/auth_provider.dart';
import '../../providers/diet_provider.dart';
import '../../providers/historial_provider.dart';
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

  Future<void> _registrarDia(BuildContext context) async {
    final historialProvider = context.read<HistorialProvider>();
    await historialProvider.cargarHistorialHoy();

    if (!context.mounted) return;

    final exito = await historialProvider.finalizarYGuardarDia();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            exito
                ? '¡Jornada de hoy guardada en tu historial!'
                : 'Error al registrar la jornada en Supabase.',
          ),
          backgroundColor: exito ? AppColors.oliveLeaf : AppColors.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final dietProvider = context.watch<DietProvider>();
    final routineProvider = context.watch<RoutineProvider>();
    final historialProvider = context.watch<HistorialProvider>();

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
    final tienePlan =
        dietProvider.dietaActiva != null ||
        routineProvider.rutinaActiva != null;

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
                  historialProvider.cargarHistorialHoy(),
                  dietProvider.cargarTodasLasDietas(),
                  routineProvider.cargarTodasLasRutinas(),
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

                    // IMC
                    ImcCard(perfil: authProvider.perfil),
                    const SizedBox(height: 28),

                    // ===== TÍTULO DEL DÍA =====
                    Center(
                      child: Text(
                        diaSemana,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.w800,
                          height: 0.9,
                          letterSpacing: 4,
                          color: AppColors.lightGreen,
                          shadows: [],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Dieta del día
                    ActiveDietCard(
                      dietaActiva: dietProvider.getDietaParaDia(diaSemana),
                      diaSemana: diaSemana,
                      onDelete: () => _eliminarDieta(context),
                    ),
                    const SizedBox(height: 20),

                    // Rutina del día
                    ActiveRoutineCard(
                      rutinaActiva: routineProvider.getRutinaParaDia(diaSemana),
                      diaSemana: diaSemana,
                      onDelete: () => _eliminarRutina(context),
                    ),

                    const SizedBox(height: 12),
                    const MyPlansSection(),
                    const SizedBox(height: 28),

                    // ===== BOTÓN REGISTRAR DÍA EN HISTORIAL =====
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tienePlan
                              ? AppColors.lightGreen
                              : AppColors.azureMist.withValues(alpha: 0.12),
                          foregroundColor: tienePlan
                              ? AppColors.textDark
                              : AppColors.textMuted,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: tienePlan ? 2 : 0,
                        ),
                        icon: historialProvider.isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.textDark,
                                ),
                              )
                            : const Icon(Icons.check_circle_rounded, size: 22),
                        label: Text(
                          historialProvider.isSaving
                              ? 'Guardando en historial...'
                              : 'Registrar Día en Historial',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: (historialProvider.isSaving)
                            ? null
                            : () => _registrarDia(context),
                      ),
                    ),
                    const SizedBox(height: 32),
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
