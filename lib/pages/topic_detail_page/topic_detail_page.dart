import 'package:flutter/material.dart';
import 'package:vvex/services.dart';
import 'package:vvex/types.dart';
import 'package:vvex/widgets/html_content.dart';
import 'package:vvex/widgets/loading_container.dart';

import 'widgets/reply_list_reply_item.dart';
import 'widgets/topic_meta_info.dart';
import 'widgets/topic_reply_info.dart';
import 'widgets/topic_subtle.dart';

class TopicDetailPage extends StatefulWidget {
  TopicDetailPage({Key? key, this.title, required this.topicId})
      : super(key: key);

  final String? title;
  final int topicId;

  @override
  _TopicDetailPageState createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  TopicData? _topicData;
  List<ReplyData>? _replies;

  @override
  void initState() {
    super.initState();

    this._getTopicAndReplies();
  }

  _getTopicAndReplies() {
    getTopicAndReplies(widget.topicId).then((res) {
      if (this.mounted) {
        setState(() {
          _topicData = res['topic'];
          _replies = res['replies'];
        });
      }
    });
  }

  String _getTopicTitle() {
    if (widget.title != null) {
      return widget.title!;
    } else if (_topicData != null) {
      return _topicData!.title;
    } else {
      return '';
    }
  }

  Map<String, dynamic>? _getReplyInfo() {
    if (_topicData == null) {
      return null;
    }

    if (_topicData != null) {
      return {
        "count": _topicData!.replyCount,
        "lastReplyAt": _topicData!.lastReplyAt,
      };
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final replyInfo = _getReplyInfo();
    return Scaffold(
      appBar: AppBar(
        title: Text('主题: ${_getTopicTitle()}'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_horiz_outlined),
            itemBuilder: (BuildContext context) {
              return [
                {"label": '收藏', "value": 'archive'},
                {"label": '分享', "value": 'share'},
              ].map((item) {
                return PopupMenuItem<String>(
                  value: item['value'],
                  child: Text(item['label']!),
                );
              }).toList();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _getTopicTitle().length > 0
                  ? Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(
                        _getTopicTitle(),
                        style:
                            TextStyle(color: Color(0xFF333333), fontSize: 26),
                      ),
                    )
                  : Container(),
              _topicData != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                          TopicMetaInfo(_topicData!),
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: HTMLContent(
                                content: _topicData!.content,
                              )),
                          ...(_topicData!.subtles.length > 0
                              ? [
                                  Divider(),
                                  ..._topicData!.subtles
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    return TopicSubtle(
                                        subtle: entry.value, index: entry.key);
                                  }).toList()
                                ]
                              : [])
                        ])
                  : LoadingContainer(),
              ...(replyInfo != null
                  ? [
                      Divider(),
                      TopicReplyInfo(
                          count: replyInfo['count'],
                          time: replyInfo['lastReplyAt'])
                    ]
                  : []),
              Divider(),
              _replies != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _replies!
                          .asMap()
                          .entries
                          .map((entry) => ReplyItem(
                                reply: entry.value,
                                index: entry.key,
                              ))
                          .toList())
                  : LoadingContainer(),
              SizedBox(
                height: 120,
              )
            ]),
      ),
    );
  }
}
