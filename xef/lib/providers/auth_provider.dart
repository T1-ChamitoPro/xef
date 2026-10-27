import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile.dart';
import '../services/auth_service.dart';

/// Gestor de estado para la sesión de usuario y perfil con Provider
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserProfile? _perfil;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfile? get perfil => _perfil;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated =>
      Supabase.instance.client.auth.currentSession != null;

  AuthProvider() {
    _init();
  }

  void _init() {
    // Si ya hay una sesión activa, cargar el perfil inmediatamente
    if (isAuthenticated) {
      cargarPerfil();
    }

    // Escuchar cambios en la autenticación de Supabase
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.session != null) {
        cargarPerfil();
      } else {
        _perfil = null;
        notifyListeners();
      }
    });
  }

  /// Carga o actualiza el perfil del usuario actual
  Future<void> cargarPerfil() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _perfil = await _authService.obtenerPerfilUsuario();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Inicia sesión con correo y contraseña
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.login(email, password);
      await cargarPerfil();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Registra un nuevo usuario con sus datos físicos
  Future<bool> registrarUsuario({
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    required int alturaCm,
    required double pesoKg,
    required String sexo,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.registrarUsuario(
        email: email,
        password: password,
        nombre: nombre,
        apellido: apellido,
        alturaCm: alturaCm,
        pesoKg: pesoKg,
        sexo: sexo,
      );
      await cargarPerfil();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Actualiza los datos del usuario en la tabla 'usuario' de Supabase
  Future<bool> actualizarPerfil({
    required String nombre,
    required String apellido,
    required double pesoKg,
    required double alturaCm,
    required String sexo,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      final sexoFormatted = sexo.trim().toUpperCase();

      final payload = {
        'nombre': nombre,
        'apellido': apellido,
        'peso_kg': pesoKg,
        'altura_cm': alturaCm.toInt(),
        'sexo': sexoFormatted,
        'email': user.email, // Incluimos el email para satisfacer la restricción NOT NULL
      };

      debugPrint('Actualizando tabla usuario con payload: $payload');

      // Usamos update filtrando por la ID del usuario
      final response = await Supabase.instance.client
          .from('usuario')
          .update(payload)
          .eq('id', user.id)
          .select();

      debugPrint('Respuesta actualización usuario: $response');

      // Recargamos el perfil actualizado desde la BD
      await cargarPerfil();
      return true;
    } catch (e) {
      debugPrint('Error al actualizar tabla usuario en Supabase: $e');
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cierra la sesión activa
  Future<void> cerrarSesion() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }
}
