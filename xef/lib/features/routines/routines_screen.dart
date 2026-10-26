import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/ai_loading_view.dart';
import '../../core/widgets/background_glow.dart';
import '../../providers/routine_provider.dart';
import 'widgets/routine_form_view.dart';
import 'widgets/routine_suggestions_view.dart';

class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routineProvider = context.watch<RoutineProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const BackgroundGlow(opacity: 0.1),
          SafeArea(
            child: routineProvider.isGeneratingAI
                ? const AILoadingView(
                    title: 'Entrenador IA en marcha...',
                    description: 'Estructurando series, repeticiones e intervalos según tu objetivo y modalidad.',
                  )
                : (routineProvider.currentStep == 0
                      ? RoutineFormView(
                          diasSeleccionados: routineProvider.diasSeleccionados,
                          modalidadSeleccionada:
                              routineProvider.modalidadSeleccionada,
                          objetivoSeleccionado:
                              routineProvider.objetivoSeleccionado,
                          onDiaToggle: (dia, val) =>
                              routineProvider.toggleDia(dia, val),
                          onModalidadChanged: (val) =>
                              routineProvider.setModalidad(val),
                          onObjetivoChanged: (val) =>
                              routineProvider.setObjetivo(val),
                          onGenerar: () async {
                            final ok = await routineProvider
                                .generarRutinasConIA();
                            if (!ok &&
                                routineProvider.errorMessage != null &&
                                context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(routineProvider.errorMessage!),
                                ),
                              );
                            }
                          },
                        )
                      : RoutineSuggestionsView(
                          sugerencias: routineProvider.sugerenciasIA,
                          onBack: () => routineProvider.setStep(0),
                          onSave: (rutinaElegida) async {
                            final ok = await routineProvider.guardarRutina(
                              rutinaElegida,
                            );
                            if (ok && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    '¡Rutina guardada en tu perfil!',
                                  ),
                                ),
                              );
                            } else if (!ok &&
                                routineProvider.errorMessage != null &&
                                context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(routineProvider.errorMessage!),
                                ),
                              );
                            }
                          },
                          isSaving: routineProvider.isSaving,
                        )),
          ),
        ],
      ),
    );
  }
}
