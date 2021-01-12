import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_html/flutter_html.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vvex/get_it.dart';
import 'package:vvex/services/navigation_service.dart';
import 'package:vvex/utils/browser.dart';
import 'package:vvex/widgets/v_network_image.dart';
import 'package:vvex/router.dart' as router;

class HTMLContent extends StatefulWidget {
  HTMLContent({
    Key? key,
    required this.content,
  }) : super(key: key);

  final String content;

  @override
  _HTMLContentState createState() => _HTMLContentState();
}

class _HTMLContentState extends State<HTMLContent> {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Html(
        data: widget.content,
        customRender: {
          "img": (context, parsedChild, attributes, element) {
            String src = attributes['src'] ?? '';
            return VNetworkImage(imageUrl: src);
          },
        },
        style: {
          "a": Style(textDecoration: TextDecoration.none),
          "a[title^=\"在新窗口打开图片 \"]": Style(),
          "body": Style(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              fontSize: FontSize(18)),
        },
        onLinkTap: (url) {
          if (url.startsWith('/member/')) {
            _navigationService.navigateTo(router.MemberPageRoute,
                arguments: {"username": url.substring(8)});
          } else if (url.startsWith('mailto:')) {
            launch(url, forceSafariVC: false, forceWebView: false);
          } else {
            RegExp topicReg = new RegExp(
                r"^((https?:)?\/\/(www\.)?v2ex\.com)?\/t\/(\d+)(#.+)?$");
            var match = topicReg.firstMatch(url);
            if (match != null && match.groupCount == 5) {
              _navigationService.navigateTo(router.TopicPageRoute,
                  arguments: {"topicId": int.parse(match.group(4)!)});
            } else {
              BrowserUtil.open(url);
            }
          }
        });
  }
}
