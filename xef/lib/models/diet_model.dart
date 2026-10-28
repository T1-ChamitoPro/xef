class DietMealDay {
  final String? desayuno;
  final String? almuerzo;
  final String? cena;

  const DietMealDay({this.desayuno, this.almuerzo, this.cena});

  factory DietMealDay.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const DietMealDay();
    return DietMealDay(
      desayuno: map['desayuno']?.toString(),
      almuerzo: map['almuerzo']?.toString(),
      cena: map['cena']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'desayuno': desayuno, 'almuerzo': almuerzo, 'cena': cena};
  }
}

class DietSuggestion {
  final String titulo;
  final String descripcion;
  final Map<String, DietMealDay> menu;

  const DietSuggestion({
    required this.titulo,
    required this.descripcion,
    required this.menu,
  });

  factory DietSuggestion.fromMap(Map<String, dynamic> map) {
    final rawMenu = map['menu'] as Map<String, dynamic>? ?? {};
    final parsedMenu = <String, DietMealDay>{};

    for (final entry in rawMenu.entries) {
      if (entry.value is Map) {
        parsedMenu[entry.key.toString().toUpperCase()] = DietMealDay.fromMap(
          Map<String, dynamic>.from(entry.value as Map),
        );
      }
    }

    return DietSuggestion(
      titulo: map['titulo']?.toString() ?? 'Plan Alimenticio',
      descripcion: map['descripcion']?.toString() ?? '',
      menu: parsedMenu,
    );
  }
}

class DietModel {
  final dynamic id;
  final String usuarioId;
  final String nombre;
  final List<String> diasSemana;
  final String objetivo;
  final String estiloVida;
  final String tipoDieta;
  final List<String> intolerancias;
  final Map<String, DietMealDay> menu;

  const DietModel({
    required this.id,
    required this.usuarioId,
    required this.nombre,
    required this.diasSemana,
    required this.objetivo,
    required this.estiloVida,
    required this.tipoDieta,
    required this.intolerancias,
    required this.menu,
  });

  factory DietModel.fromMap(Map<String, dynamic> map) {
    final info = map['info_nutricional'] as Map<String, dynamic>? ?? {};
    final rawMenu = info['menu'] as Map<String, dynamic>? ?? {};
    final parsedMenu = <String, DietMealDay>{};

    for (final entry in rawMenu.entries) {
      if (entry.value is Map) {
        parsedMenu[entry.key.toString().toUpperCase()] = DietMealDay.fromMap(
          Map<String, dynamic>.from(entry.value as Map),
        );
      }
    }

    return DietModel(
      id: map['id'],
      usuarioId: map['usuario_id']?.toString() ?? '',
      nombre: map['nombre']?.toString() ?? 'Dieta Activa',
      diasSemana: List<String>.from(map['dias_semana'] ?? []),
      objetivo: info['objetivo']?.toString() ?? '',
      estiloVida: info['estilo_vida']?.toString() ?? '',
      tipoDieta: info['tipo_dieta']?.toString() ?? '',
      intolerancias: List<String>.from(info['intolerancias'] ?? []),
      menu: parsedMenu,
    );
  }

  DietMealDay? getMenuDelDia(String dia) {
    return menu[dia.toUpperCase()];
  }
}
