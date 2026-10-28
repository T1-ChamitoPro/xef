import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_snack_bar.dart';
import '../../core/widgets/background_glow.dart';
import '../../providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreCtrl;
  late TextEditingController _apellidoCtrl;
  late TextEditingController _pesoCtrl;
  late TextEditingController _alturaCtrl;
  String _sexo = 'Masculino';

  @override
  void initState() {
    super.initState();
    final perfil = context.read<AuthProvider>().perfil;

    _nombreCtrl = TextEditingController(text: perfil?.nombre ?? '');
    _apellidoCtrl = TextEditingController(text: perfil?.apellido ?? '');
    _pesoCtrl = TextEditingController(text: perfil?.pesoKg.toString() ?? '');
    _alturaCtrl = TextEditingController(
      text: perfil?.alturaCm.toString() ?? '',
    );

    final sexoRaw = perfil?.sexo.trim().toLowerCase() ?? 'masculino';
    if (sexoRaw == 'femenino') {
      _sexo = 'Femenino';
    } else {
      _sexo = 'Masculino';
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _pesoCtrl.dispose();
    _alturaCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    final ok = await authProvider.actualizarPerfil(
      nombre: _nombreCtrl.text.trim(),
      apellido: _apellidoCtrl.text.trim(),
      pesoKg: double.parse(_pesoCtrl.text.trim()),
      alturaCm: double.parse(_alturaCtrl.text.trim()),
      sexo: _sexo,
    );

    if (!mounted) return;

    if (ok) {
      showAppSnackBar(context, message: '¡Datos guardados con éxito!');
      Navigator.pop(context);
    } else {
      showAppSnackBar(
        context,
        message:
            authProvider.errorMessage ??
            'Error al actualizar en la base de datos.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Editar Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const BackgroundGlow(opacity: 0.1),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.lightGreen.withValues(
                          alpha: 0.2,
                        ),
                        child: Text(
                          _nombreCtrl.text.isNotEmpty
                              ? _nombreCtrl.text[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightGreen,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            _nombreCtrl,
                            'Nombre',
                            Icons.person_outline,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            _apellidoCtrl,
                            'Apellido',
                            Icons.person_outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            _alturaCtrl,
                            'Altura (cm)',
                            Icons.height,
                            isNumber: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            _pesoCtrl,
                            'Peso (kg)',
                            Icons.fitness_center,
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _sexo,
                      dropdownColor: AppColors.cardBg,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Sexo',
                        labelStyle: const TextStyle(
                          color: AppColors.textSecondary,
                        ),
                        prefixIcon: const Icon(
                          Icons.wc,
                          color: AppColors.lightGreen,
                        ),
                        filled: true,
                        fillColor: AppColors.azureMist.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.azureMist.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Masculino',
                          child: Text('Masculino'),
                        ),
                        DropdownMenuItem(
                          value: 'Femenino',
                          child: Text('Femenino'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _sexo = val);
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightGreen,
                        foregroundColor: AppColors.background,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: authProvider.isLoading ? null : _guardar,
                      child: authProvider.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.background,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Guardar Cambios',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.lightGreen, size: 20),
        filled: true,
        fillColor: AppColors.azureMist.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.azureMist.withValues(alpha: 0.1),
          ),
        ),
      ),
    );
  }
}
