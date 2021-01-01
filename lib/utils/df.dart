// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';

String df(int timestamp, {String fmt = 'yyyy-MM-dd HH:mm:ss'}) {
  final dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var formatter = new DateFormat(fmt);
  return formatter.format(dt);
}
