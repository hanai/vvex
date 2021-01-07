import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vvex/providers/user_state.dart';
import 'package:vvex/widgets/avatar_image.dart';

class HomeDrawer extends StatefulWidget {
  HomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
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
            ListTile(
              title: Text('节点收藏'),
              onTap: () {},
            ),
            ListTile(
              title: Text('主题收藏'),
              onTap: () {},
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...(userState.logged
                        ? [
                            Text(
                              '登出',
                              textAlign: TextAlign.center,
                            )
                          ]
                        : [])
                  ],
                )
              ],
            ))
          ],
        ),
      );
    });
  }
}
