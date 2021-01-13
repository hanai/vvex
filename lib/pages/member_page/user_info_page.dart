import 'package:flutter/material.dart';

class MemberPage extends StatefulWidget {
  MemberPage({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('用户：${widget.username}'),
        ),
        body: SingleChildScrollView(child: Column()));
  }
}
