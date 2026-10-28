/// Modelo fuertemente tipado para el perfil del usuario.
class UserProfile {
  final String id;
  final String nombre;
  final String apellido;
  final String email;
  final String sexo;
  final int alturaCm;
  final double pesoKg;

  const UserProfile({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.sexo,
    required this.alturaCm,
    required this.pesoKg,
  });

  /// Crea una instancia desde el mapa retornado por Supabase
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id']?.toString() ?? '',
      nombre: map['nombre']?.toString() ?? '',
      apellido: map['apellido']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      sexo: map['sexo']?.toString() ?? 'Otro',
      alturaCm: (map['altura_cm'] as num?)?.toInt() ?? 170,
      pesoKg: (map['peso_kg'] as num?)?.toDouble() ?? 70.0,
    );
  }

  String get primerNombre {
    if (nombre.trim().isEmpty) return 'Usuario';
    return nombre.trim().split(' ').first;
  }

  String get inicial {
    if (nombre.trim().isNotEmpty) {
      return nombre.trim()[0].toUpperCase();
    }
    return 'U';
  }

  double get imc {
    if (alturaCm <= 0) return 0.0;
    final alturaMetros = alturaCm / 100.0;
    return pesoKg / (alturaMetros * alturaMetros);
  }

  String get imcString => imc.toStringAsFixed(1);

  String get categoriaImc {
    if (imc < 18.5) return 'Bajo peso';
    if (imc < 25.0) return 'Saludable';
    if (imc < 30.0) return 'Sobrepeso';
    return 'Obesidad';
  }
}
