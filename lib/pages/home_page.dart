import 'package:flutter/material.dart';
import 'package:vvex/get_it.dart';
import 'package:vvex/router.dart' as router;
import 'package:vvex/services/navigation_service.dart';
import 'package:vvex/services/user_service.dart';
import 'package:vvex/widgets/home_drawer/home_drawer.dart';

import 'home_tab/home_tab.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class HomePageFloatingActionButton extends StatefulWidget {
  @override
  _HomePageFloatingActionButtonState createState() =>
      _HomePageFloatingActionButtonState();
}

class _HomePageFloatingActionButtonState
    extends State<HomePageFloatingActionButton> {
  final UserService _userService = locator<UserService>();
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    _userService.addListener(_userStateUpdate);
    super.initState();
  }

  @override
  void dispose() {
    _userService.removeListener(_userStateUpdate);
    super.dispose();
  }

  _userStateUpdate() {
    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return _userService.isAuthed
        ? FloatingActionButton(
            onPressed: () {
              _navigationService.navigateTo(router.NewTopicPageRoute);
            },
            tooltip: 'New Topic',
            child: Icon(Icons.add),
          )
        : SizedBox();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        floatingActionButton: HomePageFloatingActionButton());
  }
}
