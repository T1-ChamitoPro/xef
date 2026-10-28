import 'package:flutter/material.dart';

import '../models/diet_model.dart';
import '../services/diet_service.dart';

/// Gestor de estado para dietas (activa, filtros, generación con IA y guardado)
class DietProvider extends ChangeNotifier {
  final DietService _dietService = DietService();

  DietModel? _dietaActiva;
  bool _isLoadingActive = false;
  bool _isGeneratingAI = false;
  bool _isSaving = false;
  String? _errorMessage;

  // Estado del flujo de generación
  int _currentStep = 0; // 0: Formulario, 1: Sugerencias IA
  List<DietSuggestion> _sugerenciasIA = [];

  // Parámetros del formulario
  final Set<String> _diasSeleccionados = {'LUNES', 'MIERCOLES', 'VIERNES'};
  String _objetivoSeleccionado = 'PERDIDA DE PESO';
  String _estiloVidaSeleccionado = 'SEDENTARIO';
  String _tipoDietaSeleccionada = 'BALANCEADA';
  final Set<String> _intoleranciasSeleccionadas = {'LACTOSA'};

  // Getters
  DietModel? get dietaActiva => _dietaActiva;
  bool get isLoadingActive => _isLoadingActive;
  bool get isGeneratingAI => _isGeneratingAI;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  int get currentStep => _currentStep;
  List<DietSuggestion> get sugerenciasIA => _sugerenciasIA;

  Set<String> get diasSeleccionados => Set.unmodifiable(_diasSeleccionados);
  String get objetivoSeleccionado => _objetivoSeleccionado;
  String get estiloVidaSeleccionado => _estiloVidaSeleccionado;
  String get tipoDietaSeleccionada => _tipoDietaSeleccionada;
  Set<String> get intoleranciasSeleccionadas =>
      Set.unmodifiable(_intoleranciasSeleccionadas);

  DietProvider() {
    cargarDietaActiva();
  }

  /// Carga la dieta activa del usuario desde Supabase
  Future<void> cargarDietaActiva() async {
    _isLoadingActive = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dietaActiva = await _dietService.obtenerDietaActiva();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingActive = false;
      notifyListeners();
    }
  }

  /// Control de pasos (0: Formulario, 1: Sugerencias)
  void setStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  /// Manejo de selección de días
  void toggleDia(String dia, bool selected) {
    if (selected) {
      _diasSeleccionados.add(dia);
    } else {
      _diasSeleccionados.remove(dia);
    }
    notifyListeners();
  }

  /// Configuración de objetivo
  void setObjetivo(String objetivo) {
    _objetivoSeleccionado = objetivo;
    notifyListeners();
  }

  /// Configuración de estilo de vida
  void setEstiloVida(String estilo) {
    _estiloVidaSeleccionado = estilo;
    notifyListeners();
  }

  /// Configuración de tipo de dieta
  void setTipoDieta(String tipo) {
    _tipoDietaSeleccionada = tipo;
    notifyListeners();
  }

  /// Manejo de intolerancias
  void toggleIntolerancia(String item, bool selected) {
    if (selected) {
      _intoleranciasSeleccionadas.add(item);
    } else {
      _intoleranciasSeleccionadas.remove(item);
    }
    notifyListeners();
  }

  /// Genera opciones de dietas con IA
  Future<bool> generarDietasConIA() async {
    if (_diasSeleccionados.isEmpty) {
      _errorMessage = 'Selecciona al menos un día para tu dieta';
      notifyListeners();
      return false;
    }

    _isGeneratingAI = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _sugerenciasIA = await _dietService.generarDietasConIA(
        dias: _diasSeleccionados.toList(),
        objetivo: _objetivoSeleccionado,
        estiloVida: _estiloVidaSeleccionado,
        tipoDieta: _tipoDietaSeleccionada,
        intolerancias: _intoleranciasSeleccionadas.toList(),
      );
      _currentStep = 1;
      return true;
    } catch (e) {
      _errorMessage = 'Error al generar la dieta: $e';
      return false;
    } finally {
      _isGeneratingAI = false;
      notifyListeners();
    }
  }

  /// Guarda la dieta seleccionada y actualiza la dieta activa automáticamente
  Future<bool> guardarDieta(DietSuggestion dietaElegida) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final rawMenu = <String, dynamic>{};
      dietaElegida.menu.forEach((key, val) {
        rawMenu[key] = val.toMap();
      });

      await _dietService.guardarDieta(
        nombre: dietaElegida.titulo,
        diasSemana: _diasSeleccionados.toList(),
        objetivo: _objetivoSeleccionado,
        estiloVida: _estiloVidaSeleccionado,
        tipoDieta: _tipoDietaSeleccionada,
        intolerancias: _intoleranciasSeleccionadas.toList(),
        menu: rawMenu,
      );

      // Recargar la dieta activa inmediatamente para que el Dashboard se actualice sin recargar
      _dietaActiva = await _dietService.obtenerDietaActiva();
      _currentStep = 0;
      return true;
    } catch (e) {
      _errorMessage = 'Error al guardar la dieta: $e';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Elimina la dieta activa del usuario
  Future<bool> eliminarDieta() async {
    if (_dietaActiva == null) return false;

    try {
      await _dietService.eliminarDieta(_dietaActiva!.id);
      _dietaActiva = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al eliminar dieta: $e';
      notifyListeners();
      return false;
    }
  }

  List<DietModel> _todasLasDietas = [];
  bool _isLoadingList = false;

  List<DietModel> get todasLasDietas => List.unmodifiable(_todasLasDietas);
  bool get isLoadingList => _isLoadingList;

  /// Carga todas las dietas del usuario
  Future<void> cargarTodasLasDietas() async {
    _isLoadingList = true;
    notifyListeners();

    try {
      _todasLasDietas = await _dietService.obtenerTodasLasDietas();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingList = false;
      notifyListeners();
    }
  }
}
