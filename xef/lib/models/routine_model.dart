class RoutineSuggestion {
  final String titulo;
  final String descripcion;
  final Map<String, List<String>> ejercicios;

  const RoutineSuggestion({
    required this.titulo,
    required this.descripcion,
    required this.ejercicios,
  });

  factory RoutineSuggestion.fromMap(Map<String, dynamic> map) {
    final rawEjercicios = map['ejercicios'] as Map<String, dynamic>? ?? {};
    final parsed = <String, List<String>>{};

    for (final entry in rawEjercicios.entries) {
      if (entry.value is List) {
        parsed[entry.key.toString().toUpperCase()] = List<String>.from(
          (entry.value as List).map((e) => e.toString()),
        );
      }
    }

    return RoutineSuggestion(
      titulo: map['titulo']?.toString() ?? 'Rutina de Entrenamiento',
      descripcion: map['descripcion']?.toString() ?? '',
      ejercicios: parsed,
    );
  }
}

class RoutineModel {
  final dynamic id;
  final String usuarioId;
  final String nombre;
  final List<String> diasSemana;
  final int tiempoEstimadoMin;
  final String modalidad;
  final String objetivo;
  final String descripcion;
  final Map<String, List<String>> ejercicios;

  const RoutineModel({
    required this.id,
    required this.usuarioId,
    required this.nombre,
    required this.diasSemana,
    required this.tiempoEstimadoMin,
    required this.modalidad,
    required this.objetivo,
    required this.descripcion,
    required this.ejercicios,
  });

  factory RoutineModel.fromMap(Map<String, dynamic> map) {
    final info = map['info_fisica'] as Map<String, dynamic>? ?? {};
    final rawEjercicios = info['ejercicios'] as Map<String, dynamic>? ?? {};
    final parsed = <String, List<String>>{};

    for (final entry in rawEjercicios.entries) {
      if (entry.value is List) {
        parsed[entry.key.toString().toUpperCase()] = List<String>.from(
          (entry.value as List).map((e) => e.toString()),
        );
      }
    }

    return RoutineModel(
      id: map['id'],
      usuarioId: map['usuario_id']?.toString() ?? '',
      nombre: map['nombre']?.toString() ?? 'Rutina Activa',
      diasSemana: List<String>.from(map['dias_semana'] ?? []),
      tiempoEstimadoMin: (map['tiempo_estimado_min'] as num?)?.toInt() ?? 40,
      modalidad: info['modalidad']?.toString() ?? '',
      objetivo: info['objetivo']?.toString() ?? '',
      descripcion: info['descripcion']?.toString() ?? '',
      ejercicios: parsed,
    );
  }

  List<String> getEjerciciosDelDia(String dia) {
    final key = ejercicios.keys.firstWhere(
      (k) => k.toUpperCase() == dia.toUpperCase(),
      orElse: () => '',
    );
    if (key.isNotEmpty) {
      return ejercicios[key] ?? [];
    }
    return [];
  }
}
