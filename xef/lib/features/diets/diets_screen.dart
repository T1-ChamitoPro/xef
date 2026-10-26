import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/ai_loading_view.dart';
import '../../core/widgets/background_glow.dart';
import '../../providers/diet_provider.dart';
import 'widgets/diet_form_view.dart';
import 'widgets/diet_suggestions_view.dart';

class DietsScreen extends StatelessWidget {
  const DietsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dietProvider = context.watch<DietProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const BackgroundGlow(opacity: 0.12),
          SafeArea(
            child: dietProvider.isGeneratingAI
                ? const AILoadingView(
                    title: 'Diseñando tu dieta...',
                    description:
                        'Calculando macronutrientes, balanceando platillos y filtrando intolerancias con IA.',
                  )
                : (dietProvider.currentStep == 0
                    ? DietFormView(
                        diasSeleccionados: dietProvider.diasSeleccionados,
                        objetivoSeleccionado:
                            dietProvider.objetivoSeleccionado,
                        estiloVidaSeleccionado:
                            dietProvider.estiloVidaSeleccionado,
                        tipoDietaSeleccionada:
                            dietProvider.tipoDietaSeleccionada,
                        intoleranciasSeleccionadas:
                            dietProvider.intoleranciasSeleccionadas,
                        onDiaToggle: (dia, val) =>
                            dietProvider.toggleDia(dia, val),
                        onObjetivoChanged: (val) =>
                            dietProvider.setObjetivo(val),
                        onEstiloVidaChanged: (val) =>
                            dietProvider.setEstiloVida(val),
                        onTipoDietaChanged: (val) =>
                            dietProvider.setTipoDieta(val),
                        onIntoleranciaToggle: (item, val) =>
                            dietProvider.toggleIntolerancia(item, val),
                        onGenerar: () async {
                          final ok = await dietProvider.generarDietasConIA();
                          if (!ok &&
                              dietProvider.errorMessage != null &&
                              context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(dietProvider.errorMessage!),
                              ),
                            );
                          }
                        },
                      )
                    : DietSuggestionsView(
                        sugerencias: dietProvider.sugerenciasIA,
                        onBack: () => dietProvider.setStep(0),
                        onSave: (dietaElegida) async {
                          final ok =
                              await dietProvider.guardarDieta(dietaElegida);
                          if (ok && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('¡Dieta registrada exitosamente!'),
                              ),
                            );
                          } else if (!ok &&
                              dietProvider.errorMessage != null &&
                              context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(dietProvider.errorMessage!),
                              ),
                            );
                          }
                        },
                        isSaving: dietProvider.isSaving,
                      )),
          ),
        ],
      ),
    );
  }
}
