import 'package:flutter/material.dart';
import 'package:vvex/get_it.dart';

import 'package:vvex/router.dart' as router;
import 'package:vvex/services/navigation_service.dart';

import '../types.dart';

class NodeTag extends StatelessWidget {
  final _navigationService = locator<NavigationService>();
  final TopicNode node;

  NodeTag({required this.node});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _navigationService.navigateTo(router.NodePageRoute,
            arguments: {"name": node.name, "title": node.title});
      },
      child: Container(
          height: 20,
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0xfff5f5f5)),
          child: Center(
            child: Text(
              node.title,
              style: TextStyle(fontSize: 12, color: Color(0xff999999)),
            ),
          )),
    );
  }
}
