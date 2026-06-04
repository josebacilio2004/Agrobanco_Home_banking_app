import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/agro_theme.dart';
import '../theme/glass_widgets.dart';
import '../services/banking_services.dart';
import '../models/banking_models.dart';

class SavingsScreen extends ConsumerStatefulWidget {
  const SavingsScreen({super.key});

  @override
  ConsumerState<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends ConsumerState<SavingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountsProvider);
    final transactions = ref.watch(transactionsProvider);

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
      body: GlassBackground(
        child: Column(
          children: [
            _buildSegmentedTabs(),
            Expanded(
              child: accounts.when(
                data: (accs) {
                  final savings = accs.where((a) => a.type == AccountType.savings).firstOrNull;
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBalanceCard(context, savings?.balance ?? 0.0),
                        const SizedBox(height: 28),
                        _buildGenerateDepositCode(),
                        const SizedBox(height: 28),
                        _buildMovementsHeader(),
                        const SizedBox(height: 16),
                        transactions.when(
                          data: (txs) => _buildMovementsList(txs),
                          loading: () => const Center(child: CircularProgressIndicator(color: AgroTheme.primaryGreen)),
                          error: (e, _) => Text('Error: $e'),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: AgroTheme.primaryGreen)),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedTabs() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GlassCard(
        borderRadius: 12,
        backgroundOpacity: 0.35,
        padding: const EdgeInsets.all(4),
        customShadow: const [],
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: Colors.white.withOpacity(0.55),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          labelColor: AgroTheme.textDark,
          unselectedLabelColor: AgroTheme.textMuted,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Ahorro Principal'),
            Tab(text: 'Ahorro Semilla'),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, double balance) {
    return GlassCard(
      borderRadius: 20,
      backgroundOpacity: 0.5,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Saldo disponible', style: TextStyle(color: AgroTheme.textMuted, fontSize: 14, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFC8E6C9).withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.trending_up, color: AgroTheme.primaryGreen, size: 14),
                    SizedBox(width: 4),
                    Text('Ganas 2.5% E.A.', style: TextStyle(color: AgroTheme.primaryGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'S/ ${balance.toStringAsFixed(2)}',
            style: GoogleFonts.roboto(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AgroTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: GlassButton(
                  text: 'Depositar',
                  icon: Icons.add_circle_outline,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.history, size: 18),
                  label: const Text('Historial', style: TextStyle(fontSize: 15)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF8B5E3C),
                    side: const BorderSide(color: Color(0xFF8B5E3C), width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size.fromHeight(54),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateDepositCode() {
    return GlassCard(
      borderRadius: 20,
      backgroundOpacity: 0.45,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Generar código de depósito',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AgroTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 20),
          const Text('Monto a depositar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AgroTheme.textDark)),
          const SizedBox(height: 8),
          GlassTextField(
            controller: _amountController,
            hintText: '0.00',
            keyboardType: TextInputType.number,
            prefixIcon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('S/', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AgroTheme.primaryGreen)),
            ),
          ),
          const SizedBox(height: 20),
          GlassButton(
            text: 'Generar QR Dinámico',
            icon: Icons.qr_code_2_rounded,
            isSecondary: true,
            onPressed: () {},
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Válido en cualquier Agente Agrobanco o banca móvil.',
              style: TextStyle(color: AgroTheme.textMuted, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Últimos movimientos',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AgroTheme.primaryGreen,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Row(
            children: const [
              Text('Mayo', style: TextStyle(fontWeight: FontWeight.bold, color: AgroTheme.textDark)),
              Icon(Icons.expand_more, color: AgroTheme.textDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMovementsList(List<TransactionModel> txs) {
    return GlassCard(
      borderRadius: 20,
      backgroundOpacity: 0.45,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ...txs.take(3).map((tx) => _buildMovementTile(tx)),
          const Divider(height: 24, color: Colors.white24),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('Ver todos los movimientos', style: TextStyle(color: AgroTheme.primaryGreen, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementTile(TransactionModel tx) {
    final isCredit = tx.isCredit;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCredit ? const Color(0xFFC8E6C9).withOpacity(0.7) : const Color(0xFFFFEBEE).withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCredit ? Icons.account_balance_wallet_outlined : Icons.swap_horiz_rounded,
              color: isCredit ? AgroTheme.primaryGreen : Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AgroTheme.textDark, fontSize: 14)),
                const SizedBox(height: 2),
                Text('${tx.date.day} Mayo 2024', style: const TextStyle(color: AgroTheme.textMuted, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Text(
            '${isCredit ? "+" : "-"} S/ ${tx.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isCredit ? AgroTheme.primaryGreen : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

