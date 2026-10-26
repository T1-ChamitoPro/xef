import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/ai_loading_view.dart';
import '../../core/widgets/background_glow.dart';
import '../../providers/recipe_provider.dart';
import 'recipe_detail_screen.dart';
import 'widgets/recipe_result_card.dart';
import 'widgets/recipe_search_bar.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final recipeProvider = context.read<RecipeProvider>();
      recipeProvider.cargarFavoritas();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _ejecutarBusqueda(String termino) async {
    final texto = termino.trim();
    if (texto.isEmpty) return;

    final recipeProvider = context.read<RecipeProvider>();
    await recipeProvider.buscarYMostrarEnLista(texto);
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = context.watch<RecipeProvider>();

    if (recipeProvider.recetas.isEmpty && _searchController.text.isNotEmpty) {
      _searchController.clear();
    }

    final estaBuscando = recipeProvider.recetas.isNotEmpty;
    final listaAMostrar = estaBuscando
        ? recipeProvider.recetas
        : recipeProvider.favoritas;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const BackgroundGlow(opacity: 0.12),
          SafeArea(
            child: recipeProvider.isLoadingList
                ? const AILoadingView(
                    title: 'Buscando y optimizando...',
                    description: 'Consultando biblioteca y calculando macros con Inteligencia Artificial.',
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ==================== SECCIÓN SUPERIOR ====================
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGreen.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.restaurant_menu_rounded,
                                      color: AppColors.lightGreen,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Recetas',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),

                              // Título
                              RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    height: 1.25,
                                  ),
                                  children: [
                                    TextSpan(text: '¿Qué quieres\ncocinar '),
                                    TextSpan(
                                      text: 'hoy?',
                                      style: TextStyle(
                                        color: AppColors.lightGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Buscador
                              RecipeSearchBar(
                                controller: _searchController,
                                onSearch: _ejecutarBusqueda,
                              ),
                              const SizedBox(height: 14),

                              // Sugerencias rápidas (Chips)
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: AppConstants.sugerenciasRecetas.map(
                                    (plato) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: ActionChip(
                                          label: Text(plato),
                                          labelStyle: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          backgroundColor: AppColors.azureMist
                                              .withValues(alpha: 0.05),
                                          side: BorderSide(
                                            color: AppColors.azureMist
                                                .withValues(alpha: 0.1),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          onPressed: () {
                                            _searchController.text = plato;
                                            _ejecutarBusqueda(plato);
                                          },
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ==================== SECCIÓN INFERIOR ====================
                        Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height * 0.5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg.withValues(alpha: 0.45),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(28),
                              topRight: Radius.circular(28),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  20,
                                  24,
                                  12,
                                ),
                                child: Text(
                                  estaBuscando
                                      ? 'Resultados (${listaAMostrar.length})'
                                      : 'Recetas Guardadas (${listaAMostrar.length})',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              listaAMostrar.isEmpty
                                  ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 40,
                                        ),
                                        child: Text(
                                          'Aún no tienes recetas guardadas.\n¡Busca una y toca el corazón para guardarla!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            height: 1.4,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    )
                                  : ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.fromLTRB(
                                        20,
                                        0,
                                        20,
                                        24,
                                      ),
                                      itemCount: listaAMostrar.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 12),
                                      itemBuilder: (context, index) {
                                        final receta = listaAMostrar[index];
                                        return RecipeResultCard(
                                          receta: receta,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    RecipeDetailScreen(
                                                      receta: receta,
                                                    ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
