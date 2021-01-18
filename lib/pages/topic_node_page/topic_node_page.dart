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
  bool _showLoadMore = false;
  int _totalPage = 0;
  int _curPage = 0;

  @override
  void initState() {
    super.initState();

    this._getNodeTopics();
  }

  Future _getNodeTopics() {
    return getNodeTopics(widget.name).then((res) {
      setState(() {
        _topicList = res['topics'];
        _totalPage = res['pagination']['totalPage'];
        _curPage = 1;
        _showLoadMore = _totalPage > 1;
        _initialized = true;
      });
    });
  }

  Future _loadMore() {
    int newPage = _curPage + 1;

    return getNodeTopics(
      widget.name,
      page: newPage,
    ).then((res) {
      if (this.mounted) {
        setState(() {
          _topicList.addAll(res['topics']);
          _totalPage = res['pagination']['totalPage'];
          _curPage = newPage;
          _showLoadMore = _totalPage > newPage;
        });
      }
    });
  }

  void _onRefresh() async {
    await _getNodeTopics();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (_showLoadMore) {
      await _loadMore();
      _refreshController.loadComplete();
    }
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(title: widget.title, name: widget.name),
        body: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("pull up load");
                } else if (mode == LoadStatus.loading && _showLoadMore) {
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
