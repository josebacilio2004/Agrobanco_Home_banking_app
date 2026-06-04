import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/agro_theme.dart';
import '../theme/glass_widgets.dart';
import '../services/banking_services.dart';
import '../models/banking_models.dart';

class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AgroTheme.secondaryYellow,
        foregroundColor: AgroTheme.textDark,
        icon: const Icon(Icons.payments_outlined, fontWeight: FontWeight.bold),
        label: const Text('Pagar cuota', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: GlassBackground(
        child: accounts.when(
          data: (accs) {
            final loan = accs.where((a) => a.type == AccountType.loan).firstOrNull;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mis Créditos',
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AgroTheme.primaryGreen,
                    ),
                  ),
                  const Text(
                    'Gestiona tus préstamos y mantente al día con tus pagos.',
                    style: TextStyle(color: AgroTheme.textMuted, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 24),
                  _buildTotalDebtCard(loan?.balance ?? 35200.0),
                  const SizedBox(height: 16),
                  _buildNextPaymentCard(),
                  const SizedBox(height: 32),
                  const Text(
                    'PRÉSTAMOS ACTIVOS',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AgroTheme.textMuted),
                  ),
                  const SizedBox(height: 16),
                  _buildLoanItem(
                    title: 'Crédito Agrícola',
                    subtitle: 'Vence: 15/12/2026 • 12 cuotas restantes',
                    icon: Icons.agriculture_rounded,
                    iconColor: const Color(0xFFC8E6C9),
                  ),
                  const SizedBox(height: 12),
                  _buildLoanItem(
                    title: 'Crédito Maquinaria',
                    subtitle: 'Contrato: #8829-AGRO',
                    icon: Icons.handyman_rounded,
                    iconColor: const Color(0xFFFFE0B2),
                    isExpanded: true,
                  ),
                  const SizedBox(height: 32),
                  _buildPromoBanner(),
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: AgroTheme.primaryGreen)),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }

  Widget _buildTotalDebtCard(double debt) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AgroTheme.balanceGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AgroTheme.primaryGreen.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Total de deuda', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
              Icon(Icons.account_balance_outlined, color: Colors.white70, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'S/ ${debt.toStringAsFixed(2)}',
            style: GoogleFonts.roboto(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextPaymentCard() {
    return GlassCard(
      borderRadius: 16,
      backgroundOpacity: 0.5,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Próxima cuota', style: TextStyle(color: AgroTheme.textMuted, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                const Text('30/05/2026', style: TextStyle(color: Color(0xFF8B5E3C), fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'S/ 1,250.00',
                  style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold, color: AgroTheme.textDark),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AgroTheme.secondaryYellow.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.calendar_month_outlined, color: Color(0xFF8B5E3C), size: 26),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    bool isExpanded = false,
  }) {
    return GlassCard(
      borderRadius: 16,
      backgroundOpacity: isExpanded ? 0.65 : 0.45,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: iconColor.withOpacity(0.8), shape: BoxShape.circle),
                child: Icon(icon, color: AgroTheme.textDark, size: 20),
              ),
              title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AgroTheme.textDark)),
              subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AgroTheme.textMuted, fontWeight: FontWeight.w500)),
              trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: AgroTheme.textMuted),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: Colors.white30),
            _buildScheduleTable(),
          ],
        ],
      ),
    );
  }

  Widget _buildScheduleTable() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Cronograma de Pagos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Row(
                children: [
                  Icon(Icons.download_rounded, size: 14, color: AgroTheme.textDark),
                  SizedBox(width: 4),
                  Text('PDF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTableHeader(),
          _buildTableRow('04', '30/03/2026', '980.00', '270.00', 'PAGADO', const Color(0xFFC8E6C9).withOpacity(0.8), Colors.green.shade800),
          _buildTableRow('05', '30/04/2026', '980.00', '270.00', 'PAGADO', const Color(0xFFC8E6C9).withOpacity(0.8), Colors.green.shade800),
          _buildTableRow('06', '30/05/2026', '980.00', '270.00', 'PENDIENTE', const Color(0xFFFFE0B2).withOpacity(0.8), Colors.orange.shade800, isHighlighted: true),
          _buildTableRow('07', '30/06/2026', '980.00', '270.00', 'PRÓXIMO', Colors.white.withOpacity(0.3), AgroTheme.textMuted),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: const [
          SizedBox(width: 40, child: Text('# Cuota', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AgroTheme.textMuted))),
          Expanded(child: Text('Fecha', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AgroTheme.textMuted))),
          Expanded(child: Text('Capital', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AgroTheme.textMuted))),
          Expanded(child: Text('Interés', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AgroTheme.textMuted))),
          SizedBox(width: 70, child: Text('Estado', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AgroTheme.textMuted), textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildTableRow(String n, String date, String cap, String int, String status, Color bgColor, Color textColor, {bool isHighlighted = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.white.withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(width: 32, child: Text(n, style: TextStyle(fontSize: 12, fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal))),
          Expanded(child: Text(date, style: TextStyle(fontSize: 11, fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal))),
          Expanded(child: Text('S/ $cap', style: const TextStyle(fontSize: 11))),
          Expanded(child: Text('S/ $int', style: const TextStyle(fontSize: 11))),
          Container(
            width: 70,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4)),
            child: Text(status, style: TextStyle(color: textColor, fontSize: 9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.65)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              '¿Necesitas renovar maquinaria?',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
            ),
            const SizedBox(height: 4),
            const Text(
              'Descubre nuestras tasas preferenciales para la campaña 2026.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 14),
            GlassButton(
              text: 'Más información',
              isSecondary: true,
              height: 38,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
