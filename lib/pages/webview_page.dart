import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
          navigationDelegate: (req) {
            final url = req.url;
            if (url.startsWith('http://') ||
                url.startsWith('https://') ||
                url.startsWith('//')) {
              return NavigationDecision.navigate;
            } else {
              return canLaunch(req.url).then((res) {
                if (res) {
                  launch(url);
                }
                return NavigationDecision.prevent;
              });
            }
          },
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget.url,
        ));
  }
}
