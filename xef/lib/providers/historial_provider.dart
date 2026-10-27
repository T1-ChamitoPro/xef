import 'package:flutter/material.dart';

import '../models/historial_model.dart';
import '../services/historial_service.dart';

class HistorialProvider extends ChangeNotifier {
  final HistorialService _historialService = HistorialService();

  HistorialDia? _historialHoy;
  List<HistorialDia> _listaHistorial = [];
  bool _isLoading = false;
  bool _isSaving = false;

  HistorialDia? get historialHoy => _historialHoy;
  List<HistorialDia> get listaHistorial => _listaHistorial;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  Future<void> cargarHistorialHoy() async {
    _isLoading = true;
    notifyListeners();

    try {
      _historialHoy = await _historialService.obtenerOCrearHistorialHoy();
    } catch (e) {
      debugPrint('Error al cargar historial inicial: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cargarListaHistorial() async {
    _isLoading = true;
    notifyListeners();

    try {
      _listaHistorial = await _historialService.obtenerHistorial();
    } catch (e) {
      debugPrint('Error al obtener lista de historial: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Comprueba si la comida específica ya está completada
  bool isComidaCompletada(String tipo, String nombreComida) {
    if (_historialHoy == null) return false;
    return _historialHoy!.comidas.any(
      (c) => c.tipoComida == tipo && c.nombre == nombreComida,
    );
  }

  /// Alterna comida en la UI de inmediato y persiste en Supabase
  Future<void> toggleComida(HistorialComida comida) async {
    if (_historialHoy == null) return;

    final estaCompletada = isComidaCompletada(comida.tipoComida, comida.nombre);
    final listaOriginal = List<HistorialComida>.from(_historialHoy!.comidas);

    // 1. Actualización optimista inmediata (0ms de retraso visual)
    if (estaCompletada) {
      _historialHoy!.comidas.removeWhere(
        (c) => c.tipoComida == comida.tipoComida && c.nombre == comida.nombre,
      );
    } else {
      _historialHoy!.comidas.removeWhere(
        (c) => c.tipoComida == comida.tipoComida,
      );
      _historialHoy!.comidas.add(comida);
    }
    notifyListeners();

    // 2. Persistencia transparente en backend (sin re-fetching que revierta el estado)
    try {
      if (estaCompletada) {
        final itemAEliminar = listaOriginal.firstWhere(
          (c) => c.tipoComida == comida.tipoComida && c.nombre == comida.nombre,
        );
        if (itemAEliminar.id != null) {
          await _historialService.desmarcarComida(itemAEliminar.id!);
        }
      } else {
        await _historialService.marcarComida(
          historialId: _historialHoy!.id,
          comida: comida,
        );
      }
    } catch (e) {
      debugPrint('❌ Error al guardar comida en Supabase: $e');
      // Revertir únicamente en caso de falla real de red o base de datos
      _historialHoy = HistorialDia(
        id: _historialHoy!.id,
        fecha: _historialHoy!.fecha,
        infoNutricionalResumen: _historialHoy!.infoNutricionalResumen,
        infoFisicaResumen: _historialHoy!.infoFisicaResumen,
        comidas: listaOriginal,
        ejercicios: _historialHoy!.ejercicios,
      );
      notifyListeners();
    }
  }

  /// Comprueba si el ejercicio está completado
  bool isEjercicioCompletado(String nombreEjercicio) {
    if (_historialHoy == null) return false;
    return _historialHoy!.ejercicios.any((e) => e.nombre == nombreEjercicio);
  }

  /// Alterna ejercicio en la UI de inmediato y persiste en Supabase
  Future<void> toggleEjercicio(HistorialEjercicio ejercicio) async {
    if (_historialHoy == null) return;

    final estaCompletado = isEjercicioCompletado(ejercicio.nombre);
    final listaOriginal = List<HistorialEjercicio>.from(
      _historialHoy!.ejercicios,
    );

    // 1. Actualización optimista inmediata
    if (estaCompletado) {
      _historialHoy!.ejercicios.removeWhere(
        (e) => e.nombre == ejercicio.nombre,
      );
    } else {
      _historialHoy!.ejercicios.add(ejercicio);
    }
    notifyListeners();

    // 2. Persistencia transparente en backend
    try {
      if (estaCompletado) {
        final itemAEliminar = listaOriginal.firstWhere(
          (e) => e.nombre == ejercicio.nombre,
        );
        if (itemAEliminar.id != null) {
          await _historialService.desmarcarEjercicio(itemAEliminar.id!);
        }
      } else {
        await _historialService.marcarEjercicio(
          historialId: _historialHoy!.id,
          ejercicio: ejercicio,
        );
      }
    } catch (e) {
      debugPrint('❌ Error al guardar ejercicio en Supabase: $e');
      _historialHoy = HistorialDia(
        id: _historialHoy!.id,
        fecha: _historialHoy!.fecha,
        infoNutricionalResumen: _historialHoy!.infoNutricionalResumen,
        infoFisicaResumen: _historialHoy!.infoFisicaResumen,
        comidas: _historialHoy!.comidas,
        ejercicios: listaOriginal,
      );
      notifyListeners();
    }
  }

  Future<bool> finalizarYGuardarDia() async {
    if (_historialHoy == null) return false;

    _isSaving = true;
    notifyListeners();

    try {
      int totalCalorias = 0;
      double totalProteinas = 0;
      double totalCarbos = 0;
      double totalGrasas = 0;

      for (var c in _historialHoy!.comidas) {
        totalCalorias += c.calorias ?? 0;
        totalProteinas += c.proteinasG ?? 0;
        totalCarbos += c.carbohidratosG ?? 0;
        totalGrasas += c.grasasG ?? 0;
      }

      final infoNutricional = {
        'total_calorias': totalCalorias,
        'total_proteinas_g': totalProteinas,
        'total_carbohidratos_g': totalCarbos,
        'total_grasas_g': totalGrasas,
        'comidas_completadas': _historialHoy!.comidas.length,
      };

      final infoFisica = {
        'total_ejercicios': _historialHoy!.ejercicios.length,
        'ejercicios_completados': _historialHoy!.ejercicios
            .map((e) => e.nombre)
            .toList(),
      };

      await _historialService.finalizarDia(
        historialId: _historialHoy!.id,
        infoNutricional: infoNutricional,
        infoFisica: infoFisica,
      );

      await cargarListaHistorial();
      await cargarHistorialHoy();
      return true;
    } catch (e) {
      debugPrint('Error al finalizar día: $e');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
