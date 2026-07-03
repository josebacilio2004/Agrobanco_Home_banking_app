import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/agro_theme.dart';
import '../theme/glass_widgets.dart';
import '../services/banking_services.dart';
import '../models/banking_models.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final accounts = ref.watch(accountsProvider);
    final transactions = ref.watch(transactionsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GlassBackground(
        child: Column(
          children: [
            _buildSyncBar(),
            Expanded(
              child: SafeArea(
                top: false,
                child: userProfile.when(
                  data: (user) => SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildHeader(context),
                        const SizedBox(height: 24),
                        Text(
                          '¡Buenos días, ${user?.displayName ?? 'Cliente'}!',
                          style: GoogleFonts.roboto(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AgroTheme.textDark,
                          ),
                        ),
                        Text(
                          _getFormattedDate(),
                          style: const TextStyle(color: AgroTheme.textMuted, fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 24),
                        accounts.when(
                          data: (accs) => _buildPremiumBalanceCard(context, accs),
                          loading: () => const _LoadingSkeleton(height: 180),
                          error: (e, _) => _ErrorCard(error: e.toString()),
                        ),
                        const SizedBox(height: 24),
                        _buildQuickActions(context),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Últimos movimientos',
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AgroTheme.textDark,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Ver todo', style: TextStyle(color: AgroTheme.primaryGreen, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        transactions.when(
                          data: (txs) => _buildMovementsList(context, txs),
                          loading: () => const _LoadingSkeleton(height: 100),
                          error: (e, _) => _ErrorCard(error: e.toString()),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator(color: AgroTheme.primaryGreen)),
                  error: (e, _) => Center(child: Text('Error: $e')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncBar() {
    return Container(
      width: double.infinity,
      color: Colors.black.withOpacity(0.03),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 14, color: AgroTheme.textMuted),
            const SizedBox(width: 8),
            Text(
              'Sin conexión - Datos actualizados hace 5 min.',
              style: TextStyle(color: AgroTheme.textMuted.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AgroTheme.primaryGreen.withOpacity(0.1),
          child: const Icon(Icons.person, color: AgroTheme.primaryGreen),
        ),
        Text(
          'Agrobanco',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AgroTheme.primaryGreen,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded, color: AgroTheme.primaryGreen),
        ),
      ],
    );
  }

  Widget _buildPremiumBalanceCard(BuildContext context, List<Account> accounts) {
    final savings = accounts.where((a) => a.type == AccountType.savings).fold(0.0, (sum, item) => sum + item.balance);
    final total = savings;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AgroTheme.balanceGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AgroTheme.primaryGreen.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saldo total disponible',
                style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Icon(Icons.visibility_outlined, color: Colors.white.withOpacity(0.85), size: 22),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'S/ ${total.toStringAsFixed(2)}',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.15),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: GlassButton(
                  text: 'Cargar saldo',
                  isSecondary: true,
                  height: 48,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.3), width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text('Detalle', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _QuickActionItem(icon: Icons.savings_outlined, label: 'Ahorros', color: AgroTheme.iconBgOrange)),
            const SizedBox(width: 12),
            Expanded(child: _QuickActionItem(icon: Icons.description_outlined, label: 'Créditos', color: AgroTheme.iconBgGreen)),
            const SizedBox(width: 12),
            Expanded(child: _QuickActionItem(icon: Icons.swap_horiz_rounded, label: 'Transferir', color: AgroTheme.iconBgBlue)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _QuickActionItem(icon: Icons.qr_code_scanner_rounded, label: 'Pagar', color: AgroTheme.iconBgGreen)),
            const SizedBox(width: 12),
            Expanded(child: _QuickActionItem(icon: Icons.help_outline_rounded, label: 'Soporte', color: AgroTheme.iconBgPurple)),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox()), // Empty spacer to keep layout
          ],
        ),
      ],
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    final days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return '${days[now.weekday - 1]}, ${now.day} de ${months[now.month - 1]} ${now.year}';
  }

  Widget _buildMovementsList(BuildContext context, List<TransactionModel> transactions) {
    if (transactions.isEmpty) {
      return const Center(child: Text('No hay movimientos recientes'));
    }
    return Column(
      children: transactions.map((tx) => _MovementCard(tx: tx)).toList(),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final double? width;

  const _QuickActionItem({required this.icon, required this.label, required this.color, this.width});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 16,
      backgroundOpacity: 0.5,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: SizedBox(
        width: width,
        height: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.85),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AgroTheme.primaryGreen, size: 22),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AgroTheme.textDark),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovementCard extends StatelessWidget {
  final TransactionModel tx;

  const _MovementCard({required this.tx});

  @override
  Widget build(BuildContext context) {
    final bool isCredit = tx.isCredit;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        borderRadius: 16,
        backgroundOpacity: 0.45,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        customShadow: const [],
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCredit ? const Color(0xFFE8F5E9).withOpacity(0.7) : const Color(0xFFFFEBEE).withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCredit ? Icons.account_balance_wallet_outlined : Icons.payment_outlined,
                color: isCredit ? AgroTheme.primaryGreen : AgroTheme.errorRed,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.title,
                    style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 15, color: AgroTheme.textDark),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${tx.date.day} ${_getMonth(tx.date.month)} - ${_formatTime(tx.date)}',
                    style: const TextStyle(color: AgroTheme.textMuted, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Text(
              '${isCredit ? "+" : "-"} S/ ${tx.amount.toStringAsFixed(2)}',
              style: GoogleFonts.roboto(
                color: isCredit ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final ampm = date.hour >= 12 ? 'PM' : 'AM';
    return '${hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $ampm';
  }

  String _getMonth(int month) {
    const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return months[month - 1];
  }
}

class _LoadingSkeleton extends StatelessWidget {
  final double height;
  const _LoadingSkeleton({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(child: CircularProgressIndicator(color: AgroTheme.primaryGreen)),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String error;
  const _ErrorCard({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(height: 8),
          Text(
            'Error al cargar datos: $error',
            style: const TextStyle(color: Colors.red, fontSize: 12),
            textAlign: TextAlign.center,
          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Verifica tu conexión e intenta de nuevo.',
                            style: TextStyle(color: Colors.red, fontSize: 10, fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
        ],
      ),
    );
  }
}

