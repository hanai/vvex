import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:share/share.dart';

class TopBar extends AppBar {
  TopBar({String? title, required String url})
      : super(title: Text(title ?? url), actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_horiz_outlined),
            itemBuilder: (BuildContext context) {
              return [
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
                if (title != null && title.length > 0) {
                  Share.share('$title - $url');
                } else {
                  Share.share('$url');
                }
              }
            },
          )
        ]);
}
