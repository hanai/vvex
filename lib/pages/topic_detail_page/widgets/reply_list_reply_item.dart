// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vvex/types.dart';
import 'package:vvex/utils/dt.dart' as dt;
import 'package:vvex/widgets/html_content.dart';

class ReplyItem extends StatefulWidget {
  ReplyItem({Key? key, required this.reply}) : super(key: key);

  final ReplyData reply;

  @override
  _ReplyItemState createState() => _ReplyItemState();
}

class _ReplyItemState extends State<ReplyItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CachedNetworkImage(
                    imageUrl: widget.reply.member.avatar,
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
                          Text(dt.df(widget.reply.createdAt)),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            '#${widget.reply.floor}',
                            style: TextStyle(color: Color(0xff999999)),
                          ),
                        ]))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            HTMLContent(content: widget.reply.content)
          ],
        ));
  }
}
