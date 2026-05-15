import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:biz_zinda/Data/Network/network_api_service.dart';
import 'package:biz_zinda/model/logged_in_user.dart';
import 'package:biz_zinda/services/auth_username_service.dart';

class UsernameLoginViewModel with ChangeNotifier {
  final _net = NetworkApiService();
  late final AuthUsernameService _auth = AuthUsernameService(_net);

  bool _loading = false;
  bool get loading => _loading;

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  String? _error;
  String? get error => _error;

  void _setError(String? e) {
    _error = e;
    notifyListeners();
  }

  Future<void> login({required String username, required String password}) async {
    _setError(null);
    _setLoading(true);
    try {
      // Client side validation to match server rules
      if (!RegExp(r'^[A-Za-z0-9._-]{3,30}$').hasMatch(username)) {
        throw Exception('Invalid username format');
      }
      final passOk = password.length >= 8 &&
          RegExp(r'[A-Z]').hasMatch(password) &&
          RegExp(r'[0-9]').hasMatch(password);
      if (!passOk) {
        throw Exception('Password must be 8+ chars, include uppercase and number');
      }

      final resp = await _auth.loginWithUsername(username: username, password: password);
      final data = resp['data'] as Map<String, dynamic>;
      LoggedInUser.login(data);
    } catch (e) {
      // Clean up the error message for user display
      final msg = e.toString().replaceFirst('Exception: ', '');
      _setError(msg);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
