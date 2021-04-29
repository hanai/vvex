import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vvex/utils/http.dart';

class UserService extends ChangeNotifier {
  bool _isAuthed = false;
  String? _avatar;
  String? _username;

  static const KEY_IS_AUTHED = 'isAuthed';
  static const KEY_USERNAME = 'username';
  static const KEY_AVATAR = 'avatar';

  UserService() {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      _isAuthed = prefs.getBool(KEY_IS_AUTHED) ?? false;
      if (_isAuthed) {
        _username = prefs.getString(KEY_USERNAME);
        _avatar = prefs.getString(KEY_AVATAR);
      }
      GetIt.instance.signalReady(this);
      notifyListeners();
    });
  }

  void setUserState(
      {required bool isAuthed,
      required String avatar,
      required String username}) {
    if (_isAuthed != isAuthed || _avatar != avatar || _username != username) {
      _isAuthed = isAuthed;
      if (isAuthed) {
        _avatar = avatar;
        _username = username;
      }
      SharedPreferences.getInstance().then((SharedPreferences prefs) {
        prefs.setBool(KEY_IS_AUTHED, isAuthed);
        prefs.setString(KEY_USERNAME, username);
        prefs.setString(KEY_AVATAR, avatar);
      });

      notifyListeners();
    }
  }

  void setIsAuthed(bool isAuthed) {
    if (_isAuthed != isAuthed) {
      _isAuthed = isAuthed;
      SharedPreferences.getInstance().then((SharedPreferences prefs) {
        prefs.setBool(KEY_IS_AUTHED, isAuthed);
      });

      notifyListeners();
    }
  }

  void logout() {
    final http = Http();
    http.clearCookie();

    setIsAuthed(false);
  }

  get isAuthed => _isAuthed;
  get username => _username;
  get avatar => _avatar;
}
