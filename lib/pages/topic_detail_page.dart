import 'package:flutter/material.dart';
import 'package:vvex/services.dart';
import 'package:vvex/widgets/loading_container.dart';
import 'package:vvex/widgets/markdown_content.dart';
import 'package:vvex/widgets/reply_list_reply_item.dart';

import '../ret.dart';

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

    getTopicReplies(widget.topicId).then((value) {
      setState(() {
        _topicReplys = value;
      });
    });
  }

  _getTopicDetail() async {
    var data = await getTopicDetail(widget.topicId);

    if (this.mounted) {
      setState(() {
        _topicDetail = data;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTopicTitle()),
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
                  ? Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: MarkdownContent(
                        content: _topicDetail!.content,
                      ))
                  : LoadingContainer(),
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
              Container(
                height: 120,
              )
            ]),
      ),
    );
  }
}
