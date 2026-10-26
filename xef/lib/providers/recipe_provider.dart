import 'package:flutter/material.dart';

import '../models/recipe_model.dart';
import '../services/recipe_service.dart';

class RecipeProvider extends ChangeNotifier {
  final RecipeService _recipeService = RecipeService();

  // --- Estado de búsqueda individual ---
  RecipeModel? _recetaActual;
  bool _isSearching = false;
  String? _errorMessage;
  final List<String> _busquedasRecientes = [];

  // --- Estado de la lista ---
  List<RecipeModel> _recetas = [];
  bool _isLoadingList = false;
  String? _listError;

  // --- Estado de Favoritas / Guardadas ---
  List<RecipeModel> _favoritas = [];
  bool _isLoadingFavoritas = false;

  // Getters
  RecipeModel? get recetaActual => _recetaActual;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;
  List<String> get busquedasRecientes => List.unmodifiable(_busquedasRecientes);

  List<RecipeModel> get recetas => _recetas;
  bool get isLoadingList => _isLoadingList;
  String? get listError => _listError;

  List<RecipeModel> get favoritas => _favoritas;
  bool get isLoadingFavoritas => _isLoadingFavoritas;

  /// Limpia los resultados de la búsqueda para volver a mostrar las favoritas
  void limpiarBusqueda() {
    _recetas = [];
    _errorMessage = null;
    _listError = null;
    notifyListeners();
  }

  /// Carga las recetas favoritas/guardadas
  Future<void> cargarFavoritas() async {
    _isLoadingFavoritas = true;
    notifyListeners();

    try {
      _favoritas = await _recipeService.obtenerFavoritas();
    } catch (e) {
      debugPrint('Error al cargar favoritas: $e');
    } finally {
      _isLoadingFavoritas = false;
      notifyListeners();
    }
  }

  /// Verifica si una receta está guardada en favoritas
  bool esFavorita(String nombreReceta) {
    return _favoritas.any((r) => r.nombre.trim() == nombreReceta.trim());
  }

  /// Alterna el estado de favorita de una receta
  Future<void> toggleFavorita(RecipeModel receta) async {
    final existe = esFavorita(receta.nombre);

    if (existe) {
      _favoritas.removeWhere((r) => r.nombre.trim() == receta.nombre.trim());
    } else {
      _favoritas.add(receta);
    }
    notifyListeners();

    try {
      if (existe) {
        await _recipeService.eliminarFavorita(receta.nombre);
      } else {
        await _recipeService.agregarFavorita(receta);
      }
      await cargarFavoritas();
    } catch (e) {
      debugPrint('Error al actualizar favorita en Supabase: $e');
      await cargarFavoritas();
    }
  }

  /// Busca o crea una receta (uso individual)
  Future<RecipeModel?> buscarReceta(String termino) async {
    final cleanTerm = termino.trim();
    if (cleanTerm.isEmpty) return null;

    _isSearching = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final receta = await _recipeService.buscarOCrearReceta(cleanTerm);
      _recetaActual = receta;

      if (!_busquedasRecientes.contains(cleanTerm)) {
        _busquedasRecientes.insert(0, cleanTerm);
        if (_busquedasRecientes.length > 5) {
          _busquedasRecientes.removeLast();
        }
      }

      return receta;
    } catch (e) {
      _errorMessage = 'Error al buscar la receta: $e';
      return null;
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  /// Carga recetas desde Supabase
  Future<void> cargarRecetas({String? busqueda}) async {
    _isLoadingList = true;
    _listError = null;
    notifyListeners();

    try {
      _recetas = await _recipeService.obtenerRecetas(busqueda: busqueda);
    } catch (e) {
      _listError = 'Error al cargar recetas: $e';
      _recetas = [];
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  /// Búsqueda con IA para la lista (hasta 6 recetas)
  Future<void> buscarYMostrarEnLista(String termino) async {
    final cleanTerm = termino.trim();
    if (cleanTerm.isEmpty) return;

    _isLoadingList = true;
    _listError = null;
    _recetas = [];
    notifyListeners();

    try {
      final resultadosIA = await _recipeService.buscarRecetasConIA(cleanTerm);
      _recetas = resultadosIA;

      if (!_busquedasRecientes.contains(cleanTerm)) {
        _busquedasRecientes.insert(0, cleanTerm);
        if (_busquedasRecientes.length > 5) {
          _busquedasRecientes.removeLast();
        }
      }
    } catch (e) {
      _listError = 'Error al buscar: $e';
      _recetas = [];
      // ignore: avoid_print
      print('Error en buscarYMostrarEnLista: $e');
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }

  /// Carga el detalle completo de una receta por ID
  Future<RecipeModel?> cargarDetalleReceta(String id) async {
    try {
      final detalle = await _recipeService.obtenerDetalleReceta(id);
      _recetaActual = detalle;
      notifyListeners();
      return detalle;
    } catch (e) {
      _errorMessage = 'Error al cargar detalle: $e';
      notifyListeners();
      return null;
    }
  }

  void limpiarRecetaActual() {
    _recetaActual = null;
    notifyListeners();
  }

  void limpiarError() {
    _errorMessage = null;
    _listError = null;
    notifyListeners();
  }
}
