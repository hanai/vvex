import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vvex/types.dart';
import 'package:vvex/utils/dt.dart';

class TopicMetaInfo extends StatelessWidget {
  final TopicData topic;

  TopicMetaInfo(this.topic) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          CachedNetworkImage(
              imageUrl: topic.member.avatar,
              width: 30,
              height: 30,
              placeholder: (context, url) => CircularProgressIndicator(),
              fit: BoxFit.contain),
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
