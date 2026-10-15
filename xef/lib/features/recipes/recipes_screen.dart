import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../services/recipe_service.dart';
import 'recipe_detail_screen.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final _recipeService = RecipeService();
  final _searchController = TextEditingController();
  bool _isSearchingIA = false;

  Future<void> _ejecutarBusqueda(String termino) async {
    if (termino.trim().isEmpty) return;

    setState(() => _isSearchingIA = true);

    try {
      final resultadoReceta = await _recipeService.buscarOCrearRecetaConIA(
        termino,
      );

      if (mounted) {
        setState(() => _isSearchingIA = false);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RecipeDetailScreen(recetaData: resultadoReceta),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSearchingIA = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al buscar la receta: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isSearchingIA
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(color: AppColors.primaryDark),
                    SizedBox(height: 20),
                    Text(
                      'Buscando receta en la red e informando valores nutricionales...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '¿Qué quieres cocinar hoy?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Escribe cualquier plato o ingrediente y la IA te devolverá la receta paso a paso.',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const Spacer(),

                    // Buscador Central estilo Mockup
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onSubmitted: (value) => _ejecutarBusqueda(value),
                        decoration: InputDecoration(
                          hintText: 'BUSCAR MAS RECETAS O INGREDIENTE...',
                          hintStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.search,
                              color: AppColors.primaryDark,
                            ),
                            onPressed: () =>
                                _ejecutarBusqueda(_searchController.text),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
      ),
    );
  }
}
