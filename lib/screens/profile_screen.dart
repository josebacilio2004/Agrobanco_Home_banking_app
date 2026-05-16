import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/agro_theme.dart';
import '../services/banking_services.dart';
import 'login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AgroTheme.backgroundCream,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Agrobanco',
          style: GoogleFonts.roboto(
            color: AgroTheme.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AgroTheme.primaryGreen,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded, color: AgroTheme.primaryGreen),
          ),
        ],
      ),
      body: userProfile.when(
        data: (user) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: Column(
            children: [
              _buildProfileHeader(user?.displayName ?? 'Juan Carlos Mamani Quispe', user?.dni ?? '45678912'),
              const SizedBox(height: 32),
              _buildSectionCard(
                items: [
                  _ProfileItem(icon: Icons.person_outline, title: 'Datos personales', trailing: Icons.expand_more_rounded),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('SEGURIDAD'),
              _buildSectionCard(
                items: [
                  _ProfileItem(icon: Icons.lock_outline, title: 'Cambiar clave'),
                  _ProfileItem(icon: Icons.fingerprint, title: 'Biometría', subtitle: 'Huella o rostro activo'),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('CONFIGURACIÓN'),
              _buildSectionCard(
                items: [
                  _ProfileItem(icon: Icons.notifications_none_rounded, title: 'Notificaciones'),
                  _ProfileItem(icon: Icons.text_fields_rounded, title: 'Tamaño de letra'),
                  _ProfileItem(icon: Icons.brightness_6_outlined, title: 'Tema'),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionCard(
                items: [
                  _ProfileItem(icon: Icons.chat_bubble_outline_rounded, title: 'WhatsApp Agrobanco', subtitle: 'Atención personalizada', trailing: Icons.open_in_new_rounded),
                  _ProfileItem(icon: Icons.description_outlined, title: 'Documentación'),
                ],
              ),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(authServiceProvider).signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  side: const BorderSide(color: AgroTheme.errorRed),
                  foregroundColor: AgroTheme.errorRed,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Cerrar sesión', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),
              Text(
                'Versión 2.4.1 (2024)',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildProfileHeader(String name, String dni) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 54,
          backgroundColor: AgroTheme.primaryGreen,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(Icons.person_rounded, size: 60, color: AgroTheme.primaryGreen),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AgroTheme.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'DNI: $dni',
          style: TextStyle(color: AgroTheme.textMuted, fontSize: 14),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFC8E6C9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_rounded, color: AgroTheme.primaryGreen, size: 16),
              const SizedBox(width: 8),
              Text(
                'Socio Verificado',
                style: TextStyle(
                  color: AgroTheme.primaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AgroTheme.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSectionCard({required List<_ProfileItem> items}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100, indent: 56),
        itemBuilder: (context, index) => ListTile(
          leading: Icon(items[index].icon, color: AgroTheme.textDark),
          title: Text(
            items[index].title,
            style: const TextStyle(fontWeight: FontWeight.w500, color: AgroTheme.textDark),
          ),
          subtitle: items[index].subtitle != null
              ? Text(items[index].subtitle!, style: TextStyle(color: AgroTheme.textMuted, fontSize: 12))
              : null,
          trailing: Icon(items[index].trailing ?? Icons.chevron_right_rounded, color: Colors.grey.shade400),
          onTap: () {},
        ),
      ),
    );
  }
}

class _ProfileItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final IconData? trailing;

  _ProfileItem({required this.icon, required this.title, this.subtitle, this.trailing});
}
