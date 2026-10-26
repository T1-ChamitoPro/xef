import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../models/routine_model.dart';
import '../services/routine_service.dart';

/// Gestor de estado para rutinas de ejercicio (activa, filtros, generación con IA y guardado)
class RoutineProvider extends ChangeNotifier {
  final RoutineService _routineService = RoutineService();

  RoutineModel? _rutinaActiva;
  bool _isLoadingActive = false;
  bool _isGeneratingAI = false;
  bool _isSaving = false;
  String? _errorMessage;

  // Estado del flujo de generación
  int _currentStep = 0; // 0: Formulario, 1: Sugerencias IA
  List<RoutineSuggestion> _sugerenciasIA = [];

  // Parámetros del formulario
  final Set<String> _diasSeleccionados = {'LUNES', 'MIERCOLES', 'VIERNES'};
  String _modalidadSeleccionada = AppConstants.modalidadesRutina.first;
  String _objetivoSeleccionado = AppConstants.objetivosRutina.first;
  String _nivelExperiencia = AppConstants.nivelesExperiencia[1]; // Intermedio
  final Set<String> _gruposMuscularesSeleccionados = {'Pecho', 'Espalda'};
  String _observacionesEspeciales = '';

  // Getters
  RoutineModel? get rutinaActiva => _rutinaActiva;
  bool get isLoadingActive => _isLoadingActive;
  bool get isGeneratingAI => _isGeneratingAI;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  int get currentStep => _currentStep;
  List<RoutineSuggestion> get sugerenciasIA => _sugerenciasIA;

  Set<String> get diasSeleccionados => Set.unmodifiable(_diasSeleccionados);
  String get modalidadSeleccionada => _modalidadSeleccionada;
  String get objetivoSeleccionado => _objetivoSeleccionado;
  String get nivelExperiencia => _nivelExperiencia;
  Set<String> get gruposMuscularesSeleccionados =>
      Set.unmodifiable(_gruposMuscularesSeleccionados);
  String get observacionesEspeciales => _observacionesEspeciales;

  RoutineProvider() {
    cargarRutinaActiva();
  }

  /// Carga la rutina activa del usuario desde Supabase
  Future<void> cargarRutinaActiva() async {
    _isLoadingActive = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _rutinaActiva = await _routineService.obtenerRutinaActiva();
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
    } else if (_diasSeleccionados.length > 1) {
      _diasSeleccionados.remove(dia);
    }
    notifyListeners();
  }

  /// Manejo de selección de grupos musculares
  void toggleGrupoMuscular(String grupo, bool selected) {
    if (selected) {
      _gruposMuscularesSeleccionados.add(grupo);
    } else {
      _gruposMuscularesSeleccionados.remove(grupo);
    }
    notifyListeners();
  }

  /// Configuración de modalidad
  void setModalidad(String modalidad) {
    _modalidadSeleccionada = modalidad;
    notifyListeners();
  }

  /// Configuración de objetivo
  void setObjetivo(String objetivo) {
    _objetivoSeleccionado = objetivo;
    notifyListeners();
  }

  /// Configuración de nivel de experiencia
  void setNivelExperiencia(String nivel) {
    _nivelExperiencia = nivel;
    notifyListeners();
  }

  /// Configuración de observaciones especiales
  void setObservaciones(String observaciones) {
    _observacionesEspeciales = observaciones;
    notifyListeners();
  }

  /// Genera opciones de rutinas con IA enviando la parametrización completa
  Future<bool> generarRutinasConIA() async {
    if (_diasSeleccionados.isEmpty) {
      _errorMessage = 'Selecciona al menos un día de entrenamiento';
      notifyListeners();
      return false;
    }

    _isGeneratingAI = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _sugerenciasIA = await _routineService.generarRutinasConIA(
        dias: _diasSeleccionados.toList(),
        modalidad: _modalidadSeleccionada,
        objetivo: _objetivoSeleccionado,
        nivel: _nivelExperiencia,
        gruposMusculares: _gruposMuscularesSeleccionados.toList(),
        observaciones: _observacionesEspeciales,
      );
      _currentStep = 1;
      return true;
    } catch (e) {
      _errorMessage = 'Error al generar rutinas: $e';
      return false;
    } finally {
      _isGeneratingAI = false;
      notifyListeners();
    }
  }

  /// Guarda la rutina seleccionada y actualiza la rutina activa automáticamente
  Future<bool> guardarRutina(RoutineSuggestion rutinaElegida) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _routineService.guardarRutina(
        nombre: rutinaElegida.titulo,
        diasSemana: _diasSeleccionados.toList(),
        tiempoEstimadoMin: 45,
        modalidad: _modalidadSeleccionada,
        objetivo: _objetivoSeleccionado,
        descripcion: rutinaElegida.descripcion,
        ejercicios: rutinaElegida.ejercicios,
      );

      _rutinaActiva = await _routineService.obtenerRutinaActiva();
      _currentStep = 0;
      return true;
    } catch (e) {
      _errorMessage = 'Error al guardar rutina: $e';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Elimina la rutina activa del usuario
  Future<bool> eliminarRutina() async {
    if (_rutinaActiva == null) return false;

    try {
      await _routineService.eliminarRutina(_rutinaActiva!.id);
      _rutinaActiva = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al eliminar rutina: $e';
      notifyListeners();
      return false;
    }
  }
}
