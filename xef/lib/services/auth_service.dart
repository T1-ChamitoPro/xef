import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

/// Servicio de autenticación y gestión de perfil en Supabase
class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Registra usuario en Supabase Auth y guarda sus datos antropométricos en la tabla 'usuario'
  Future<void> registrarUsuario({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    required int alturaCm,
    required double pesoKg,
    required String sexo,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );

    final userId = response.user?.id;
    if (userId == null) {
      throw Exception('Error al registrar usuario en Supabase Auth');
    }

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

  /// Inicia sesión con correo y contraseña
  Future<void> login(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  /// Obtiene el perfil del usuario autenticado mapeado a UserProfile
  Future<UserProfile?> obtenerPerfilUsuario() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final data = await _supabase
        .from('usuario')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (data == null) return null;
    return UserProfile.fromMap(data);
  }

  /// Cierra la sesión activa
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
