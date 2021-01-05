// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vvex/pages/topic_detail_page/topic_detail_page.dart';
import 'package:vvex/types.dart';
import 'package:vvex/utils/dt.dart' as dt;

class NodeTag extends StatelessWidget {
  String text;

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
  final TopicData topic;
  final int? index;

  TopicListTopicItem({required this.topic, this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        index != 0 ? Divider() : SizedBox(),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TopicDetailPage(
                        title: this.topic.title,
                        topicId: topic.id,
                      )),
            );
          },
          child: Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  width: 48,
                  child: Column(
                    children: [
                      SizedBox(
                          width: 48,
                          height: 48,
                          child: CachedNetworkImage(
                              fit: BoxFit.contain,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              imageUrl: this.topic.member.avatar)),
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
                          topic.node != null
                              ? NodeTag(topic.node!)
                              : SizedBox(),
                          SizedBox(
                            width: 6,
                          ),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              topic.lastReplyBy != null &&
                                      topic.lastReplyAt != null
                                  ? Expanded(
                                      child: Text(
                                      '最新回复 ${topic.lastReplyBy}@${dt.df(topic.lastReplyAt!)}',
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
                                      '发表于 ${dt.df(topic.createdAt!)}',
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
        )
      ],
    );
  }
}
