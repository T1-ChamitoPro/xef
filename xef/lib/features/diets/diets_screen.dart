import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../services/ai_diet_service.dart';

class DietsScreen extends StatefulWidget {
  const DietsScreen({super.key});

  @override
  State<DietsScreen> createState() => _DietsScreenState();
}

class _DietsScreenState extends State<DietsScreen> {
  final _aiDietService = AIDietService();

  // Opciones de selección según el mockup
  final Set<String> _diasSeleccionados = {'LUNES', 'MIERCOLES', 'VIERNES'};
  String _objetivoSeleccionado = 'PERDIDA DE PESO';
  String _estiloVidaSeleccionado = 'SEDENTARIO';
  String _tipoDietaSeleccionada = 'BALANCEADA';
  final List<String> _intolerancias = ['LACTOSA', 'MANI', 'CEBOLLA'];
  final Set<String> _intoleranciasSeleccionadas = {'LACTOSA'};

  // Control de flujo
  int _currentStep = 0; // 0: Formulario, 1: Opciones de IA
  bool _isLoadingAI = false;
  bool _isSaving = false;

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
  final List<String> _objetivos = [
    'BIENESTAR GENERAL',
    'PERDIDA DE PESO',
    'GANANCIA MUSCULAR',
    'MANTENIMIENTO',
  ];

  Future<void> _generarDietaConIA() async {
    if (_diasSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona los días para tu dieta')),
      );
      return;
    }

    setState(() => _isLoadingAI = true);

    final resultados = await _aiDietService.generarDietasConIA(
      dias: _diasSeleccionados.toList(),
      objetivo: _objetivoSeleccionado,
      estiloVida: _estiloVidaSeleccionado,
      tipoDieta: _tipoDietaSeleccionada,
      intolerancias: _intoleranciasSeleccionadas.toList(),
    );

    setState(() {
      _sugerenciasIA = resultados;
      _opcionSeleccionadaIndex = 0;
      _isLoadingAI = false;
      _currentStep = 1;
    });
  }

  Future<void> _guardarDietaElegida() async {
    setState(() => _isSaving = true);
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Usuario no autenticado')));
      setState(() => _isSaving = false);
      return;
    }

    final dietaElegida = _sugerenciasIA[_opcionSeleccionadaIndex];

    try {
      await Supabase.instance.client.from('dieta').insert({
        'usuario_id': userId,
        'nombre': dietaElegida['titulo'] ?? 'Dieta Personalizada',
        'dias_semana': _diasSeleccionados.toList(),
        'info_nutricional': {
          'objetivo': _objetivoSeleccionado,
          'estilo_vida': _estiloVidaSeleccionado,
          'tipo_dieta': _tipoDietaSeleccionada,
          'intolerancias': _intoleranciasSeleccionadas.toList(),
          'menu': dietaElegida['menu'],
        },
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Dieta registrada exitosamente!')),
        );
        setState(() => _currentStep = 0);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar dieta: $e')));
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
                      'La IA está creando tus opciones de dieta...',
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

  // 1. Formulario del Generador de Dieta
  Widget _buildFormulario() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'GENERADOR DE DIETA',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 15),

          // Días de la semana
          Wrap(
            spacing: 6,
            runSpacing: 6,
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
                onSelected: (val) {
                  setState(() {
                    val
                        ? _diasSeleccionados.add(dia)
                        : _diasSeleccionados.remove(dia);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Objetivos
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'OBJETIVO',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
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
          const SizedBox(height: 20),

          // Estilo de Vida y Tipo de Dieta
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ESTILO DE VIDA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => setState(
                        () => _estiloVidaSeleccionado = 'SEDENTARIO',
                      ),
                      child: _buildOptionBox(
                        'SEDENTARIO',
                        _estiloVidaSeleccionado == 'SEDENTARIO',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TIPO DE DIETA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _tipoDietaSeleccionada = 'BALANCEADA'),
                      child: _buildOptionBox(
                        'BALANCEADA',
                        _tipoDietaSeleccionada == 'BALANCEADA',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Intolerancias
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'INTOLERANCIAS',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _intolerancias.map((item) {
              final selected = _intoleranciasSeleccionadas.contains(item);
              return FilterChip(
                label: Text(item),
                selected: selected,
                selectedColor: Colors.redAccent.shade100,
                backgroundColor: AppColors.cardBg,
                onSelected: (val) {
                  setState(() {
                    val
                        ? _intoleranciasSeleccionadas.add(item)
                        : _intoleranciasSeleccionadas.remove(item);
                  });
                },
              );
            }).toList(),
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
              onPressed: _generarDietaConIA,
              child: const Text(
                'GENERAR DIETA',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Opciones de Dieta Recomendadas por IA
  Widget _buildSugerenciasIA() {
    final dietaActual = _sugerenciasIA[_opcionSeleccionadaIndex];
    final menuMap = dietaActual['menu'] as Map<String, dynamic>;

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
                'FORMATO DE DIETA (IA)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),

        // Chips para cambiar de sugerencia
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

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dietaActual['titulo'] ?? 'Plan Alimenticio',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                if (dietaActual['descripcion'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    dietaActual['descripcion'],
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
                const SizedBox(height: 20),

                ...menuMap.entries.map((entry) {
                  final dia = entry.key;
                  final comidas = entry.value as Map<String, dynamic>;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dia,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.cardBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (comidas['desayuno'] != null)
                              Text(
                                'DES: ${comidas['desayuno']}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            const SizedBox(height: 6),
                            if (comidas['almuerzo'] != null)
                              Text(
                                'ALM: ${comidas['almuerzo']}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            const SizedBox(height: 6),
                            if (comidas['cena'] != null)
                              Text(
                                'CEN: ${comidas['cena']}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ),

        // Botón Registrar Dieta
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
                    onPressed: _guardarDietaElegida,
                    child: const Text(
                      'Registrar dieta',
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryDark : AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.accentGreen : Colors.black87,
          ),
        ),
      ),
    );
  }
}
