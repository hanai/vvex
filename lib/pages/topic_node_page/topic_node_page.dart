import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vvex/pages/topic_node_page/widgets/top_bar.dart';
import 'package:vvex/services.dart';
import 'package:vvex/types.dart';
import 'package:vvex/widgets/loading_container.dart';
import 'package:vvex/widgets/topic_list_topic_item.dart';

class TopicNodePage extends StatefulWidget {
  TopicNodePage({Key? key, this.title, required this.name}) : super(key: key);

  final String? title;
  final String name;

  @override
  _TopicNodePageState createState() => _TopicNodePageState();
}

class _TopicNodePageState extends State<TopicNodePage> {
  List<TopicData> _topicList = [];
  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    this._getNodeTopics();
  }

  Future _getNodeTopics() {
    return getNodeTopics(widget.name).then((res) {
      setState(() {
        _topicList = res;
        _initialized = true;
      });
    });
  }

  void _onRefresh() async {
    await _getNodeTopics();
    _refreshController.refreshCompleted();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(title: widget.title, name: widget.name),
        body: SmartRefresher(
            enablePullDown: true,
            header: WaterDropHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: ListView.separated(
              itemCount: _initialized ? _topicList.length : 1,
              itemBuilder: (context, index) {
                if (_initialized) {
                  return TopicListTopicItem(
                    key: ValueKey(_topicList[index].id),
                    topic: _topicList[index],
                    index: index,
                  );
                } else {
                  return LoadingContainer();
                }
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 0,
                  thickness: 6,
                );
              },
            )));
  }
}
