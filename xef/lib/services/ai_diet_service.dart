import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

class AIDietService {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> generarDietasConIA({
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

        return List<Map<String, dynamic>>.from(dataList);
      } else {
        throw Exception('Error en el servidor: ${response.status}');
      }
    } catch (e) {
      return _getDietasFallback(dias, objetivo);
    }
  }

  List<Map<String, dynamic>> _getDietasFallback(List<String> dias, String obj) {
    return [
      {
        'titulo': 'Plan Balanceado Saludable',
        'descripcion':
            'Diseñado para $obj con distribución adecuada de macronutrientes.',
        'menu': {
          for (var dia in dias)
            dia: {
              'desayuno': '2 huevos revueltos con espinacas, 1 rebanada de pan integral y café',
              'almuerzo': '150g de pechuga a la plancha, media taza de arroz integral, ensalada de pepino',
              'cena': 'Filete de pescado al horno con hierbas y ajo, media taza de puré de papas y brócoli al vapor',
            },
        },
      },
      {
        'titulo': 'Plan Alto en Proteína',
        'descripcion': 'Favorece el mantenimiento y ganancia de masa muscular.',
        'menu': {
          for (var dia in dias)
            dia: {
              'desayuno':
                  'Omeyette de 3 claras y 1 huevo entero con pimientos y fruta',
              'almuerzo': '200g de carne de res magra, quinua y ensalada verde',
              'cena': 'Pechuga desmechada con aguacate y ensalada mixta',
            },
        },
      },
    ];
  }
}
