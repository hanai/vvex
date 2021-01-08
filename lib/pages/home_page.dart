import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vvex/get_it.dart';
import 'package:vvex/router.dart' as router;
import 'package:vvex/providers/user_state.dart';
import 'package:vvex/services/navigation_service.dart';
import 'package:vvex/widgets/home_drawer/home_drawer.dart';

import 'home_tab/home_tab.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final floatingActionButton =
        Consumer<UserState>(builder: (context, userState, child) {
      return userState.logged
          ? FloatingActionButton(
              onPressed: () {
                _navigationService.navigateTo(router.NewTopicPageRoute);
              },
              tooltip: 'New Topic',
              child: Icon(Icons.add),
            )
          : SizedBox();
    });

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: HomeDrawer(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[Flexible(child: HomeTab())],
        ),
        floatingActionButton:
            floatingActionButton is SizedBox ? null : floatingActionButton);
  }
}
