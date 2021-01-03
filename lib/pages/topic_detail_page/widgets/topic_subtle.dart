import 'package:flutter/material.dart';
import 'package:vvex/types.dart';
import 'package:vvex/utils/dt.dart';
import 'package:vvex/widgets/html_content.dart';

class TopicSubtle extends StatelessWidget {
  final SubtleData subtle;
  final int index;

  TopicSubtle({required this.subtle, required this.index}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(
                '第 ${index + 1} 条附言',
                style: TextStyle(),
              ),
              Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        df(subtle.createdAt),
                        style: TextStyle(),
                      )
                    ],
                  ))
            ]),
            HTMLContent(content: subtle.content)
          ],
        ));
  }
}
