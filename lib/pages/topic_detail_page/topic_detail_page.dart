import 'package:flutter/material.dart';
import 'package:vvex/exceptions.dart';
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
  int _curReplyPage = 0;
  bool _showLoadMore = false;
  bool _isLoadingMoreReply = false;

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
          _curReplyPage = _topicData!.replyPageCount > 0 ? 1 : 0;
          _showLoadMore = _topicData!.replyPageCount > _curReplyPage;
        });
      }
    }).catchError((err) {
      print(err);
    }, test: (e) => e is NeedLoginException);
  }

  _loadMoreReply() {
    setState(() {
      _isLoadingMoreReply = true;
    });
    int newPage = _curReplyPage + 1;

    getTopicAndReplies(widget.topicId, page: newPage).then((res) {
      if (this.mounted) {
        setState(() {
          _replies!.addAll(res['replies']);
          _curReplyPage = newPage;
          _showLoadMore = _topicData!.replyPageCount > newPage;
          _isLoadingMoreReply = false;
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
    if (_topicData != null) {
      return {
        "count": _topicData!.replyCount,
        "lastReplyAt": _topicData!.lastReplyAt,
      };
    } else {
      return null;
    }
  }

  bool _onScroll(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels > scrollInfo.metrics.maxScrollExtent - 100) {
      if (!_isLoadingMoreReply && _showLoadMore) {
        _loadMoreReply();
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final replyInfo = _getReplyInfo();
    return Scaffold(
        appBar: AppBar(
          title: Text('${_getTopicTitle()}'),
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
        body: NotificationListener<ScrollNotification>(
          onNotification: _onScroll,
          child: ListView.builder(
              itemCount: 2 + (_replies?.length ?? 0),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _getTopicTitle().length > 0
                          ? Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Text(
                                _getTopicTitle(),
                                style: TextStyle(
                                    color: Color(0xFF333333), fontSize: 24),
                              ),
                            )
                          : SizedBox(),
                      _topicData != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                  TopicMetaInfo(_topicData!),
                                  ...(_topicData!.content != null
                                      ? [
                                          Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 10, 10, 10),
                                              child: HTMLContent(
                                                content: _topicData!.content!,
                                              ))
                                        ]
                                      : []),
                                  ...((_topicData!.subtles ?? []).length > 0
                                      ? [
                                          Divider(),
                                          ..._topicData!.subtles!
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            return TopicSubtle(
                                                subtle: entry.value,
                                                index: entry.key);
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
                    ],
                  );
                } else if (index == (_replies?.length ?? 0) + 1) {
                  return _showLoadMore
                      ? Text('Load More')
                      : SizedBox(
                          height: 120,
                        );
                } else {
                  return Column(
                    children: [
                      Divider(),
                      _replies != null
                          ? ReplyItem(
                              reply: _replies![index - 1],
                            )
                          : LoadingContainer(),
                    ],
                  );
                }
              }),
        ));
  }
}
