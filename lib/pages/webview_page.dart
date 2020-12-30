import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  WebviewPage({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  final String url;
  final String title;

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  String _title = '';

  @override
  void initState() {
    super.initState();

    this._title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: WebView(
          initialUrl: widget.url,
        ));
  }
}
