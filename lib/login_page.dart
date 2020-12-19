import 'dart:io';
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
  String _fieldNameName;
  String _fieldPassName;
  String _fieldCaptchaName;

  Dio dio;

  final _keyForm = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passController = TextEditingController();
  final _captchaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dio = Dio();
    var cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
    this._getSigninWebPageData();
  }

  Future<void> _getSigninWebPageData() async {
    var r = await dio.get('https://www.v2ex.com/signin',
        options: Options(headers: {
          HttpHeaders.userAgentHeader:
              'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1'
        }, responseType: ResponseType.plain));
    final String body = r.data.toString();

    var document = parse(body);
    var loginForm = document.querySelector('form[method="post"]');

    if (loginForm == null) {
      return;
    }

    var once;
    var inputOnce = loginForm.querySelector('input[name="once"]');
    if (inputOnce != null) {
      once = inputOnce.attributes['value'];
    }

    final trs = loginForm.querySelectorAll('tr');
    final fieldNameName = trs[0].querySelector('input').attributes['name'];
    final fieldPassName = trs[1].querySelector('input').attributes['name'];
    final fieldCaptchaName = trs[3].querySelector('input').attributes['name'];

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
      _fieldNameName = fieldNameName;
      _fieldPassName = fieldPassName;
      _fieldCaptchaName = fieldCaptchaName;
    });
  }

  void _execLogin() async {
    try {
      FormData formData = FormData.fromMap({
        _fieldNameName: _nameController.value.text,
        _fieldPassName: _passController.value.text,
        _fieldCaptchaName: _captchaController.value.text,
        "once": _once
      });
      var res = await dio.post("https://www.v2ex.com/signin",
          data: formData,
          options: Options(responseType: ResponseType.plain, headers: {
            HttpHeaders.userAgentHeader:
                'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1'
          }));
      print(res.data);
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data.toString());
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    final captchaImgHeight = 40.0;
    final captchaImgWidth = captchaImgHeight * 4;

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
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                    key: _keyForm,
                    onChanged: () {
                      Form.of(primaryFocus.context).save();
                    },
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 80,
                                padding: EdgeInsets.only(right: 20),
                                child: Text(
                                  '用户名',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    hintText: '用户名',
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return '请输入用户名';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                padding: EdgeInsets.only(right: 20),
                                child: Text(
                                  '密码',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: _passController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    hintText: '密码',
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return '请输入密码';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 80,
                                padding: EdgeInsets.only(right: 20),
                                child: Text(
                                  '验证码',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: _captchaController,
                                  decoration: const InputDecoration(
                                    hintText: '验证码',
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return '请输入验证码';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              _captchaImg != null
                                  ? Image.memory(
                                      _captchaImg,
                                      width: captchaImgWidth,
                                      height: captchaImgHeight,
                                    )
                                  : Placeholder(
                                      fallbackWidth: captchaImgWidth,
                                      fallbackHeight: captchaImgHeight,
                                    )
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (_keyForm.currentState.validate()) {
                                  _execLogin();
                                }
                              },
                              child: Text('登录'))
                        ]))),
          ],
        ),
      ),
    );
  }
}
