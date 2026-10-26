import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/diet_model.dart';

/// Servicio centralizado para gestionar dietas (consultas, guardado, eliminación y generación IA).
class DietService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Obtiene la dieta activa más reciente del usuario
  Future<DietModel?> obtenerDietaActiva() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final data = await _supabase
        .from('dieta')
        .select()
        .eq('usuario_id', userId)
        .order('id', ascending: false)
        .limit(1)
        .maybeSingle();

    if (data == null) return null;
    return DietModel.fromMap(data);
  }

  /// Guarda una nueva dieta en Supabase
  Future<void> guardarDieta({
    required String nombre,
    required List<String> diasSemana,
    required String objetivo,
    required String estiloVida,
    required String tipoDieta,
    required List<String> intolerancias,
    required Map<String, dynamic> menu,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Usuario no autenticado');

    await _supabase.from('dieta').insert({
      'usuario_id': userId,
      'nombre': nombre,
      'dias_semana': diasSemana,
      'info_nutricional': {
        'objetivo': objetivo,
        'estilo_vida': estiloVida,
        'tipo_dieta': tipoDieta,
        'intolerancias': intolerancias,
        'menu': menu,
      },
    });
  }

  /// Elimina una dieta por su ID
  Future<void> eliminarDieta(dynamic dietaId) async {
    await _supabase.from('dieta').delete().eq('id', dietaId);
  }

  /// Genera opciones de dieta usando la Edge Function de Supabase con fallback local
  Future<List<DietSuggestion>> generarDietasConIA({
    required List<String> dias,
    required String objetivo,
    required String estiloVida,
    required String tipoDieta,
    required List<String> intolerancias,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'generar-dieta',
        body: {
          'dias': dias,
          'objetivo': objetivo,
          'estiloVida': estiloVida,
          'tipoDieta': tipoDieta,
          'intolerancias': intolerancias,
        },
      );

      if (response.status == 200) {
        final List<dynamic> dataList = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        return dataList
            .map((m) => DietSuggestion.fromMap(Map<String, dynamic>.from(m as Map)))
            .toList();
      } else {
        throw Exception('Error en el servidor: ${response.status}');
      }
    } catch (_) {
      return _getDietasFallback(dias, objetivo);
    }
  }

  List<DietSuggestion> _getDietasFallback(List<String> dias, String obj) {
    return [
      DietSuggestion(
        titulo: 'Plan Balanceado Saludable',
        descripcion:
            'Diseñado para $obj con distribución adecuada de macronutrientes.',
        menu: {
          for (var dia in dias)
            dia.toUpperCase(): const DietMealDay(
              desayuno: '2 huevos revueltos con espinacas, 1 rebanada de pan integral y café',
              almuerzo: '150g de pechuga a la plancha, media taza de arroz integral, ensalada de pepino',
              cena: 'Filete de pescado al horno con hierbas y ajo, media taza de puré de papas y brócoli al vapor',
            ),
        },
      ),
      DietSuggestion(
        titulo: 'Plan Alto en Proteína',
        descripcion: 'Favorece el mantenimiento y ganancia de masa muscular.',
        menu: {
          for (var dia in dias)
            dia.toUpperCase(): const DietMealDay(
              desayuno: 'Omelette de 3 claras y 1 huevo entero con pimientos y fruta',
              almuerzo: '200g de carne de res magra, quinua y ensalada verde',
              cena: 'Pechuga desmechada con aguacate y ensalada mixta',
            ),
        },
      ),
    ];
  }
}
