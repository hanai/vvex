import 'package:flutter/material.dart';

class UserState extends ChangeNotifier {
  bool _logged = false;
  String? _avatar;
  String? _username;

  bool get logged => _logged;
  String? get username => _username;
  String? get avatar => _avatar;

  void setState({String? username, String? avatar, required bool logged}) {
    _logged = logged;
    _avatar = avatar;
    _username = username;
    notifyListeners();
  }
}
