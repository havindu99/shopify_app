import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';
  String _userPhone = '';
  String _userAddress = '';

  static const String _loginKey = 'is_logged_in';
  static const String _nameKey = 'user_name';
  static const String _emailKey = 'user_email';
  static const String _phoneKey = 'user_phone';
  static const String _addressKey = 'user_address';

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get userAddress => _userAddress;
  String get userInitials => _userName.isNotEmpty
      ? _userName.split(' ').map((n) => n[0]).take(2).join().toUpperCase()
      : 'U';

  Future<void> loadAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_loginKey) ?? false;
    _userName = prefs.getString(_nameKey) ?? '';
    _userEmail = prefs.getString(_emailKey) ?? '';
    _userPhone = prefs.getString(_phoneKey) ?? '';
    _userAddress = prefs.getString(_addressKey) ?? '';
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (email.isNotEmpty && password.length >= 6) {
      _isLoggedIn = true;
      _userEmail = email;
      _userName = email.split('@').first.replaceAll('.', ' ').split(' ')
          .map((w) => w.isNotEmpty
              ? '${w[0].toUpperCase()}${w.substring(1)}'
              : w)
          .join(' ');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_loginKey, true);
      await prefs.setString(_nameKey, _userName);
      await prefs.setString(_emailKey, _userEmail);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
  }) async {
    _userName = name;
    _userEmail = email;
    _userPhone = phone;
    _userAddress = address;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_phoneKey, phone);
    await prefs.setString(_addressKey, address);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';
    _userPhone = '';
    _userAddress = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_phoneKey);
    await prefs.remove(_addressKey);
    notifyListeners();
  }
}