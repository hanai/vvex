import 'package:flutter/material.dart';
import 'package:vvex/get_it.dart';
import 'package:vvex/pages/topic_detail_page/topic_detail_page.dart';
import 'package:vvex/services/navigation_service.dart';
import 'package:vvex/types.dart';
import 'package:vvex/utils/dt.dart';
import 'package:vvex/widgets/avatar_image.dart';
import 'package:vvex/router.dart' as router;

class NodeTag extends StatelessWidget {
  final String text;

  NodeTag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 20,
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color(0xfff5f5f5)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Color(0xff999999)),
          ),
        ));
  }
}

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
                    topic.title,
                    style: TextStyle(fontSize: 20),
                    softWrap: true,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      topic.node != null ? NodeTag(topic.node!) : SizedBox(),
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
