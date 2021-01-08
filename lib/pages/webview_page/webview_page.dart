import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:webview_flutter/webview_flutter.dart';

import 'widgets/top_bar.dart';

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
  String? _title;
  late String _url;
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();

    this._title = widget.title;
    this._url = widget.url;

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  void updatePageTitle() async {
    final String title = await _webViewController?.getTitle() ?? '';
    setState(() {
      _title = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: TopBar(
              title: _title ?? _url,
              url: _url,
            ),
            body: SizedBox.expand(
                child: WebView(
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onPageFinished: (url) {
                setState(() {
                  _url = url;
                });
                updatePageTitle();
              },
              navigationDelegate: (req) {
                final url = req.url;
                if (url.startsWith('http://') ||
                    url.startsWith('https://') ||
                    url.startsWith('//')) {
                  setState(() {
                    _url = url;
                  });
                  return NavigationDecision.navigate;
                } else {
                  return canLaunch(req.url).then((res) {
                    if (res) {
                      launch(url, forceSafariVC: false, forceWebView: false);
                    }
                    return NavigationDecision.prevent;
                  });
                }
              },
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.url,
            ))),
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
