import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/agro_theme.dart';
import '../services/banking_services.dart';
import '../utils/seed_data.dart';
import 'main_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'demo@agrobanco.pe');
  final _passwordController = TextEditingController(text: 'password123');
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    try {
      final auth = ref.read(authServiceProvider);
      await auth.signIn(_emailController.text, _passwordController.text);
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AgroTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleDemoLogin() async {
    setState(() => _isLoading = true);
    try {
      final auth = FirebaseAuth.instance;
      try {
        await auth.signInWithEmailAndPassword(
          email: 'demo@agrobanco.pe',
          password: 'password123',
        );
      } catch (e) {
        await auth.createUserWithEmailAndPassword(
          email: 'demo@agrobanco.pe',
          password: 'password123',
        );
        await SeedData.seedDemoData();
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error Demo: ${e.toString()}'),
            backgroundColor: AgroTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.agriculture_rounded, color: AgroTheme.primaryGreen, size: 40),
                    const SizedBox(width: 12),
                    Text(
                      'Agrobanco',
                      style: GoogleFonts.roboto(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AgroTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Banca Móvil Rural',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: AgroTheme.textMuted,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(flex: 1),
              Text(
                'Bienvenido',
                style: GoogleFonts.roboto(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AgroTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ingresa tus credenciales para acceder a tu banca móvil.',
                style: TextStyle(color: AgroTheme.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 48),
              _buildLabel('Correo electrónico'),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'ejemplo@agrobanco.pe',
                  prefixIcon: Icon(Icons.email_outlined, size: 20),
                ),
              ),
              const SizedBox(height: 24),
              _buildLabel('Contraseña'),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('¿Olvidaste tu contraseña?', style: TextStyle(color: AgroTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const Center(child: CircularProgressIndicator(color: AgroTheme.primaryGreen))
              else ...[
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text('Iniciar sesión'),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: _handleDemoLogin,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AgroTheme.secondaryYellow),
                    foregroundColor: AgroTheme.textDark,
                    backgroundColor: AgroTheme.secondaryYellow.withOpacity(0.1),
                  ),
                  child: const Text('Acceso Demo (Auto-Seed)', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
              const Spacer(flex: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿No tienes cuenta?'),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Regístrate aquí', style: TextStyle(color: AgroTheme.primaryGreen, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AgroTheme.textDark),
      ),
    );
  }
}
