import 'package:flutter/material.dart';
import 'package:vvex/services.dart';
import 'package:vvex/widgets/topic_list.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class TabItem {
  String key;
  String name;

  TabItem(this.key, this.name);
}

class _HomeTabState extends State<HomeTab> {
  final List<TabItem> _tabList = [
    TabItem('tech', '技术'),
    TabItem('creative', '创意'),
    TabItem('play', '好玩'),
    TabItem('apple', 'Apple'),
    TabItem('jobs', '酷工作'),
    TabItem('deals', '交易'),
    TabItem('city', '城市'),
    TabItem('qna', '问与答'),
    TabItem('hot', '最热'),
    TabItem('all', '全部'),
    TabItem('r2', 'R2')
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _tabList.length,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TabBar(
                isScrollable: true,
                unselectedLabelColor: Colors.black,
                labelColor: Colors.red,
                tabs: _tabList.map((e) {
                  return Tab(text: e.name);
                }).toList()),
            Flexible(
                child: TabBarView(
                    children: _tabList.map((e) {
              return TabView(
                tab: e.key,
              );
            }).toList()))
          ],
        ));
  }
}

class TabView extends StatefulWidget {
  TabView({Key? key, required this.tab}) : super(key: key);

  final String tab;

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView>
    with AutomaticKeepAliveClientMixin<TabView> {
  List<TopicListTopicItem> _topicList = [];

  @override
  void initState() {
    super.initState();

    getTabTopics(widget.tab).then((topics) {
      setState(() {
        _topicList = topics.map((e) => TopicListTopicItem(e)).toList();
      });
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _topicList.length,
        itemBuilder: (context, index) {
          final item = _topicList[index];
          return item.itemBuilder(context, index);
        });
  }
}
