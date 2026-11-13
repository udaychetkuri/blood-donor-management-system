import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name = '';
  String _email = '';

  String get name => _name;
  String get email => _email;

  void setUser({required String name, required String email}) {
    _name = name;
    _email = email;
    notifyListeners();
  }

  void logout() {
    _name = '';
    _email = '';
    notifyListeners();
  }
}

