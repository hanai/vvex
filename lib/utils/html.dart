// ignore: import_of_legacy_library_into_null_safe
import 'package:html/dom.dart';

bool testIfLoged(Document doc) {
  return doc.querySelector('.member-activity-bar') != null;
}

bool hasLoginForm(Document doc) {
  return doc.querySelector('form[action="/signin"]') != null;
}

String parseContent(Element ele) {
  ele.querySelectorAll('a[title^=\"在新窗口打开图片 \"]').forEach((e) {
    var $img = e.querySelector('img.embedded_image');
    if ($img != null) {
      e.parentNode.insertBefore($img, e);
      e.remove();
    }
  });
  return ele.innerHtml;
}
