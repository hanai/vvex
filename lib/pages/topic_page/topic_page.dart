import 'dart:async';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  Exception? _pageException;

  @override
  void initState() {
    super.initState();

    this._getTopicAndReplies();
  }

  Future _getTopicAndReplies() {
    return getTopicAndReplies(
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

  Future _loadMoreReply() {
    int newPage = _curReplyPage + 1;

    return getTopicAndReplies(
      widget.topicId,
      page: newPage,
    ).then((res) {
      if (this.mounted) {
        setState(() {
          _replies!.addAll(res['replies']);
          _curReplyPage = newPage;
          _showLoadMore = _topicData!.replyPageCount > newPage;
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

  void _onRefresh() async {
    await _getTopicAndReplies();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (_showLoadMore) {
      await _loadMoreReply();
      _refreshController.loadComplete();
    }
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final replyInfo = _getReplyInfo();
    return Scaffold(
        appBar: TopBar(
          title: '${_getTopicTitle()}',
          id: widget.topicId,
        ),
        body: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("pull up load");
                } else if (mode == LoadStatus.loading) {
                  body = LoadingContainer(
                    width: 40,
                    height: 40,
                    padding: EdgeInsets.all(0),
                  );
                } else if (mode == LoadStatus.failed) {
                  body = Text("Load Failed!Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("release to load more");
                } else {
                  body = Text("No more Data");
                }
                return Container(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            header: WaterDropHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: ListView.separated(
              itemCount: 1 + (_replies?.length ?? 0),
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
            )));
  }
}
