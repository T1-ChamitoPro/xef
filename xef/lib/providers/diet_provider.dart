import 'package:flutter/material.dart';

import '../models/diet_model.dart';
import '../services/diet_service.dart';

class DietProvider extends ChangeNotifier {
  final DietService _dietService = DietService();

  bool _isGeneratingAI = false;
  bool _isSaving = false;
  String? _errorMessage;

  int _currentStep = 0;
  List<DietSuggestion> _sugerenciasIA = [];

  final Set<String> _diasSeleccionados = {'LUNES', 'MIERCOLES', 'VIERNES'};
  String _objetivoSeleccionado = 'PERDIDA DE PESO';
  String _estiloVidaSeleccionado = 'SEDENTARIO';
  String _tipoDietaSeleccionada = 'BALANCEADA';
  final Set<String> _intoleranciasSeleccionadas = {'LACTOSA'};

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
    cargarTodasLasDietas();
  }

  void setStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void toggleDia(String dia, bool selected) {
    if (selected) {
      _diasSeleccionados.add(dia);
    } else {
      _diasSeleccionados.remove(dia);
    }
    notifyListeners();
  }

  void setObjetivo(String objetivo) {
    _objetivoSeleccionado = objetivo;
    notifyListeners();
  }

  void setEstiloVida(String estilo) {
    _estiloVidaSeleccionado = estilo;
    notifyListeners();
  }

  void setTipoDieta(String tipo) {
    _tipoDietaSeleccionada = tipo;
    notifyListeners();
  }

  void toggleIntolerancia(String item, bool selected) {
    if (selected) {
      _intoleranciasSeleccionadas.add(item);
    } else {
      _intoleranciasSeleccionadas.remove(item);
    }
    notifyListeners();
  }

  Future<bool> generarDietasConIA() async {
    if (_diasSeleccionados.isEmpty) {
      _errorMessage = 'Selecciona al menos un día para tu dieta';
      notifyListeners();
      return false;
    }

    _isGeneratingAI = true;
    _errorMessage = null;
    notifyListeners();

    bool exito = false;

    try {
      _sugerenciasIA = await _dietService.generarDietasConIA(
        dias: _diasSeleccionados.toList(),
        objetivo: _objetivoSeleccionado,
        estiloVida: _estiloVidaSeleccionado,
        tipoDieta: _tipoDietaSeleccionada,
        intolerancias: _intoleranciasSeleccionadas.toList(),
      );
      _currentStep = 1;
      exito = true;
    } catch (e) {
      _errorMessage = 'Error al generar la dieta: $e';
      exito = false;
    } finally {
      _isGeneratingAI = false;
      notifyListeners();
    }

    return exito;
  }

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

      await cargarTodasLasDietas();
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

  List<DietModel> _todasLasDietas = [];
  bool _isLoadingList = false;

  List<DietModel> get todasLasDietas => List.unmodifiable(_todasLasDietas);
  bool get isLoadingList => _isLoadingList;

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

  DietModel? getDietaParaDia(String dia) {
    final diaUpper = dia.toUpperCase();

    try {
      return _todasLasDietas.firstWhere(
        (d) => d.diasSemana.any((ds) => ds.toUpperCase() == diaUpper),
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> eliminarDietaPorId(dynamic id) async {
    try {
      await _dietService.eliminarDieta(id);
      _todasLasDietas.removeWhere((d) => d.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al eliminar dieta: $e';
      notifyListeners();
      return false;
    }
  }
}
