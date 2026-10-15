import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Registrar Usuario en Auth y guardar perfil en la tabla 'usuario'
  Future<void> registrarUsuario({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    required int alturaCm,
    required double pesoKg,
    required String sexo,
  }) async {
    // 1. Crear usuario en Supabase Auth
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final userId = response.user?.id;
    if (userId == null)
      throw Exception('Error al registrar usuario en Supabase Auth');

    // Mapeo del string del selector al enum exacto de la BD ('MASCULINO', 'FEMENINO', 'OTRO')
    String sexoEnum;
    switch (sexo.trim().toLowerCase()) {
      case 'hombre':
      case 'masculino':
        sexoEnum = 'MASCULINO';
        break;
      case 'mujer':
      case 'femenino':
        sexoEnum = 'FEMENINO';
        break;
      default:
        sexoEnum = 'OTRO';
    }

    // 2. Insertar perfil físico en la tabla 'usuario'
    await _supabase.from('usuario').insert({
      'id': userId,
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'sexo': sexoEnum,
      'altura_cm': alturaCm,
      'peso_kg': pesoKg,
    });
  }

  // Iniciar Sesión
  Future<void> login(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  // Obtener Perfil del Usuario Actual
  Future<Map<String, dynamic>?> obtenerPerfil() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final data = await _supabase
        .from('usuario')
        .select()
        .eq('id', userId)
        .maybeSingle();

    return data;
  }

  // Cerrar Sesión
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
