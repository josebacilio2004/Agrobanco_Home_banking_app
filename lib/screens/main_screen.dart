import 'package:flutter/material.dart';
import '../theme/agro_theme.dart';
import '../theme/glass_widgets.dart';
import 'dashboard_screen.dart';
import 'savings_screen.dart';
import 'loans_screen.dart';
import 'transfers_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    DashboardScreen(),
    SavingsScreen(),
    LoansScreen(),
    TransfersScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Extend body behind navigation bar to enable glass floating effect
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: GlassCard(
          borderRadius: 24,
          backgroundOpacity: 0.65,
          borderOpacity: 0.35,
          padding: EdgeInsets.zero,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: AgroTheme.primaryGreen,
            unselectedItemColor: Colors.grey.shade600,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            elevation: 0,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Inicio'),
              BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Ahorros'),
              BottomNavigationBarItem(icon: Icon(Icons.assignment_rounded), label: 'Créditos'),
              BottomNavigationBarItem(icon: Icon(Icons.swap_horiz_rounded), label: 'Operar'),
              BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }
}
