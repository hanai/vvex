import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:package_info/package_info.dart';
import 'package:vvex/pages/about_page/widgets/top_bar.dart';

class AboutPage extends StatefulWidget {
  AboutPage({
    Key? key,
  }) : super(key: key);

  final String title = '关于';

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  PackageInfo? _packageInfo;
  @override
  void initState() {
    super.initState();

    _initInfo();
  }

  void _initInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    if (mounted) {
      setState(() {
        _packageInfo = packageInfo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(title: widget.title),
        body: new Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'VVEX',
                  style: TextStyle(fontSize: 48),
                ),
                ...(_packageInfo != null
                    ? [
                        Text(
                          'Version: ${_packageInfo!.version}-${_packageInfo!.buildNumber}',
                          style: TextStyle(fontSize: 28),
                        ),
                      ]
                    : [])
              ],
            ),
          ),
        ));
  }
}
