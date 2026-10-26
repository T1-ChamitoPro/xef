import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/recipe_model.dart';

class RecipeService {
  final _supabase = Supabase.instance.client;

  String? get _userId => _supabase.auth.currentUser?.id;

  /// Obtiene las recetas guardadas/favoritas desde la tabla 'receta'
  Future<List<RecipeModel>> obtenerFavoritas() async {
    final userId = _userId;
    if (userId == null) return [];

    final res = await _supabase
        .from('receta')
        .select()
        .eq('usuario_id', userId);

    return (res as List<dynamic>).map((e) {
      final map = Map<String, dynamic>.from(e);
      return RecipeModel(
        nombre: map['nombre']?.toString() ?? '',
        descripcion: map['descripcion']?.toString() ?? '',
        tiempoPreparacionMin:
            (map['tiempo_preparacion_min'] as num?)?.toInt() ?? 0,
        dificultad: map['dificultad']?.toString() ?? 'Media',
        resumenNutricional: map['resumen_nutricional']?.toString(),
        infoNutricional: map['info_alimenticia'] as Map<String, dynamic>?,
        pasos: (map['pasos'] as List<dynamic>? ?? [])
            .map((p) => p.toString())
            .toList(),
        ingredientes: [],
      );
    }).toList();
  }

  /// Guarda una receta en la tabla 'receta'
  Future<void> agregarFavorita(RecipeModel receta) async {
    final userId = _userId;
    if (userId == null) throw Exception('Usuario no autenticado');

    final payload = {
      'usuario_id': userId,
      'nombre': receta.nombre,
      'pasos': receta.pasos,
      'info_alimenticia': receta.infoNutricional,
      'tiempo_preparacion_min': receta.tiempoPreparacionMin,
    };

    await _supabase.from('receta').insert(payload);
  }

  /// Elimina una receta guardada por su nombre
  Future<void> eliminarFavorita(String nombreReceta) async {
    final userId = _userId;
    if (userId == null) return;

    await _supabase
        .from('receta')
        .delete()
        .eq('usuario_id', userId)
        .eq('nombre', nombreReceta);
  }

  /// Búsqueda Híbrida: primero busca en Supabase, si no existe llama a la IA
  Future<RecipeModel> buscarOCrearReceta(String terminoBusqueda) async {
    try {
      final List<dynamic> exist = await _supabase
          .from('receta')
          .select()
          .ilike('nombre', '%${terminoBusqueda.trim()}%')
          .limit(1);

      if (exist.isNotEmpty) {
        return await obtenerDetalleReceta(exist.first['id'].toString());
      }

      // Llamada a Edge Function de IA
      final response = await _supabase.functions.invoke(
        'buscar-receta',
        body: {'busqueda': terminoBusqueda},
      );

      if (response.status == 200) {
        final Map<String, dynamic> recetaIA = response.data is String
            ? jsonDecode(response.data)
            : Map<String, dynamic>.from(response.data);

        return RecipeModel.fromMap(recetaIA);
      } else {
        throw Exception('Error al consultar la receta con IA');
      }
    } catch (_) {
      return _getRecetaFallback(terminoBusqueda);
    }
  }

  /// Busca hasta 6 recetas con IA (para mostrar en tarjetas)
  Future<List<RecipeModel>> buscarRecetasConIA(String terminoBusqueda) async {
    try {
      final response = await _supabase.functions.invoke(
        'buscar-receta',
        body: {'busqueda': terminoBusqueda.trim()},
      );

      if (response.status == 200) {
        final List<dynamic> dataList = response.data is String
            ? jsonDecode(response.data)
            : response.data as List<dynamic>;

        return dataList
            .map(
              (e) => RecipeModel.fromMap(Map<String, dynamic>.from(e as Map)),
            )
            .toList();
      } else {
        throw Exception('Error del servidor: ${response.status}');
      }
    } catch (e) {
      print('Error buscando recetas con IA: $e');
      return [];
    }
  }

  /// Obtiene el detalle completo de una receta (con ingredientes)
  Future<RecipeModel> obtenerDetalleReceta(String recetaId) async {
    final receta = await _supabase
        .from('receta')
        .select()
        .eq('id', recetaId)
        .single();

    final List<dynamic> ingredientesRel = await _supabase
        .from('receta_ingrediente')
        .select('''
          cantidad,
          unidad_medida,
          ingrediente (
            id,
            nombre,
            info_nutricional
          )
        ''')
        .eq('receta_id', recetaId);

    // Inyectamos los ingredientes en el mapa para que fromMap los procese
    final mapCompleto = Map<String, dynamic>.from(receta);
    mapCompleto['ingredientes'] = ingredientesRel;

    return RecipeModel.fromMap(mapCompleto);
  }

  /// Lista recetas (opcionalmente filtradas)
  Future<List<RecipeModel>> obtenerRecetas({
    String? busqueda,
    int limit = 20,
  }) async {
    var query = _supabase.from('receta').select();

    if (busqueda != null && busqueda.trim().isNotEmpty) {
      query = query.ilike('nombre', '%${busqueda.trim()}%');
    }

    final data = await query.order('nombre').limit(limit);

    return data.map((e) => RecipeModel.fromMap(e)).toList();
  }

  /// Fallback cuando falla todo
  RecipeModel _getRecetaFallback(String termino) {
    return RecipeModel(
      nombre: termino.toUpperCase(),
      resumenNutricional: 'Aporta proteína magra, carbohidratos complejos y fibra vegetal para una comida equilibrada.',
      ingredientes: const [
        RecipeIngredient(
          nombre: 'Ingrediente principal',
          cantidad: 1,
          unidad: 'porción',
        ),
        RecipeIngredient(
          nombre: 'Especias al gusto',
          cantidad: 1,
          unidad: 'pizca',
        ),
      ],
      pasos: const [
        'Lavar y preparar todos los ingredientes.',
        'Cocinar a fuego medio durante 20 minutos.',
        'Servir caliente.',
      ],
    );
  }
}
