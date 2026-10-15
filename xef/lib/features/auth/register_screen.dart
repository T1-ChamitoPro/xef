import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _alturaController = TextEditingController();
  final _pesoController = TextEditingController();

  String _sexoSeleccionado = 'Masculino';
  final List<String> _opcionesSexo = ['Masculino', 'Femenino', 'Otro'];

  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    final nombre = _nombreController.text.trim();
    final apellido = _apellidoController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final alturaText = _alturaController.text.trim();
    final pesoText = _pesoController.text.trim();

    if (nombre.isEmpty ||
        apellido.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        alturaText.isEmpty ||
        pesoText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos')),
      );
      return;
    }

    final alturaCm = int.tryParse(alturaText);
    final pesoKg = double.tryParse(pesoText);

    if (alturaCm == null || pesoKg == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingresa valores válidos para altura y peso'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.registrarUsuario(
        email: email,
        password: password,
        nombre: nombre,
        apellido: apellido,
        alturaCm: alturaCm,
        pesoKg: pesoKg,
        sexo: _sexoSeleccionado,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Registro exitoso! Iniciando sesión...'),
          ),
        );
        Navigator.of(context).pop(); // Regresa al Login / AuthGate
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error en el registro: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.accentGreen,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              const Text(
                'Crear Perfil',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ingresa tus datos físicos para personalizar tu experiencia con IA.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 30),

              // Campo: Nombre y Apellido
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nombreController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Nombre',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: AppColors.accentGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _apellidoController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Apellido',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: AppColors.accentGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Campo: Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Correo electrónico',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColors.accentGreen,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Campo: Contraseña
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Contraseña',
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: AppColors.accentGreen,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Campos Métricos: Altura y Peso
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _alturaController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Altura (cm)',
                        prefixIcon: Icon(
                          Icons.height,
                          color: AppColors.accentGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _pesoController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Peso (kg)',
                        prefixIcon: Icon(
                          Icons.scale_outlined,
                          color: AppColors.accentGreen,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Selector de Sexo Biológico (para el cálculo de métricas e IMC)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.accentGreen.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wc, color: AppColors.accentGreen),
                    const SizedBox(width: 12),
                    const Text(
                      'Sexo:',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _sexoSeleccionado,
                          dropdownColor: AppColors.cardBg,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.accentGreen,
                          ),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() => _sexoSeleccionado = newValue);
                            }
                          },
                          items: _opcionesSexo.map<DropdownMenuItem<String>>((
                            String value,
                          ) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),

              // Botones de Acción
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: AppColors.accentGreen,
                        )
                      : const Text('REGISTRARME'),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
