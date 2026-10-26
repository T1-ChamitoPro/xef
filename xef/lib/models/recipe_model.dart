class RecipeIngredient {
  final String? id;
  final String nombre;
  final double cantidad;
  final String unidad;
  final Map<String, dynamic>? infoNutricional;

  const RecipeIngredient({
    this.id,
    required this.nombre,
    required this.cantidad,
    required this.unidad,
    this.infoNutricional,
  });

  factory RecipeIngredient.fromMap(Map<String, dynamic> map) {
    if (map.containsKey('ingrediente') && map['ingrediente'] is Map) {
      final ing = Map<String, dynamic>.from(map['ingrediente'] as Map);
      return RecipeIngredient(
        id: ing['id']?.toString(),
        nombre: ing['nombre']?.toString() ?? 'Ingrediente',
        cantidad: (map['cantidad'] as num?)?.toDouble() ?? 1.0,
        unidad: map['unidad_medida']?.toString() ?? 'unidad',
        infoNutricional: ing['info_nutricional'] as Map<String, dynamic>?,
      );
    }

    return RecipeIngredient(
      id: map['id']?.toString(),
      nombre: map['nombre']?.toString() ?? 'Ingrediente',
      cantidad:
          (map['cantidad'] as num?)?.toDouble() ??
          double.tryParse(map['cantidad']?.toString() ?? '1') ??
          1.0,
      unidad:
          map['unidad_medida']?.toString() ??
          map['unidad']?.toString() ??
          'unidad',
      infoNutricional: map['info_nutricional'] as Map<String, dynamic>?,
    );
  }
}

class RecipeModel {
  final String? id;
  final String nombre;
  final String? descripcion;
  final List<String> pasos;
  final String? imagenUrl;
  final int? tiempoPreparacionMin;
  final String? dificultad;
  final Map<String, dynamic>? infoNutricional;
  final List<String> etiquetas;
  final List<RecipeIngredient> ingredientes;
  final String? resumenNutricional;

  const RecipeModel({
    this.id,
    required this.nombre,
    this.descripcion,
    required this.pasos,
    this.imagenUrl,
    this.tiempoPreparacionMin,
    this.dificultad,
    this.infoNutricional,
    this.etiquetas = const [],
    this.ingredientes = const [],
    this.resumenNutricional,
  });

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    // --- Pasos ---
    final rawPasos = map['pasos'];
    List<String> pasos = [];
    if (rawPasos is List) {
      pasos = rawPasos.map((e) => e.toString()).toList();
    } else if (rawPasos is String && rawPasos.isNotEmpty) {
      pasos = rawPasos.split('\n').where((e) => e.trim().isNotEmpty).toList();
    }

    final rawEtiquetas = map['etiquetas'];
    List<String> etiquetas = [];
    if (rawEtiquetas is List) {
      etiquetas = rawEtiquetas.map((e) => e.toString()).toList();
    }

    final rawIngredientes = map['ingredientes'] as List<dynamic>? ?? [];
    final ingredientes = rawIngredientes
        .map(
          (i) => RecipeIngredient.fromMap(Map<String, dynamic>.from(i as Map)),
        )
        .toList();

    final info =
        (map['info_alimenticia'] ?? map['info_nutricional'])
            as Map<String, dynamic>?;

    String? resumen =
        map['resumen_nutricional']?.toString() ?? info?['resumen']?.toString();

    return RecipeModel(
      id: map['id']?.toString(),
      nombre: map['nombre']?.toString() ?? 'Receta',
      descripcion: map['descripcion']?.toString(),
      pasos: pasos,
      imagenUrl: map['imagen_url']?.toString(),
      tiempoPreparacionMin: map['tiempo_preparacion_min'] as int?,
      dificultad: map['dificultad']?.toString(),
      infoNutricional: info,
      etiquetas: etiquetas,
      ingredientes: ingredientes,
      resumenNutricional: resumen,
    );
  }
}
