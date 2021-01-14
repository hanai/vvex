import 'package:flutter/material.dart';
import 'package:vvex/get_it.dart';
import 'package:vvex/services/navigation_service.dart';
import 'package:vvex/router.dart' as router;

class NoAuthMessage extends StatelessWidget {
  final _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(
              Icons.error,
              color: Colors.redAccent,
            ),
            SizedBox(
              width: 6,
            ),
            Text('无权限，请登录后访问')
          ]),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
              child: Text('登录'),
              color: Colors.blue,
              highlightColor: Colors.blue[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.grey,
              onPressed: () {
                _navigationService.replace(router.LoginPageRoute);
              })
        ],
      ),
    );
  }
}

class NotFoundTopicMessage extends StatelessWidget {
  final _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(
              Icons.error,
              color: Colors.redAccent,
            ),
            SizedBox(
              width: 6,
            ),
            Text('主题未找到')
          ]),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
              child: Text('返回'),
              color: Colors.blue,
              highlightColor: Colors.blue[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.grey,
              onPressed: () {
                _navigationService.goBack();
              })
        ],
      ),
    );
  }
}
