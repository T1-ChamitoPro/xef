import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _supabase = Supabase.instance.client;
  Map<String, dynamic>? _perfil;
  Map<String, dynamic>? _dietaActiva;
  Map<String, dynamic>? _rutinaActiva;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosDashboard();
  }

  Future<void> _cargarDatosDashboard() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final perfilData = await _supabase
          .from('usuario')
          .select()
          .eq('id', userId)
          .maybeSingle();
      final dietaData = await _supabase
          .from('dieta')
          .select()
          .eq('usuario_id', userId)
          .order('id', ascending: false)
          .limit(1)
          .maybeSingle();
      final rutinaData = await _supabase
          .from('rutina')
          .select()
          .eq('usuario_id', userId)
          .order('id', ascending: false)
          .limit(1)
          .maybeSingle();

      if (mounted) {
        setState(() {
          _perfil = perfilData;
          _dietaActiva = dietaData;
          _rutinaActiva = rutinaData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accentGreen),
        ),
      );
    }

    final nombre =
        '${_perfil?['nombre'] ?? 'USUARIO'} ${_perfil?['apellido'] ?? ''}'
            .toUpperCase();
    final sexo = (_perfil?['sexo'] ?? 'NO ESPECIFICADO')
        .toString()
        .toUpperCase();
    final altura = _perfil?['altura_cm'] ?? 170;
    final peso = (_perfil?['peso_kg'] ?? 70.0).toDouble();

    final imc = peso / ((altura / 100) * (altura / 100));
    final imcString = imc.toStringAsFixed(1);

    // Menú de la Dieta
    Map<String, dynamic> menuHoy = {};
    if (_dietaActiva != null && _dietaActiva!['info_nutricional'] != null) {
      final info = _dietaActiva!['info_nutricional'];
      if (info['menu'] != null && info['menu']['LUNES'] != null) {
        menuHoy = Map<String, dynamic>.from(info['menu']['LUNES']);
      }
    }

    // Ejercicios de la Rutina
    List<dynamic> ejerciciosHoy = [];
    if (_rutinaActiva != null && _rutinaActiva!['info_fisica'] != null) {
      final infoFisica = _rutinaActiva!['info_fisica'];
      if (infoFisica['ejercicios'] != null &&
          infoFisica['ejercicios']['LUNES'] != null) {
        ejerciciosHoy = List<dynamic>.from(infoFisica['ejercicios']['LUNES']);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.accentGreen,
          backgroundColor: AppColors.cardBg,
          onRefresh: _cargarDatosDashboard,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Perfil
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.accentGreen.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.accentGreen,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primaryDark,
                          child: Text(
                            nombre.isNotEmpty ? nombre[0] : 'U',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentGreen,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nombre,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accentGreen.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                sexo,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accentGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Tarjeta de Salud / IMC
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.cardBg, AppColors.cardBgLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.accentGreen.withOpacity(0.4),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ÍNDICE DE MASA CORPORAL',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'IMC: $imcString',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accentGreen,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'SALUDABLE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Altura: $altura cm',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            'Peso: ${peso.toStringAsFixed(0)} kg',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // Seccion Dieta
                _buildSectionHeader('Dieta activa', Icons.restaurant_menu),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.accentGreen.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _dietaActiva?['nombre'] ?? 'Sin Dieta Registrada',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.accentGreen,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildMealRow('Desayuno', menuHoy['desayuno']),
                      _buildMealRow('Almuerzo', menuHoy['almuerzo']),
                      _buildMealRow('Cena', menuHoy['cena']),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // Seccion Rutina
                _buildSectionHeader('Rutina de hoy', Icons.fitness_center),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.accentGreen.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: ejerciciosHoy.isNotEmpty
                        ? ejerciciosHoy
                              .map(
                                (ej) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle_outline,
                                        size: 18,
                                        color: AppColors.accentGreen,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          ej.toString(),
                                          style: const TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList()
                        : [
                            const Text(
                              'No hay ejercicios programados para hoy.',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accentGreen, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildMealRow(String tipo, String? plato) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$tipo:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              plato ?? 'Sin asignar',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
