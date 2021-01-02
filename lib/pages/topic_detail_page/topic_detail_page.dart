import 'package:flutter/material.dart';
import 'package:vvex/pages/topic_detail_page/widgets/topic_reply_info.dart';
import 'package:vvex/services.dart';
import 'package:vvex/widgets/loading_container.dart';
import 'package:vvex/widgets/markdown_content.dart';
import 'package:vvex/pages/topic_detail_page/widgets/reply_list_reply_item.dart';

import '../../ret.dart';
import 'widgets/topic_meta_info.dart';

class TopicDetailPage extends StatefulWidget {
  TopicDetailPage({Key? key, this.title, required this.topicId})
      : super(key: key);

  final String? title;
  final int topicId;

  @override
  _TopicDetailPageState createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  Topic? _topicDetail;
  List<Reply>? _topicReplys;

  @override
  void initState() {
    super.initState();

    this._getTopicDetail();
    this._getTopicReplies();
  }

  _getTopicReplies({bool refresh = false}) async {
    var replies = await getTopicReplies(widget.topicId, refresh: refresh);
    if (this.mounted) {
      setState(() {
        _topicReplys = replies;
      });
      if (!refresh) {
        _detectReplyNeedRefresh();
      }
    }
  }

  _getTopicDetail() async {
    var data = await getTopicDetail(widget.topicId);

    if (this.mounted) {
      setState(() {
        _topicDetail = data;
      });
      _detectReplyNeedRefresh();
    }
  }

  void _detectReplyNeedRefresh() {
    if (_topicDetail != null && _topicReplys != null) {
      if (_topicDetail!.replies > _topicReplys!.length) {
        _getTopicReplies(refresh: true);
      }
    }
  }

  String _getTopicTitle() {
    if (widget.title != null) {
      return widget.title!;
    } else if (_topicDetail != null) {
      return _topicDetail!.title;
    } else {
      return '';
    }
  }

  Map<String, dynamic>? _getReplyInfo() {
    int replyCount1 = 0;
    int replyCount2 = 0;
    if (_topicDetail != null) {
      replyCount1 = _topicDetail!.replies;
    }

    if (_topicReplys != null) {
      replyCount2 = _topicReplys!.length;
    }

    if (replyCount2 > replyCount1) {
      return {
        "count": replyCount2,
        "lastReplyBy": _topicReplys!.last.member.username,
        "lastTouched": _topicReplys!.last.member.created,
      };
    } else if (_topicDetail != null) {
      return {
        "count": replyCount1,
        "lastReplyBy": _topicDetail!.lastReplyBy,
        "lastTouched": _topicDetail!.lastTouched,
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
              _topicDetail != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                          TopicMetaInfo(_topicDetail!),
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: MarkdownContent(
                                content: _topicDetail!.content,
                              ))
                        ])
                  : LoadingContainer(),
              ...(replyInfo != null
                  ? [
                      Divider(),
                      TopicReplyInfo(
                          count: replyInfo['count'],
                          username: replyInfo['lastReplyBy'],
                          time: replyInfo['lastTouched'])
                    ]
                  : []),
              Divider(),
              _topicReplys != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _topicReplys!
                          .map((reply) => ReplyItem(
                                reply: reply,
                                index: _topicReplys!.indexOf(reply),
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
