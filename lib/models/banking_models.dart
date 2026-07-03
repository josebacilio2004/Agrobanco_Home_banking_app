class AppUser {
  final String uid;
  final String dni;
  final String displayName;

  AppUser({
    required this.uid,
    required this.dni,
    required this.displayName,
  });

  factory AppUser.fromApi(Map<String, dynamic> map, String dni, String fullName) {
    return AppUser(
      uid: map['id']?.toString() ?? dni,
      dni: dni,
      displayName: fullName,
    );
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

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      balance: (map['balance'] ?? map['saldo'] ?? 0.0).toDouble(),
      type: (map['type'] ?? 'savings') == 'loan' ? AccountType.loan : AccountType.savings,
      accountNumber: map['accountNumber'] ?? map['numero'] ?? '',
      cci: map['cci'] ?? '',
    );
  }

  static List<Account> fromApiList(Map<String, dynamic> data) {
    final cuentas = data['cuentas'] ?? data['accounts'] ?? [];
    if (cuentas is List) {
      return cuentas.map((c) => Account.fromMap(c)).toList();
    }
    return [];
  }
}

class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isCredit;
  final String category;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isCredit,
    required this.category,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? map['descripcion'] ?? map['concepto'] ?? '',
      amount: (map['amount'] ?? map['monto'] ?? 0.0).toDouble(),
      date: map['date'] != null
          ? DateTime.parse(map['date'].toString())
          : map['fecha'] != null
              ? DateTime.parse(map['fecha'].toString())
              : DateTime.now(),
      isCredit: map['isCredit'] ?? map['tipo'] == 'credito' ?? map['type'] == 'income' ?? true,
      category: map['category'] ?? map['categoria'] ?? 'General',
    );
  }

  static List<TransactionModel> fromApiList(Map<String, dynamic> data) {
    final movimientos = data['movimientos'] ?? data['transactions'] ?? data['ultimos_movimientos'] ?? [];
    if (movimientos is List) {
      return movimientos.map((t) => TransactionModel.fromMap(t)).toList();
    }
    return [];
  }
}

class LoanInstallment {
  final String id;
  final String number;
  final double amount;
  final DateTime dueDate;
  final String status;

  LoanInstallment({
    required this.id,
    required this.number,
    required this.amount,
    required this.dueDate,
    required this.status,
  });

  factory LoanInstallment.fromMap(Map<String, dynamic> map) {
    return LoanInstallment(
      id: map['id']?.toString() ?? '',
      number: map['number'] ?? map['cuota'] ?? map['numero'] ?? '',
      amount: (map['amount'] ?? map['monto'] ?? 0.0).toDouble(),
      dueDate: map['dueDate'] != null
          ? DateTime.parse(map['dueDate'].toString())
          : map['fecha_vencimiento'] != null
              ? DateTime.parse(map['fecha_vencimiento'].toString())
              : DateTime.now(),
      status: map['status'] ?? map['estado'] ?? 'PENDIENTE',
    );
  }
}
