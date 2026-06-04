import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/agro_theme.dart';
import '../theme/glass_widgets.dart';
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
      body: GlassBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.agriculture_rounded, color: AgroTheme.primaryGreen, size: 44),
                          const SizedBox(width: 12),
                          Text(
                            'Agrobanco',
                            style: GoogleFonts.roboto(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: AgroTheme.primaryGreen,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Banca Móvil Rural',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        color: AgroTheme.textMuted,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 36),
                    GlassCard(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Bienvenido',
                            style: GoogleFonts.roboto(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AgroTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Ingresa tus credenciales para acceder a tu banca móvil.',
                            style: TextStyle(color: AgroTheme.textMuted, fontSize: 13.5, height: 1.4),
                          ),
                          const SizedBox(height: 28),
                          _buildLabel('Correo electrónico'),
                          GlassTextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            hintText: 'ejemplo@agrobanco.pe',
                            prefixIcon: const Icon(Icons.email_outlined, size: 20),
                          ),
                          const SizedBox(height: 20),
                          _buildLabel('Contraseña'),
                          GlassTextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            hintText: '••••••••',
                            prefixIcon: const Icon(Icons.lock_outline, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              child: const Text('¿Olvidaste tu contraseña?', style: TextStyle(color: AgroTheme.primaryGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (_isLoading)
                            const Center(child: CircularProgressIndicator(color: AgroTheme.primaryGreen))
                          else ...[
                            GlassButton(
                              text: 'Iniciar sesión',
                              onPressed: _handleLogin,
                            ),
                            const SizedBox(height: 16),
                            GlassButton(
                              text: 'Acceso Demo (Auto-Seed)',
                              onPressed: _handleDemoLogin,
                              isSecondary: true,
                              icon: Icons.flash_on_rounded,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿No tienes cuenta?', style: TextStyle(color: AgroTheme.textDark, fontWeight: FontWeight.w500)),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Regístrate aquí', style: TextStyle(color: AgroTheme.primaryGreen, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
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

