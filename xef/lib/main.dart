import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/home/main_wrapper.dart';
import 'providers/auth_provider.dart';
import 'providers/diet_provider.dart';
import 'providers/recipe_provider.dart';
import 'providers/routine_provider.dart';
import 'providers/historial_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://tlfrqdcablbptyanryvj.supabase.co',
    anonKey: 'sb_publishable_aIM05XQrCDnYkeJ726pgoQ_I2MUR-fQ',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DietProvider()),
        ChangeNotifierProvider(create: (_) => RoutineProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
        ChangeNotifierProvider(
          create: (_) => HistorialProvider()..cargarHistorialHoy(),
        ),
      ],
      child: const XefApp(),
    ),
  );
}

class XefApp extends StatelessWidget {
  const XefApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XEF',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.lightGreen),
            ),
          );
        }

        final session =
            snapshot.data?.session ??
            Supabase.instance.client.auth.currentSession;

        if (session != null) {
          return const MainWrapper();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
