import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

class AIRoutineService {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> generarRutinasConIA({
    required List<String> dias,
    required String modalidad,
    required String objetivo,
  }) async {
    try {
      // Invocación a la Supabase Edge Function 'generar-rutina'
      final response = await _supabase.functions.invoke(
        'generar-rutina',
        body: {'dias': dias, 'modalidad': modalidad, 'objetivo': objetivo},
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
      // Plan B: Datos de contingencia local si falla la Edge Function o no hay red
      return _getRutinasFallback(dias, modalidad, objetivo);
    }
  }

  List<Map<String, dynamic>> _getRutinasFallback(
    List<String> dias,
    String mod,
    String obj,
  ) {
    return [
      {
        'titulo': 'Opción 1: Circuito Funcional Básica',
        'descripcion': 'Basada en intervalos de tiempo para $obj.',
        'ejercicios': {
          for (var dia in dias)
            dia: [
              'Sentadillas: 4 x 40seg',
              'Saltos de tijera: 4 x 40seg',
              'Plancha abdominal: 4 x 40seg',
              'Escaladores: 4 x 40seg',
            ],
        },
      },
      {
        'titulo': 'Opción 2: Fuerza Metabólica',
        'descripcion': 'Enfocada en control muscular y quema calórica.',
        'ejercicios': {
          for (var dia in dias)
            dia: [
              'Zancadas alternas: 4 x 12 reps',
              'Flexiones de pecho: 4 x 10 reps',
              'Puente de glúteos: 4 x 15 reps',
              'Abdominales: 4 x 15 reps',
            ],
        },
      },
      {
        'titulo': 'Opción 3: Cardio de Impacto Moderado',
        'descripcion':
            'Ideal para ejercitarte $mod sin sobrecargar articulaciones.',
        'ejercicios': {
          for (var dia in dias)
            dia: [
              'Caminata rápida en sitio: 4 x 45seg',
              'Elevaciones de rodilla: 4 x 40seg',
              'Patadas traseras: 4 x 40seg',
              'Jumping Jacks: 4 x 30seg',
            ],
        },
      },
    ];
  }
}
