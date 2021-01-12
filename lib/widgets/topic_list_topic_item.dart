import 'package:flutter/material.dart';
import 'package:vvex/get_it.dart';
import 'package:vvex/services/navigation_service.dart';
import 'package:vvex/types.dart';
import 'package:vvex/utils/dt.dart';
import 'package:vvex/widgets/avatar_image.dart';
import 'package:vvex/router.dart' as router;
import 'package:vvex/widgets/node_tag.dart';

class TopicListTopicItem extends StatelessWidget {
  final Key? key;
  final TopicData topic;
  final int? index;

  final NavigationService _navigationService = locator<NavigationService>();

  TopicListTopicItem({required this.topic, this.key, this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _navigationService.navigateTo(router.TopicPageRoute,
            arguments: {"title": this.topic.title, "topicId": topic.id});
      },
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              width: 48,
              child: Column(
                children: [
                  AvatarImage(
                    imageUrl: this.topic.member.avatar,
                    size: 48,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    this.topic.member.username,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 6,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    topic.title.replaceAll(new RegExp(r'\r\n|\r|\n'), ' '),
                    style: TextStyle(fontSize: 20),
                    softWrap: true,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      topic.node != null
                          ? NodeTag(node: topic.node!)
                          : SizedBox(),
                      SizedBox(
                        width: 6,
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          topic.lastReplyBy != null && topic.lastReplyAt != null
                              ? Expanded(
                                  child: Text(
                                  '最新回复 ${topic.lastReplyBy}@${DTUtil.timeago(topic.lastReplyAt!)}',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ))
                              : SizedBox(),
                          topic.createdAt != null
                              ? Expanded(
                                  child: Text(
                                  '发表于 ${DTUtil.timeago(topic.createdAt!)}',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ))
                              : SizedBox()
                        ],
                      ))
                    ],
                  )
                ],
              ),
            ),
          ])),
    );
  }
}
