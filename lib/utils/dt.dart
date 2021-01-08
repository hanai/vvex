// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:timeago/timeago.dart' as ta;

class DTUtil {
  static String df(int timestamp, {String fmt = 'yyyy-MM-dd HH:mm:ss'}) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formatter = new DateFormat(fmt);
    return formatter.format(dt);
  }

  static int dp(String str) {
    str = str.replaceAll(new RegExp(r'\s\+.+$'), ''); // trim timezone
    final df = new DateFormat('yyyy-MM-dd HH:mm:ss');
    return df.parse(str).millisecondsSinceEpoch;
  }

  static String timeago(int timestamp) {
    ta.setLocaleMessages('zh_CN', ta.ZhCnMessages());
    return ta
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp), locale: 'zh_CN')
        .replaceAll(new RegExp(r'\s'), '');
  }
}
