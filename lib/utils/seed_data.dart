import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SeedData {
  static Future<void> seedDemoData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final db = FirebaseFirestore.instance;

    // Create User Profile
    await db.collection('users').doc(user.uid).set({
      'displayName': 'Jose Bacilio de la Cruz',
      'dni': '72839405',
      'email': user.email,
    });

    // Create Savings Account
    final savingsRef = await db.collection('accounts').add({
      'userId': user.uid,
      'balance': 5200.0,
      'type': 'savings',
      'accountNumber': '191-98765432-0-45',
      'cci': '002-191-98765432045-56',
    });

    // Create Loan Account
    final loanRef = await db.collection('accounts').add({
      'userId': user.uid,
      'balance': 7250.0,
      'type': 'loan',
      'accountNumber': '405-12345678-0-99',
      'cci': '002-405-12345678099-12',
    });

    // Add Transactions
    final transactions = [
      {
        'userId': user.uid,
        'accountId': savingsRef.id,
        'title': 'Venta de Cosecha - Maíz',
        'amount': 2500.0,
        'date': Timestamp.now(),
        'isCredit': true,
        'category': 'Ventas',
      },
      {
        'userId': user.uid,
        'accountId': savingsRef.id,
        'title': 'Pago de Insumos - Fertilizante',
        'amount': 850.0,
        'date': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 2))),
        'isCredit': false,
        'category': 'Compras',
      },
      {
        'userId': user.uid,
        'accountId': loanRef.id,
        'title': 'Cuota de Préstamo Agrícola',
        'amount': 1200.0,
        'date': Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 4))),
        'isCredit': false,
        'category': 'Créditos',
      },
    ];

    for (var tx in transactions) {
      await db.collection('transactions').add(tx);
    }

    // Add Loan Installments
    final installments = [
      {
        'number': 'Cuota 01',
        'amount': 1200.0,
        'dueDate': Timestamp.fromDate(DateTime(2026, 1, 25)),
        'status': 'PAGADO',
      },
      {
        'number': 'Cuota 02',
        'amount': 1200.0,
        'dueDate': Timestamp.fromDate(DateTime(2026, 2, 25)),
        'status': 'PAGADO',
      },
      {
        'number': 'Cuota 03',
        'amount': 1200.0,
        'dueDate': Timestamp.fromDate(DateTime(2026, 3, 25)),
        'status': 'PAGADO',
      },
      {
        'number': 'Cuota 04',
        'amount': 1200.0,
        'dueDate': Timestamp.fromDate(DateTime(2026, 4, 25)),
        'status': 'PAGADO',
      },
      {
        'number': 'Cuota 05',
        'amount': 1200.0,
        'dueDate': Timestamp.fromDate(DateTime(2026, 5, 25)),
        'status': 'PENDIENTE',
      },
    ];

    for (var inst in installments) {
      await db.collection('accounts').doc(loanRef.id).collection('installments').add(inst);
    }
  }
}
