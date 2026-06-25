import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';
  static const String _loginKey = 'is_logged_in';
  static const String _nameKey = 'user_name';
  static const String _emailKey = 'user_email';

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userInitials => _userName.isNotEmpty
      ? _userName.split(' ').map((n) => n[0]).take(2).join().toUpperCase()
      : 'U';

  Future<void> loadAuth() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_loginKey) ?? false;
    _userName = prefs.getString(_nameKey) ?? '';
    _userEmail = prefs.getString(_emailKey) ?? '';
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (email.isNotEmpty && password.length >= 6) {
      _isLoggedIn = true;
      _userEmail = email;
      _userName = email.split('@').first.replaceAll('.', ' ').split(' ')
          .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : w)
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

  Future<void> logout() async {
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_emailKey);
    notifyListeners();
  }
}
