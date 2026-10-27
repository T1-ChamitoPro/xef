import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/background_glow.dart';
import '../../providers/historial_provider.dart';
import 'widgets/historial_dia_card.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistorialProvider>().cargarListaHistorial();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom + 110.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Historial de Registros',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const BackgroundGlow(opacity: 0.1),
          Consumer<HistorialProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.lightGreen),
                );
              }

              if (provider.listaHistorial.isEmpty) {
                return const Center(
                  child: Text(
                    'No tienes registros finalizados en el historial.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 12,
                  bottom: bottomPadding,
                ),
                itemCount: provider.listaHistorial.length,
                itemBuilder: (context, index) {
                  final dia = provider.listaHistorial[index];
                  return HistorialDiaCard(dia: dia);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
