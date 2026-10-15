import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

class RecipeService {
  final _supabase = Supabase.instance.client;

  // 1. Búsqueda Híbrida: Consulta primero en Supabase, y si no existe o el usuario busca algo nuevo, consulta a la IA
  Future<Map<String, dynamic>> buscarOCrearRecetaConIA(
    String terminoBusqueda,
  ) async {
    try {
      // Intenta buscar si ya está guardada localmente en la BD
      final List<dynamic> exist = await _supabase
          .from('receta')
          .select()
          .ilike('nombre', '%${terminoBusqueda.trim()}%')
          .limit(1);

      if (exist.isNotEmpty) {
        return await obtenerDetalleReceta(exist.first['id']);
      }

      // Si no existe localmente, invoca la Edge Function para buscar en internet con la IA
      final response = await _supabase.functions.invoke(
        'buscar-receta',
        body: {'busqueda': terminoBusqueda},
      );

      if (response.status == 200) {
        final Map<String, dynamic> recetaIA = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        return recetaIA;
      } else {
        throw Exception('Error al consultar la receta');
      }
    } catch (e) {
      // Fallback local en caso de error de red
      return {
        'nombre': terminoBusqueda.toUpperCase(),
        'info_nutricional': {
          'resumen':
              'Aporta proteína, carbohidratos moderados y fibra vegetal.',
        },
        'ingredientes': [
          {
            'nombre': 'Ingrediente principal',
            'cantidad': '1',
            'unidad': 'porción',
          },
          {'nombre': 'Especias al gusto', 'cantidad': '1', 'unidad': 'pizca'},
        ],
        'pasos': [
          'Lavar y preparar todos los ingredientes.',
          'Cocinar a fuego medio durante 20 minutos.',
          'Servir caliente.',
        ],
      };
    }
  }

  // 2. Obtener Detalle de receta guardada en Supabase
  Future<Map<String, dynamic>> obtenerDetalleReceta(String recetaId) async {
    final receta = await _supabase
        .from('receta')
        .select()
        .eq('id', recetaId)
        .single();

    final List<dynamic> ingredientesRel = await _supabase
        .from('receta_ingrediente')
        .select('cantidad, unidad_medida, ingrediente(nombre)')
        .eq('receta_id', recetaId);

    return {
      'nombre': receta['nombre'],
      'info_nutricional': receta['info_alimenticia'],
      'pasos': receta['pasos'],
      'ingredientes': ingredientesRel
          .map(
            (item) => {
              'nombre': item['ingrediente']?['nombre'] ?? 'Ingrediente',
              'cantidad': item['cantidad'].toString(),
              'unidad': item['unidad_medida'],
            },
          )
          .toList(),
    };
  }
}
