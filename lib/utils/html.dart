// ignore: import_of_legacy_library_into_null_safe
import 'package:html/dom.dart';

bool testIfLoged(Document doc) {
  return doc.querySelector('.member-activity-bar') != null;
}

bool hasLoginForm(Document doc) {
  return doc.querySelector('form[action="/signin"]') != null;
}

String decodeEmail(String secret) {
  final int start = int.parse(secret.substring(0, 2), radix: 16);
  String res = '';
  for (var i = 2; i < secret.length; i += 2) {
    final int code = int.parse(secret.substring(i, i + 2), radix: 16) ^ start;
    res += String.fromCharCode(code);
  }
  return res;
}

String parseContent(Element ele) {
  ele.querySelectorAll('a[title^=\"在新窗口打开图片 \"]').forEach((e) {
    var $img = e.querySelector('img.embedded_image');
    if ($img != null) {
      e.parentNode.insertBefore($img, e);
      e.remove();
    }
  });

  ele.querySelectorAll('.__cf_email__').forEach((element) {
    var secret = element.attributes['data-cfemail'];
    if (secret != null && secret.length > 0) {
      final email = decodeEmail(secret);
      final p = element.parentNode;
      element.remove();
      p.text = email;
      p.attributes['href'] = 'mailto:$email';
    }
  });
  return ele.innerHtml;
}
