import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/home/main_wrapper.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://tlfrqdcablbptyanryvj.supabase.co',
    anonKey: 'sb_publishable_aIM05XQrCDnYkeJ726pgoQ_I2MUR-fQ',
  );
  runApp(const XefApp());
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
            backgroundColor: Color(0xFF000F4F),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF00FF19)),
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
