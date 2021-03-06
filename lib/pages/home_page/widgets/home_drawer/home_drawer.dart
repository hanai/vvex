import 'package:flutter/material.dart';
import 'package:vvex/services/navigation_service.dart';
import 'package:vvex/services/user_service.dart';
import 'package:vvex/widgets/avatar_image.dart';

import 'package:vvex/get_it.dart';
import 'package:vvex/router.dart' as router;

import './drawer_button.dart';

class HomeDrawer extends StatefulWidget {
  HomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final NavigationService _navigationService = locator<NavigationService>();
  final UserService _userService = locator<UserService>();

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

  void _userStateUpdate() {
    setState(() => {});
  }

  void _handleClickLogout() {
    _userService.logout();
  }

  void _handleClickLogin() {
    _navigationService.navigateTo(router.LoginPageRoute);
  }

  void _handleClickAbout() {
    _navigationService.navigateTo(router.AboutPageRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: [
                ...(_userService.isAuthed
                    ? [
                        AvatarImage(
                          imageUrl: _userService.avatar!,
                          size: 80,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(_userService.username!),
                      ]
                    : [])
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          // DrawerButton(
          //   title: '节点收藏',
          //   icon: Icon(Icons.login),
          //   onTap: () {},
          // ),
          // DrawerButton(
          //   title: '主题收藏',
          //   icon: Icon(Icons.login),
          //   onTap: () {},
          // ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerButton(
                title: '关于',
                icon: Icon(Icons.info_outline_rounded),
                onTap: _handleClickAbout,
              ),
              ...(_userService.isAuthed
                  ? [
                      DrawerButton(
                          title: '登出',
                          icon: Icon(Icons.logout),
                          onTap: _handleClickLogout),
                    ]
                  : [
                      DrawerButton(
                          title: '登录',
                          icon: Icon(Icons.login),
                          onTap: _handleClickLogin),
                    ])
            ],
          ))
        ],
      ),
    );
  }
}
