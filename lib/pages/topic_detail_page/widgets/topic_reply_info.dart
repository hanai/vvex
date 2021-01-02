import 'package:flutter/material.dart';
import 'package:vvex/utils/df.dart';

class TopicReplyInfo extends StatelessWidget {
  final int count;
  final String? username;
  final int? time;

  TopicReplyInfo({required this.count, this.username, this.time}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Text('$count 条回复'),
            SizedBox(width: 10),
            Text(
              count > 0 ? '最新回复 $username@${df(time!)}' : '',
            )
          ],
        ));
  }
}
