import 'package:flutter/material.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('用户: ${widget.username}'),
        ),
        body: SingleChildScrollView(child: Column()));
  }
}
