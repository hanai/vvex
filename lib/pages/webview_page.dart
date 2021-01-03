import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:webview_flutter/webview_flutter.dart';

class WebviewPage extends StatefulWidget {
  WebviewPage({
    Key? key,
    required this.url,
    this.title,
  }) : super(key: key);

  final String url;
  final String? title;

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  String _title = '';
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();

    this._title = widget.title ?? '';
  }

  void updatePageTitle() async {
    String title =
        await _webViewController?.evaluateJavascript("document.title") ?? '';
    title = title.replaceAllMapped(new RegExp(r'^"(.+)"$'), (match) {
      return '${match.group(1)}';
    });
    setState(() {
      _title = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: Text(_title),
              actions: [
                PopupMenuButton(
                  icon: Icon(Icons.more_horiz_outlined),
                  itemBuilder: (BuildContext context) {
                    return [
                      {"label": '分享', "value": 'share'}
                    ].map((item) {
                      return PopupMenuItem<String>(
                        value: item['value'],
                        child: Text(item['label']!),
                      );
                    }).toList();
                  },
                )
              ],
            ),
            body: WebView(
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onPageFinished: (url) {
                updatePageTitle();
              },
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
            )),
        onWillPop: () async {
          if (_webViewController != null) {
            final canGoBack = await _webViewController!.canGoBack();

            if (canGoBack) {
              _webViewController!.goBack();
              return false;
            }
          }
          return true;
        });
  }
}
