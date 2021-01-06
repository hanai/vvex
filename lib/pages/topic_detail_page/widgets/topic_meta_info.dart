import 'package:flutter/material.dart';
import 'package:vvex/types.dart';
import 'package:vvex/utils/dt.dart';
import 'package:vvex/widgets/avatar_image.dart';

class TopicMetaInfo extends StatelessWidget {
  final TopicData topic;

  TopicMetaInfo(this.topic) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          AvatarImage(
            imageUrl: topic.member.avatar,
            size: 30,
          ),
          SizedBox(
            width: 10,
          ),
          Text(topic.member.username),
          Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  topic.createdAt != null
                      ? Text(df(topic.createdAt!))
                      : SizedBox()
                ],
              ))
        ],
      ),
    );
  }
}
