import 'package:flutter/material.dart';
import 'package:vvex/utils/dt.dart';

class TopicReplyInfo extends StatelessWidget {
  final int count;
  final int? time;

  TopicReplyInfo({required this.count, this.time}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Text('$count 条回复'),
            Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      count > 0 ? '最新回复 ${df(time!)}' : '',
                    )
                  ],
                ))
          ],
        ));
  }
}
