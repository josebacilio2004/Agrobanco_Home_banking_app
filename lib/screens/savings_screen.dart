import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/agro_theme.dart';
import '../services/banking_services.dart';
import '../models/banking_models.dart';

class SavingsScreen extends ConsumerStatefulWidget {
  const SavingsScreen({super.key});

  @override
  ConsumerState<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends ConsumerState<SavingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountsProvider);
    final transactions = ref.watch(transactionsProvider);

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
      body: Column(
        children: [
          _buildSegmentedTabs(),
          Expanded(
            child: accounts.when(
              data: (accs) {
                final savings = accs.where((a) => a.type == AccountType.savings).firstOrNull;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBalanceCard(context, savings?.balance ?? 0.0),
                      const SizedBox(height: 32),
                      _buildGenerateDepositCode(),
                      const SizedBox(height: 32),
                      _buildMovementsHeader(),
                      const SizedBox(height: 16),
                      transactions.when(
                        data: (txs) => _buildMovementsList(txs),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (e, _) => Text('Error: $e'),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedTabs() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: AgroTheme.textDark,
        unselectedLabelColor: AgroTheme.textMuted,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: 'Ahorro Principal'),
          Tab(text: 'Ahorro Semilla'),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, double balance) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: const Border(left: BorderSide(color: AgroTheme.primaryGreen, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Saldo disponible', style: TextStyle(color: AgroTheme.textMuted, fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFC8E6C9),
                  borderRadius: BorderRadius.circular(12),
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
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Depositar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AgroTheme.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.history),
                  label: const Text('Historial'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF8B5E3C),
                    side: const BorderSide(color: Color(0xFF8B5E3C)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    minimumSize: const Size.fromHeight(52),
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
    return Column(
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
        const Text('Monto a depositar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            prefixIcon: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('S/', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            hintText: '0.00',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.qr_code_2_rounded),
          label: const Text('Generar QR Dinámico'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AgroTheme.secondaryYellow,
            foregroundColor: AgroTheme.textDark,
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Válido en cualquier Agente Agrobanco o banca móvil.',
            style: TextStyle(color: AgroTheme.textMuted, fontSize: 12),
          ),
        ),
      ],
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: const [
              Text('Mayo', style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.expand_more),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMovementsList(List<TransactionModel> txs) {
    return Column(
      children: [
        ...txs.take(3).map((tx) => _buildMovementTile(tx)),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {},
            child: const Text('Ver todos los movimientos', style: TextStyle(color: AgroTheme.primaryGreen, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildMovementTile(TransactionModel tx) {
    final isCredit = tx.isCredit;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isCredit ? const Color(0xFFC8E6C9) : const Color(0xFFFFEBEE),
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
                Text(tx.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AgroTheme.textDark)),
                Text('${tx.date.day} Mayo 2024', style: const TextStyle(color: AgroTheme.textMuted, fontSize: 12)),
              ],
            ),
          ),
          Text(
            '${isCredit ? "+" : "-"} S/ ${tx.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isCredit ? AgroTheme.primaryGreen : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
