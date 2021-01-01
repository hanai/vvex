import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:vvex/markdown_syntax/at_syntax.dart';
import 'package:vvex/pages/topic_detail_page/topic_detail_page.dart';
import 'package:vvex/pages/webview_page.dart';

class MarkdownContent extends StatefulWidget {
  MarkdownContent({
    Key? key,
    required this.content,
    this.selectable = true,
  }) : super(key: key);

  final String content;

  final bool selectable;

  @override
  _MarkdownContentState createState() => _MarkdownContentState();
}

class _MarkdownContentState extends State<MarkdownContent> {
  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
        data: widget.content,
        selectable: widget.selectable,
        inlineSyntaxes: [AtSyntax()],
        onTapLink: (text, href, title) {
          RegExp topicReg =
              new RegExp(r"^(https?:)?\/\/(www\.)?v2ex\.com\/t\/(\d+)$");
          var match = topicReg.firstMatch(href);
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
                      url: href,
                      title: title != null && title.length > 0 ? title : text)),
            );
          }
        });
  }
}
