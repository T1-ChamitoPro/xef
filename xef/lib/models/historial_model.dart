class HistorialDia {
  final String id;
  final DateTime fecha;
  final Map<String, dynamic>? infoNutricionalResumen;
  final Map<String, dynamic>? infoFisicaResumen;
  final List<HistorialComida> comidas;
  final List<HistorialEjercicio> ejercicios;

  HistorialDia({
    required this.id,
    required this.fecha,
    this.infoNutricionalResumen,
    this.infoFisicaResumen,
    this.comidas = const [],
    this.ejercicios = const [],
  });

  factory HistorialDia.fromMap(Map<String, dynamic> map) {
    return HistorialDia(
      id: map['id']?.toString() ?? '',
      fecha:
          DateTime.tryParse(map['fecha']?.toString() ?? '') ?? DateTime.now(),
      infoNutricionalResumen:
          map['info_nutricional_resumen'] as Map<String, dynamic>?,
      infoFisicaResumen: map['info_fisica_resumen'] as Map<String, dynamic>?,
      comidas: (map['historial_comida'] as List<dynamic>? ?? [])
          .map((e) => HistorialComida.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      ejercicios: (map['historial_ejercicio'] as List<dynamic>? ?? [])
          .map((e) => HistorialEjercicio.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class HistorialComida {
  final String? id;
  final String tipoComida;
  final String nombre;
  final String? descripcion;
  final int? calorias;
  final double? proteinasG;
  final double? carbohidratosG;
  final double? grasasG;
  final DateTime? completadoEn;

  HistorialComida({
    this.id,
    required this.tipoComida,
    required this.nombre,
    this.descripcion,
    this.calorias,
    this.proteinasG,
    this.carbohidratosG,
    this.grasasG,
    this.completadoEn,
  });

  factory HistorialComida.fromMap(Map<String, dynamic> map) {
    return HistorialComida(
      id: map['id']?.toString(),
      tipoComida: map['tipo_comida']?.toString() ?? '',
      nombre: map['nombre']?.toString() ?? '',
      descripcion: map['descripcion']?.toString(),
      calorias: (map['calorias'] as num?)?.toInt(),
      proteinasG: (map['proteinas_g'] as num?)?.toDouble(),
      carbohidratosG: (map['carbohidratos_g'] as num?)?.toDouble(),
      grasasG: (map['grasas_g'] as num?)?.toDouble(),
      completadoEn: map['completado_en'] != null
          ? DateTime.tryParse(map['completado_en'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tipo_comida': tipoComida,
      'nombre': nombre,
      'descripcion': descripcion,
      'calorias': calorias,
      'proteinas_g': proteinasG,
      'carbohidratos_g': carbohidratosG,
      'grasas_g': grasasG,
    };
  }
}

class HistorialEjercicio {
  final String? id;
  final String nombre;
  final int? series;
  final int? repeticiones;
  final int? tiempoSegundos;
  final String? grupoMuscular;
  final DateTime? completadoEn;

  HistorialEjercicio({
    this.id,
    required this.nombre,
    this.series,
    this.repeticiones,
    this.tiempoSegundos,
    this.grupoMuscular,
    this.completadoEn,
  });

  factory HistorialEjercicio.fromMap(Map<String, dynamic> map) {
    return HistorialEjercicio(
      id: map['id']?.toString(),
      nombre: map['nombre']?.toString() ?? '',
      series: (map['series'] as num?)?.toInt(),
      repeticiones: (map['repeticiones'] as num?)?.toInt(),
      tiempoSegundos: (map['tiempo_segundos'] as num?)?.toInt(),
      grupoMuscular: map['grupo_muscular']?.toString(),
      completadoEn: map['completado_en'] != null
          ? DateTime.tryParse(map['completado_en'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'series': series,
      'repeticiones': repeticiones,
      'tiempo_segundos': tiempoSegundos,
      'grupo_muscular': grupoMuscular,
    };
  }
}
