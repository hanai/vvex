// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:timeago/timeago.dart' as ta;

class DTUtil {
  static const int ONE_DAY = 3600 * 24 * 1000;
  static const int TWO_DAY = ONE_DAY * 2;
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

  static String timeDisplay(int timestamp) {
    if ((DateTime.now().millisecondsSinceEpoch - timestamp) > TWO_DAY) {
      return df(timestamp, fmt: 'yyyy-MM-dd');
    } else {
      return timeago(timestamp);
    }
  }
}
