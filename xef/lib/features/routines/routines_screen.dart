import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../services/ai_routine_service.dart';

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({super.key});

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  final _aiService = AIRoutineService();

  // Selección de formulario
  final Set<String> _diasSeleccionados = {'LUNES', 'MIERCOLES', 'VIERNES'};
  String _modalidadSeleccionada = 'En casa';
  String _objetivoSeleccionado = 'Quemar calorías';

  // Control de flujo
  int _currentStep = 0; // 0: Formulario, 1: Visualizador/Selección de IA
  bool _isLoadingAI = false;
  bool _isSaving = false;

  // Opciones generadas por IA
  List<Map<String, dynamic>> _sugerenciasIA = [];
  int _opcionSeleccionadaIndex = 0;

  final List<String> _diasSemana = [
    'LUNES',
    'MARTES',
    'MIERCOLES',
    'JUEVES',
    'VIERNES',
    'SABADO',
    'DOMINGO',
  ];
  final List<String> _modalidades = ['En casa', 'Gimnasio', 'Al aire libre'];
  final List<String> _objetivos = [
    'Bajar de peso',
    'Quemar calorías',
    'Definición',
    'Ganar músculo',
  ];

  Future<void> _generarRutinasConIA() async {
    if (_diasSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un día de entreno')),
      );
      return;
    }

    setState(() => _isLoadingAI = true);

    final resultados = await _aiService.generarRutinasConIA(
      dias: _diasSeleccionados.toList(),
      modalidad: _modalidadSeleccionada,
      objetivo: _objetivoSeleccionado,
    );

    setState(() {
      _sugerenciasIA = resultados;
      _opcionSeleccionadaIndex = 0;
      _isLoadingAI = false;
      _currentStep = 1;
    });
  }

  Future<void> _guardarRutinaElegida() async {
    setState(() => _isSaving = true);
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Usuario no autenticado')));
      setState(() => _isSaving = false);
      return;
    }

    final rutinaElegida = _sugerenciasIA[_opcionSeleccionadaIndex];

    try {
      await Supabase.instance.client.from('rutina').insert({
        'usuario_id': userId,
        'nombre': rutinaElegida['titulo'] ?? 'Rutina Personalizada',
        'dias_semana': _diasSeleccionados.toList(),
        'tiempo_estimado_min': 40,
        'info_fisica': {
          'modalidad': _modalidadSeleccionada,
          'objetivo': _objetivoSeleccionado,
          'descripcion': rutinaElegida['descripcion'],
          'ejercicios': rutinaElegida['ejercicios'],
        },
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Rutina guardada en tu perfil!')),
        );
        setState(() => _currentStep = 0);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar rutina: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isLoadingAI
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(color: AppColors.primaryDark),
                    SizedBox(height: 20),
                    Text(
                      'La IA está diseñando tus opciones de rutina...',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : (_currentStep == 0 ? _buildFormulario() : _buildSugerenciasIA()),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. FORMULARIO DE GENERACIÓN
  // ---------------------------------------------------------------------------
  Widget _buildFormulario() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'GENERADOR DE RUTINA',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 20),

          // Selección de Días
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _diasSemana.map((dia) {
              final selected = _diasSeleccionados.contains(dia);
              return FilterChip(
                label: Text(dia.substring(0, 3)),
                selected: selected,
                selectedColor: AppColors.accentGreen,
                backgroundColor: AppColors.cardBg,
                labelStyle: TextStyle(
                  color: selected ? AppColors.primaryDark : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
                onSelected: (bool value) {
                  setState(() {
                    if (value) {
                      _diasSeleccionados.add(dia);
                    } else {
                      _diasSeleccionados.remove(dia);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 25),

          // Modalidad
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Modalidad de la rutina',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: _modalidades.map((mod) {
              final selected = _modalidadSeleccionada == mod;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _modalidadSeleccionada = mod),
                  child: _buildOptionBox(mod, selected),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Objetivos
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Objetivos de la rutina',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _objetivos.length,
            itemBuilder: (context, index) {
              final obj = _objetivos[index];
              final selected = _objetivoSeleccionado == obj;
              return GestureDetector(
                onTap: () => setState(() => _objetivoSeleccionado = obj),
                child: _buildOptionBox(obj, selected),
              );
            },
          ),
          const SizedBox(height: 30),

          SizedBox(
            width: 220,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: AppColors.accentGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _generarRutinasConIA,
              child: const Text(
                'Generar rutina',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. SUGERENCIAS DE LA IA
  // ---------------------------------------------------------------------------
  Widget _buildSugerenciasIA() {
    final rutinaActual = _sugerenciasIA[_opcionSeleccionadaIndex];
    final ejerciciosMap = rutinaActual['ejercicios'] as Map<String, dynamic>;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.primaryDark,
                ),
                onPressed: () => setState(() => _currentStep = 0),
              ),
              const Text(
                'FORMATO DE RUTINA (IA)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),

        // Tabs de opciones
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(_sugerenciasIA.length, (index) {
              final isSelected = _opcionSeleccionadaIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text('Opción ${index + 1}'),
                  selected: isSelected,
                  selectedColor: AppColors.accentGreen,
                  backgroundColor: AppColors.cardBg,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primaryDark : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (_) =>
                      setState(() => _opcionSeleccionadaIndex = index),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 15),

        // Detalle de ejercicios por día
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rutinaActual['titulo'] ?? 'Rutina Recomendada',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                if (rutinaActual['descripcion'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    rutinaActual['descripcion'],
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
                const SizedBox(height: 20),

                ...ejerciciosMap.entries.map((entry) {
                  final dia = entry.key;
                  final listaEjercicios = List<String>.from(entry.value);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dia,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: listaEjercicios
                              .map(
                                (ej) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 3,
                                  ),
                                  child: Text(
                                    '• $ej',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ),

        // Botón Registrar
        Container(
          padding: const EdgeInsets.all(20),
          child: _isSaving
              ? const CircularProgressIndicator(color: AppColors.primaryDark)
              : SizedBox(
                  width: 240,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: AppColors.accentGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _guardarRutinaElegida,
                    child: const Text(
                      'Registrar rutina',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildOptionBox(String text, bool isSelected) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryDark : AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.accentGreen : Colors.black87,
          ),
        ),
      ),
    );
  }
}
