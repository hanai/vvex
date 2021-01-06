import 'package:flutter/material.dart';

class UserState extends ChangeNotifier {
  bool _logged = false;

  void setLogged(bool logged) {
    _logged = logged;
    notifyListeners();
  }

  bool get logged => _logged;
}
