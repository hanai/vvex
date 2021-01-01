// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vvex/pages/topic_detail_page/topic_detail_page.dart';
import 'package:vvex/types.dart';

class TopicListTopicItem {
  Topic _topic;

  TopicListTopicItem(this._topic);

  Widget itemBuilder(BuildContext context, int index) {
    return Column(
      children: [
        index != 0 ? Divider() : Container(),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TopicDetailPage(
                        title: this._topic.title,
                        topicId: _topic.id,
                      )),
            );
          },
          child: Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      child: Column(
                        children: [
                          Container(
                              width: 48,
                              height: 48,
                              child: CachedNetworkImage(
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  imageUrl: this._topic.avatar)),
                          Container(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              this._topic.author,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                          padding: EdgeInsets.only(left: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                _topic.title,
                                softWrap: true,
                              )
                            ],
                          )),
                    ),
                  ])),
        )
      ],
    );
  }
}
