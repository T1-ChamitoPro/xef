import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/historial_model.dart';

class HistorialService {
  final _supabase = Supabase.instance.client;

  String? get _userId => _supabase.auth.currentUser?.id;

  Future<HistorialDia> obtenerOCrearHistorialHoy() async {
    final userId = _userId;
    if (userId == null) throw Exception('Usuario no autenticado');

    final hoy = DateTime.now();
    final fechaStr =
        "${hoy.year}-${hoy.month.toString().padLeft(2, '0')}-${hoy.day.toString().padLeft(2, '0')}";

    final existing = await _supabase
        .from('historial')
        .select('*, historial_comida(*), historial_ejercicio(*)')
        .eq('usuario_id', userId)
        .eq('fecha', fechaStr)
        .maybeSingle();

    if (existing != null) {
      return HistorialDia.fromMap(existing);
    }

    final nuevo = await _supabase
        .from('historial')
        .insert({'usuario_id': userId, 'fecha': fechaStr})
        .select('*, historial_comida(*), historial_ejercicio(*)')
        .single();

    return HistorialDia.fromMap(nuevo);
  }

  Future<void> marcarComida({
    required String historialId,
    required HistorialComida comida,
  }) async {
    final existente = await _supabase
        .from('historial_comida')
        .select('id')
        .eq('historial_id', historialId)
        .eq('tipo_comida', comida.tipoComida)
        .maybeSingle();

    if (existente != null) {
      await _supabase
          .from('historial_comida')
          .update(comida.toMap())
          .eq('id', existente['id']);
    } else {
      await _supabase.from('historial_comida').insert({
        'historial_id': historialId,
        ...comida.toMap(),
      });
    }
  }

  Future<void> desmarcarComida(String comidaId) async {
    await _supabase.from('historial_comida').delete().eq('id', comidaId);
  }

  Future<void> marcarEjercicio({
    required String historialId,
    required HistorialEjercicio ejercicio,
  }) async {
    final existente = await _supabase
        .from('historial_ejercicio')
        .select('id')
        .eq('historial_id', historialId)
        .eq('nombre', ejercicio.nombre)
        .maybeSingle();

    if (existente != null) {
      await _supabase
          .from('historial_ejercicio')
          .update(ejercicio.toMap())
          .eq('id', existente['id']);
    } else {
      await _supabase.from('historial_ejercicio').insert({
        'historial_id': historialId,
        ...ejercicio.toMap(),
      });
    }
  }

  Future<void> desmarcarEjercicio(String ejercicioId) async {
    await _supabase.from('historial_ejercicio').delete().eq('id', ejercicioId);
  }

  Future<void> finalizarDia({
    required String historialId,
    required Map<String, dynamic> infoNutricional,
    required Map<String, dynamic> infoFisica,
  }) async {
    await _supabase
        .from('historial')
        .update({
          'info_nutricional_resumen': infoNutricional,
          'info_fisica_resumen': infoFisica,
        })
        .eq('id', historialId);
  }

  Future<List<HistorialDia>> obtenerHistorial({int limite = 14}) async {
    final userId = _userId;
    if (userId == null) return [];

    final data = await _supabase
        .from('historial')
        .select('*, historial_comida(*), historial_ejercicio(*)')
        .eq('usuario_id', userId)
        .order('fecha', ascending: false)
        .limit(limite);

    return data.map((e) => HistorialDia.fromMap(e)).toList();
  }
}
