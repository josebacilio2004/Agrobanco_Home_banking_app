import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/agro_theme.dart';

class TransfersScreen extends StatefulWidget {
  const TransfersScreen({super.key});

  @override
  State<TransfersScreen> createState() => _TransfersScreenState();
}

class _TransfersScreenState extends State<TransfersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AgroTheme.backgroundCream,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AgroTheme.primaryGreen,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ),
        title: Text(
          'Agrobanco',
          style: GoogleFonts.roboto(
            color: AgroTheme.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded, color: AgroTheme.primaryGreen),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AgroTheme.primaryGreen,
          indicatorWeight: 3,
          labelColor: AgroTheme.textDark,
          unselectedLabelColor: AgroTheme.textMuted,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Transferir'),
            Tab(text: 'Pagar servicios'),
            Tab(text: 'QR Agro'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTransferTab(),
          const Center(child: Text('Pagar servicios')),
          const Center(child: Text('QR Agro')),
        ],
      ),
    );
  }

  Widget _buildTransferTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contactos Frecuentes',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AgroTheme.textDark,
            ),
          ),
          const SizedBox(height: 16),
          _buildFrequentContacts(),
          const SizedBox(height: 32),
          Text(
            'Cuenta destino',
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AgroTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: 'Número de cuenta o CCI',
              hintStyle: const TextStyle(color: AgroTheme.textMuted),
              suffixIcon: const Icon(Icons.contact_page_outlined, color: AgroTheme.primaryGreen),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => _showConfirmationModal(context),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequentContacts() {
    final contacts = [
      {'name': 'María R.', 'url': 'https://i.pravatar.cc/150?u=maria'},
      {'name': 'José L.', 'url': 'https://i.pravatar.cc/150?u=jose'},
      {'name': 'Elena G.', 'url': 'https://i.pravatar.cc/150?u=elena'},
    ];

    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...contacts.map((c) => _buildContactItem(c['name']!, c['url']!)),
          _buildNewContactItem(),
        ],
      ),
    );
  }

  Widget _buildContactItem(String name, String url) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AgroTheme.primaryGreen.withOpacity(0.1),
            child: const Icon(Icons.person, color: AgroTheme.primaryGreen),
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontSize: 12, color: AgroTheme.textDark)),
        ],
      ),
    );
  }

  Widget _buildNewContactItem() {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
          ),
          child: const Icon(Icons.add, color: AgroTheme.textMuted),
        ),
        const SizedBox(height: 8),
        const Text('Nuevo', style: TextStyle(fontSize: 12, color: AgroTheme.textMuted)),
      ],
    );
  }

  void _showConfirmationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Confirmar Transferencia',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AgroTheme.primaryGreen,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow('Desde:', 'Ahorro Tradicional (...4521)'),
            _buildDetailRow('Para:', 'María Rodríguez (...8902)'),
            _buildDetailRow('Monto total:', 'S/ 1,200.00', isBold: true),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AgroTheme.secondaryYellow),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Esta operación es segura. Se validará su identidad en el siguiente paso.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF856404)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AgroTheme.primaryGreen),
              child: const Text('Confirmar transferencia'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AgroTheme.textMuted)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: AgroTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
