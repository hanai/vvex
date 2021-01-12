import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:share/share.dart';

class TopBar extends AppBar {
  TopBar({String? title, required String name})
      : super(title: Text(title ?? name), actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_horiz_outlined),
            itemBuilder: (BuildContext context) {
              return [
                // {"label": '收藏', "value": 'archive'},
                {"label": '分享', "value": 'share'},
              ].map((item) {
                return PopupMenuItem<String>(
                  value: item['value'],
                  child: Text(item['label']!),
                );
              }).toList();
            },
            onSelected: (String v) {
              if (v == 'share') {
                Share.share('VVEX - $title - https://www.v2ex.com/go/$name');
              }
            },
          )
        ]);
}
