import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/banking_models.dart';

// Services
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() => _auth.signOut();
}

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User Profile
  Stream<AppUser?> getUserProfile(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((snap) =>
        snap.exists ? AppUser.fromMap(snap.data()!, snap.id) : null);
  }

  // Accounts
  Stream<List<Account>> getAccounts(String uid) {
    return _db
        .collection('accounts')
        .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => Account.fromMap(doc.data(), doc.id)).toList());
  }

  // Transactions
  Stream<List<TransactionModel>> getRecentTransactions(String uid) {
    return _db
        .collection('transactions')
        .where('userId', isEqualTo: uid)
        // .orderBy('date', descending: true) // Temporarily disabled to avoid index error
        .limit(10)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => TransactionModel.fromMap(doc.data(), doc.id)).toList());
  }


  // Loan Installments
  Stream<List<LoanInstallment>> getLoanInstallments(String loanId) {
    return _db
        .collection('accounts')
        .doc(loanId)
        .collection('installments')
        .orderBy('dueDate')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => LoanInstallment.fromMap(doc.data(), doc.id)).toList());
  }
}

// Providers
final authServiceProvider = Provider((ref) => AuthService());
final databaseServiceProvider = Provider((ref) => DatabaseService());

final authStateProvider = StreamProvider((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

final userProfileProvider = StreamProvider((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);
  return ref.watch(databaseServiceProvider).getUserProfile(user.uid);
});

final accountsProvider = StreamProvider<List<Account>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(databaseServiceProvider).getAccounts(user.uid);
});

final transactionsProvider = StreamProvider<List<TransactionModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(databaseServiceProvider).getRecentTransactions(user.uid);
});

