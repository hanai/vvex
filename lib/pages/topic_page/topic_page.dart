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
import 'widgets/top_bar.dart';
import 'widgets/error_messages.dart';

class TopicPage extends StatefulWidget {
  TopicPage({Key? key, this.title, required this.topicId}) : super(key: key);

  final String? title;
  final int topicId;

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  TopicData? _topicData;
  List<ReplyData>? _replies;
  int _curReplyPage = 0;
  bool _showLoadMore = false;
  bool _isLoadingMoreReply = false;
  Exception? _pageException;

  @override
  void initState() {
    super.initState();

    this._getTopicAndReplies();
  }

  _getTopicAndReplies() {
    getTopicAndReplies(
      widget.topicId,
    ).then((res) {
      if (this.mounted) {
        setState(() {
          _topicData = res['topic'];
          _replies = res['replies'];
          _curReplyPage = _topicData!.replyPageCount > 0 ? 1 : 0;
          _showLoadMore = _topicData!.replyPageCount > _curReplyPage;
        });
      }
    }).catchError((err) {
      setState(() {
        _pageException = err;
      });
    }, test: (e) => e is NoAuthException || e is NotFoundTopicException);
  }

  _loadMoreReply() {
    setState(() {
      _isLoadingMoreReply = true;
    });
    int newPage = _curReplyPage + 1;

    getTopicAndReplies(
      widget.topicId,
      page: newPage,
    ).then((res) {
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
        appBar: TopBar(
          title: '${_getTopicTitle()}',
          id: widget.topicId,
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: _onScroll,
          child: ListView.separated(
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
                              _getTopicTitle()
                                  .replaceAll(new RegExp(r'\r\n|\r|\n'), ' '),
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 24,
                              ),
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
                                        Divider(
                                          height: 0,
                                        ),
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
                        : _pageException is NoAuthException
                            ? NoAuthMessage()
                            : _pageException is NotFoundTopicException
                                ? NotFoundTopicMessage()
                                : LoadingContainer(),
                    ...(replyInfo != null
                        ? [
                            Divider(
                              height: 0,
                            ),
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
                return _replies != null
                    ? ReplyItem(
                        key: ValueKey(_replies![index - 1].floor),
                        reply: _replies![index - 1],
                      )
                    : LoadingContainer();
              }
            },
            separatorBuilder: (BuildContext context, int index) {
              if ((_replies != null && index < (_replies!.length))) {
                return Divider(
                  height: 0,
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ));
  }
}
