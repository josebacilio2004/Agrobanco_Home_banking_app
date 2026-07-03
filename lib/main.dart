import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme/agro_theme.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: AgrobancoApp(),
    ),
  );
}

class AgrobancoApp extends StatelessWidget {
  const AgrobancoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agrobanco Home Banking',
      debugShowCheckedModeBanner: false,
      theme: AgroTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
