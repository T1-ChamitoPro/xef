import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/ai_loading_view.dart';
import '../../core/widgets/background_glow.dart';
import '../../providers/recipe_provider.dart';
import 'recipe_detail_screen.dart';
import 'widgets/recipe_result_card.dart';

class RecipeSearchResultsScreen extends StatefulWidget {
  final String query;

  const RecipeSearchResultsScreen({super.key, required this.query});

  @override
  State<RecipeSearchResultsScreen> createState() =>
      _RecipeSearchResultsScreenState();
}

class _RecipeSearchResultsScreenState extends State<RecipeSearchResultsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecipeProvider>().buscarYMostrarEnLista(widget.query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Resultados: "${widget.query}"',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          const BackgroundGlow(opacity: 0.12),
          Consumer<RecipeProvider>(
            builder: (context, provider, child) {
              if (provider.isLoadingList) {
                return const AILoadingView(
                  title: 'Buscando y optimizando...',
                  description: 'Consultando biblioteca y calculando macros con Inteligencia Artificial.',
                );
              }

              if (provider.listError != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      provider.listError!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.errorRed),
                    ),
                  ),
                );
              }

              if (provider.recetas.isEmpty) {
                return const Center(
                  child: Text(
                    'No se encontraron recetas para esta búsqueda.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: provider.recetas.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final receta = provider.recetas[index];
                  return RecipeResultCard(
                    receta: receta,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeDetailScreen(receta: receta),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
