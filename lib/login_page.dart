import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _once;
  Uint8List _captchaImg;

  @override
  void initState() {
    super.initState();
    this._getSigninWebPageData();
  }

  Future<void> _getSigninWebPageData() async {
    var dio = Dio();
    var cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    var url = 'https://www.v2ex.com/signin';

    var r =
        await dio.get(url, options: Options(responseType: ResponseType.plain));
    final String body = r.data.toString();

    var document = parse(body);
    var loginForm = document.querySelector('form[method="post"]');

    var once;
    var inputOnce = loginForm.querySelector('input[name="once"]');
    if (inputOnce != null) {
      once = inputOnce.attributes['value'];
    }

    var captchaUrl;
    var captchaDiv = loginForm.querySelector('div[style^="background-image"]');
    if (captchaDiv != null) {
      RegExp exp = new RegExp(r"url\('(.+)'\)");
      final match = exp.firstMatch(captchaDiv.attributes['style']);
      if (match != null &&
          match.groupCount > 0 &&
          match.group(1).startsWith('/')) {
        captchaUrl = 'https://www.v2ex.com' + match.group(1);
      }
    }

    var captchaImg;
    if (captchaUrl != null) {
      r = await dio.get(captchaUrl,
          options: Options(responseType: ResponseType.bytes));
      captchaImg = r.data;
    }

    setState(() {
      _once = once;
      _captchaImg = captchaImg;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            _captchaImg != null ? Image.memory(_captchaImg) : Placeholder()
          ],
        ),
      ),
    );
  }
}
