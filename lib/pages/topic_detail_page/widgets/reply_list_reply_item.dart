// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vvex/utils/df.dart';
import 'package:vvex/widgets/markdown_content.dart';

import '../../../ret.dart';

class ReplyItem extends StatefulWidget {
  ReplyItem({Key? key, required this.reply, required this.index})
      : super(key: key);

  final Reply reply;
  final int index;

  @override
  _ReplyItemState createState() => _ReplyItemState();
}

class _ReplyItemState extends State<ReplyItem> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      widget.index == 0 ? Container() : Divider(),
      Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                    imageUrl: widget.reply.member.avatarNormal,
                    width: 30,
                    height: 30,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    fit: BoxFit.contain),
                SizedBox(
                  width: 10,
                ),
                Text(widget.reply.member.username),
                Flexible(
                    flex: 1,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(df(widget.reply.created)),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '#${widget.index + 1}',
                            style: TextStyle(color: Color(0xff999999)),
                          ),
                        ]))
              ],
            ),
            Container(
              height: 10,
            ),
            MarkdownContent(content: widget.reply.content)
          ],
        ),
      )
    ]);
  }
}
