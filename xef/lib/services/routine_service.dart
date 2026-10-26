import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/routine_model.dart';

/// Servicio centralizado para gestionar rutinas de ejercicios (consultas, guardado, eliminación e IA).
class RoutineService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Obtiene la rutina activa más reciente del usuario
  Future<RoutineModel?> obtenerRutinaActiva() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final data = await _supabase
        .from('rutina')
        .select()
        .eq('usuario_id', userId)
        .order('id', ascending: false)
        .limit(1)
        .maybeSingle();

    if (data == null) return null;
    return RoutineModel.fromMap(data);
  }

  /// Guarda una nueva rutina en Supabase
  Future<void> guardarRutina({
    required String nombre,
    required List<String> diasSemana,
    required int tiempoEstimadoMin,
    required String modalidad,
    required String objetivo,
    required String descripcion,
    required Map<String, dynamic> ejercicios,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuario no autenticado');

    await _supabase.from('rutina').insert({
      'usuario_id': userId,
      'nombre': nombre,
      'dias_semana': diasSemana,
      'tiempo_estimado_min': tiempoEstimadoMin,
      'info_fisica': {
        'modalidad': modalidad,
        'objetivo': objetivo,
        'descripcion': descripcion,
        'ejercicios': ejercicios,
      },
    });
  }

  /// Elimina una rutina por su identificador
  Future<void> eliminarRutina(dynamic rutinaId) async {
    await _supabase.from('rutina').delete().eq('id', rutinaId);
  }

  /// Genera opciones de rutina con IA delegando a la Edge Function
  Future<List<RoutineSuggestion>> generarRutinasConIA({
    required List<String> dias,
    required String modalidad,
    required String objetivo,
    required String nivel,
    required List<String> gruposMusculares,
    required String observaciones,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'generar-rutina',
        body: {
          'dias': dias,
          'modalidad': modalidad,
          'objetivo': objetivo,
          'nivel': nivel,
          'grupos_musculares': gruposMusculares,
          'observaciones': observaciones,
        },
      );

      if (response.status == 200) {
        final List<dynamic> dataList = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        return dataList
            .map(
              (m) => RoutineSuggestion.fromMap(
                Map<String, dynamic>.from(m as Map),
              ),
            )
            .toList();
      } else {
        throw Exception('Error en el servidor: ${response.status}');
      }
    } catch (_) {
      return _getRutinasFallback(dias, modalidad, objetivo, gruposMusculares);
    }
  }

  List<RoutineSuggestion> _getRutinasFallback(
    List<String> dias,
    String mod,
    String obj,
    List<String> grupos,
  ) {
    final enf = grupos.isNotEmpty ? grupos.join(', ') : 'Cuerpo completo';

    return [
      RoutineSuggestion(
        titulo: 'Opción 1: Enfoque Prioritario ($enf)',
        descripcion:
            'Estructurada para $obj potenciando los músculos seleccionados en $mod.',
        ejercicios: {
          for (var dia in dias)
            dia.toUpperCase(): [
              'Ejercicio principal de $enf: 4 x 10 reps',
              'Ejercicio secundario asistido: 4 x 12 reps',
              'Trabajo complementario de core: 3 x 15 reps',
            ],
        },
      ),
      RoutineSuggestion(
        titulo: 'Opción 2: Fuerza y Control Funcional',
        descripcion: 'Combinación equilibrada para ganar estabilidad en $mod.',
        ejercicios: {
          for (var dia in dias)
            dia.toUpperCase(): [
              'Flexiones / Empujes: 4 x 12 reps',
              'Remo o Tracciones: 4 x 10 reps',
              'Zancadas / Trabajo de piernas: 4 x 12 reps',
            ],
        },
      ),
      RoutineSuggestion(
        titulo: 'Opción 3: Circuito de Resistencia',
        descripcion: 'Maximiza el gasto calórico de $obj.',
        ejercicios: {
          for (var dia in dias)
            dia.toUpperCase(): [
              'Intervalo dinámico 1: 4 x 40seg',
              'Intervalo dinámico 2: 4 x 40seg',
              'Plancha isométrica: 4 x 45seg',
            ],
        },
      ),
    ];
  }
}
