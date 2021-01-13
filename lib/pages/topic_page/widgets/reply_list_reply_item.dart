import 'package:flutter/material.dart';
import 'package:vvex/types.dart';
import 'package:vvex/utils/dt.dart';
import 'package:vvex/widgets/avatar_image.dart';
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
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                AvatarImage(
                  imageUrl: widget.reply.member.avatar,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(widget.reply.member.username),
                Flexible(
                    flex: 1,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(DTUtil.timeDisplay(widget.reply.createdAt)),
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
