import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String dni;
  final String displayName;
  final String? photoURL;

  AppUser({
    required this.uid,
    required this.email,
    required this.dni,
    required this.displayName,
    this.photoURL,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String id) {
    return AppUser(
      uid: id,
      email: map['email'] ?? '',
      dni: map['dni'] ?? '',
      displayName: map['displayName'] ?? '',
      photoURL: map['photoURL'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'dni': dni,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }
}


enum AccountType { savings, loan }

class Account {
  final String id;
  final String userId;
  final double balance;
  final AccountType type;
  final String accountNumber;
  final String cci;

  Account({
    required this.id,
    required this.userId,
    required this.balance,
    required this.type,
    required this.accountNumber,
    required this.cci,
  });

  factory Account.fromMap(Map<String, dynamic> map, String id) {
    return Account(
      id: id,
      userId: map['userId'] ?? '',
      balance: (map['balance'] ?? 0.0).toDouble(),
      type: map['type'] == 'loan' ? AccountType.loan : AccountType.savings,
      accountNumber: map['accountNumber'] ?? '',
      cci: map['cci'] ?? '',
    );
  }
}

class TransactionModel {
  final String id;
  final String userId;
  final String accountId;
  final String title;
  final double amount;
  final DateTime date;
  final bool isCredit; // true for income, false for expense
  final String category;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.accountId,
    required this.title,
    required this.amount,
    required this.date,
    required this.isCredit,
    required this.category,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return TransactionModel(
      id: id,
      userId: map['userId'] ?? '',
      accountId: map['accountId'] ?? '',
      title: map['title'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      date: (map['date'] as Timestamp).toDate(),
      isCredit: map['isCredit'] ?? false,
      category: map['category'] ?? 'General',
    );
  }
}

class LoanInstallment {
  final String id;
  final String number;
  final double amount;
  final DateTime dueDate;
  final String status; // 'PAID', 'PENDING', 'OVERDUE'

  LoanInstallment({
    required this.id,
    required this.number,
    required this.amount,
    required this.dueDate,
    required this.status,
  });

  factory LoanInstallment.fromMap(Map<String, dynamic> map, String id) {
    return LoanInstallment(
      id: id,
      number: map['number'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      status: map['status'] ?? 'PENDING',
    );
  }
}
