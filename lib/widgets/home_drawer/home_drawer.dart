import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vvex/providers/user_state.dart';
import 'package:vvex/services/navigation_service.dart';
import 'package:vvex/widgets/avatar_image.dart';
import 'package:vvex/widgets/home_drawer/drawer_button.dart';

import '../../get_it.dart';
import '../../router.dart' as router;

class HomeDrawer extends StatefulWidget {
  HomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final NavigationService _navigationService = locator<NavigationService>();

  void handleClickLogin() {
    _navigationService.navigateTo(router.LoginPageRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(builder: (context, userState, child) {
      return Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: [
                  ...(userState.logged
                      ? [
                          AvatarImage(
                            imageUrl: userState.avatar!,
                            size: 80,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(userState.username!),
                        ]
                      : [])
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            DrawerButton(
              title: '节点收藏',
              icon: Icon(Icons.login),
              onTap: () {},
            ),
            DrawerButton(
              title: '主题收藏',
              icon: Icon(Icons.login),
              onTap: () {},
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...(userState.logged
                    ? [
                        DrawerButton(
                          title: '登出',
                          icon: Icon(Icons.logout),
                          onTap: () {},
                        ),
                      ]
                    : [
                        DrawerButton(
                            title: '登录',
                            icon: Icon(Icons.login),
                            onTap: handleClickLogin),
                      ])
              ],
            ))
          ],
        ),
      );
    });
  }
}
