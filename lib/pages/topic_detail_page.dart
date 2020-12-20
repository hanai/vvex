import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:vvex/services.dart';

class TopicDetailPage extends StatefulWidget {
  TopicDetailPage({Key key, this.title, this.topicId}) : super(key: key);

  final String title;
  final int topicId;

  @override
  _TopicDetailPageState createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  String _topicContent = '';
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
            children: <Widget>[
              Text(widget.title),
              Html(
                data: _topicContent,
              )
            ]),
      ),
    );
  }
}
