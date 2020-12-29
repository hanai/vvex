// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_html/flutter_html.dart';
import 'package:vvex/services.dart';
import 'package:vvex/types.dart';

class TopicDetailPage extends StatefulWidget {
  TopicDetailPage({Key? key, required this.title, required this.topicId})
      : super(key: key);

  final String title;
  final int topicId;

  @override
  _TopicDetailPageState createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  String _topicContent = '';
  List<TopicReply> _topicReplys = [];

  @override
  void initState() {
    super.initState();

    this._getTopicDetail();
  }

  _getTopicDetail() async {
    var data = await getTopicDetail(widget.topicId);

    if (this.mounted) {
      setState(() {
        _topicContent = data['content'];
        _topicReplys = data['replys'];
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(widget.title),
              Html(
                data: _topicContent,
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _topicReplys.map((reply) {
                    return Row(children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                                imageUrl: reply.avatar,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover),
                          ]),
                      Flexible(
                          flex: 1,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(reply.memberName),
                                Text(reply.content)
                              ]))
                    ]);
                  }).toList())
            ]),
      ),
    );
  }
}
