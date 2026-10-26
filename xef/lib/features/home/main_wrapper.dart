import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../diets/diets_screen.dart';
import '../historial/historial_screen.dart';
import '../recipes/recipes_screen.dart';
import '../routines/routines_screen.dart';
import 'dashboard_screen.dart';
import 'widgets/floating_nav_bar.dart';

/// Contenedor principal de la aplicación con navegación fluida
class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 2; // Inicia en Dashboard (Inicio)

  final List<Widget> _screens = const [
    RecipesScreen(), // 0: Cocina / Recetas
    DietsScreen(), // 1: Dieta
    DashboardScreen(), // 2: Perfil / Inicio
    RoutinesScreen(), // 3: Rutinas
    HistorialScreen(), // 4: Historial
  ];

  static const List<NavItemData> _navItems = [
    NavItemData(
      unselectedIcon: Icons.restaurant_menu_outlined,
      selectedIcon: Icons.restaurant_menu_rounded,
      label: 'Cocina',
    ),
    NavItemData(
      unselectedIcon: Icons.set_meal_outlined,
      selectedIcon: Icons.set_meal_rounded,
      label: 'Dieta',
    ),
    NavItemData(
      unselectedIcon: Icons.grid_view_outlined,
      selectedIcon: Icons.grid_view_rounded,
      label: 'Inicio',
    ),
    NavItemData(
      unselectedIcon: Icons.fitness_center_outlined,
      selectedIcon: Icons.fitness_center_rounded,
      label: 'Rutinas',
    ),
    NavItemData(
      unselectedIcon: Icons.history_outlined,
      selectedIcon: Icons.history_rounded,
      label: 'Historial',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: FloatingNavBar(
        currentIndex: _currentIndex,
        onIndexChanged: (index) => setState(() => _currentIndex = index),
        items: _navItems,
      ),
    );
  }
}
