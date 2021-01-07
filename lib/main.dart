import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:vvex/pages/login_page.dart';
import 'package:vvex/pages/home_tab/home_tab.dart';
import 'package:vvex/providers/user_state.dart';
import 'package:vvex/widgets/home_drawer/home_drawer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserState()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VVEX',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'VVEX'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final floatingActionButton =
        Consumer<UserState>(builder: (context, userState, child) {
      return userState.logged
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginPage(title: '登录')),
                );
              },
              tooltip: 'New Topic',
              child: Icon(Icons.add),
            )
          : SizedBox();
    });

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: HomeDrawer(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[Flexible(child: HomeTab())],
        ),
        floatingActionButton:
            floatingActionButton is SizedBox ? null : floatingActionButton);
  }
}
