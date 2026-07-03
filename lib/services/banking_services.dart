import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/banking_models.dart';

const String _baseUrl = 'https://agrobanco-api.onrender.com';

class ApiClient {
  String? _token;
  String? _dni;
  String? _fullName;

  String? get dni => _dni;
  String? get fullName => _fullName;
  bool get isAuthenticated => _token != null;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['detail'] ?? 'Error al iniciar sesión');
    }
    final data = jsonDecode(response.body);
    _token = data['token'];
    _dni = data['username'];
    _fullName = data['fullName'];
  }

  void logout() {
    _token = null;
    _dni = null;
    _fullName = null;
  }

  Future<Map<String, dynamic>> get(String path) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Error al obtener datos: ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al enviar datos: ${response.statusCode}');
    }
    return jsonDecode(response.body);
  }
}

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

class AuthState extends Notifier<bool> {
  @override
  bool build() => false;
  void setAuthenticated(bool value) => state = value;
}

final authStateProvider = NotifierProvider<AuthState, bool>(AuthState.new);

final userProfileProvider = FutureProvider<AppUser?>((ref) async {
  final api = ref.watch(apiClientProvider);
  if (!api.isAuthenticated) return null;
  try {
    final data = await api.get('/cliente/resumen');
    return AppUser.fromApi(data, api.dni ?? '', api.fullName ?? '');
  } catch (e) {
    return null;
  }
});

final accountsProvider = FutureProvider<List<Account>>((ref) async {
  final api = ref.watch(apiClientProvider);
  if (!api.isAuthenticated) return [];
  try {
    final data = await api.get('/cliente/resumen');
    return Account.fromApiList(data);
  } catch (e) {
    return [];
  }
});

final transactionsProvider = FutureProvider<List<TransactionModel>>((ref) async {
  final api = ref.watch(apiClientProvider);
  if (!api.isAuthenticated) return [];
  try {
    final data = await api.get('/cliente/resumen');
    return TransactionModel.fromApiList(data);
  } catch (e) {
    return [];
  }
});
