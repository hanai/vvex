import 'dart:typed_data';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:html/parser.dart' show parse;
import 'package:vvex/services.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.title}) : super(key: key);

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
  String? _once;
  Uint8List? _captchaImg;
  String? _fieldNameName;
  String? _fieldPassName;
  String? _fieldCaptchaName;

  final _keyForm = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passController = TextEditingController();
  final _captchaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    this._getSigninWebPageData();
  }

  Future<void> _getSigninWebPageData() async {
    final html = await getSigninPageHTML();

    var document = parse(html);
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
    final fieldNameName = trs[0].querySelector('input').attributes['name']!;
    final fieldPassName =
        trs[1].querySelector('input[type="password"]').attributes['name']!;
    final fieldCaptchaName = trs[3].querySelector('input').attributes['name']!;

    var captchaUrl;
    var captchaDiv = loginForm.querySelector('div[style^="background-image"]');
    if (captchaDiv != null) {
      RegExp exp = new RegExp(r"url\('(.+)'\)");
      final match = exp.firstMatch(captchaDiv.attributes['style']!);
      if (match != null &&
          match.groupCount > 0 &&
          match.group(1)!.startsWith('/')) {
        captchaUrl = 'https://www.v2ex.com' + match.group(1)!;
      }
    }

    var captchaImg;
    print('captcha image url: ' + captchaUrl);
    if (captchaUrl != null) {
      captchaImg = await getSigninCaptchaImage(captchaUrl);
    }

    if (this.mounted) {
      setState(() {
        _once = once;
        _captchaImg = captchaImg;
        _fieldNameName = fieldNameName;
        _fieldPassName = fieldPassName;
        _fieldCaptchaName = fieldCaptchaName;
      });
    }
  }

  void _execLogin(BuildContext context) async {
    var args = {
      _fieldNameName!: _nameController.value.text,
      _fieldPassName!: _passController.value.text,
      _fieldCaptchaName!: _captchaController.value.text,
      "once": _once,
      "next": "/"
    };
    final res = await signin(args);
    if (res) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("登录失败"),
      ));
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
                      final ctx = primaryFocus?.context;
                      if (ctx != null) {
                        Form.of(ctx)?.save();
                      }
                    },
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                    if (value != null && value.isEmpty) {
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
                                    if (value != null && value.isEmpty) {
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
                                    if (value != null && value.isEmpty) {
                                      return '请输入验证码';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              _captchaImg != null
                                  ? Image.memory(
                                      _captchaImg!,
                                      width: captchaImgWidth,
                                      height: captchaImgHeight,
                                    )
                                  : Placeholder(
                                      fallbackWidth: captchaImgWidth,
                                      fallbackHeight: captchaImgHeight,
                                    )
                            ],
                          ),
                          Builder(
                            builder: (BuildContext context) {
                              return ElevatedButton(
                                  onPressed: () {
                                    if (_keyForm.currentState?.validate() ??
                                        false) {
                                      _execLogin(context);
                                    }
                                  },
                                  child: Text('登录'));
                            },
                          )
                        ]))),
          ],
        ),
      ),
    );
  }
}
