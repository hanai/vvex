// ignore: import_of_legacy_library_into_null_safe
import 'package:html/dom.dart';

bool testIfLoged(Document doc) {
  return doc.querySelector('.member-activity-bar') != null;
}

bool hasLoginForm(Document doc) {
  return doc.querySelector('form[action="/signin"]') != null;
}
