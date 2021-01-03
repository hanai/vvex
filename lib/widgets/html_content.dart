import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_html/flutter_html.dart';
import 'package:vvex/pages/topic_detail_page/topic_detail_page.dart';
import 'package:vvex/pages/user_info_page/user_info_page.dart';
import 'package:vvex/pages/webview_page.dart';

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
  @override
  Widget build(BuildContext context) {
    return Html(
        data: widget.content,
        onLinkTap: (url) {
          if (url.startsWith('/member/')) {
            print(url.substring(8));
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserInfoPage(
                    username: url.substring(8),
                  ),
                ));
          } else {
            RegExp topicReg =
                new RegExp(r"^(https?:)?\/\/(www\.)?v2ex\.com\/t\/(\d+)$");
            var match = topicReg.firstMatch(url);
            if (match != null && match.groupCount == 3) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TopicDetailPage(
                      topicId: int.parse(match.group(3)!),
                    ),
                  ));
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebviewPage(
                          url: url,
                        )),
              );
            }
          }
        });
  }
}
