import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/user_state.dart';
import 'services/navigation_service.dart';
import 'router.dart' as router;
import 'get_it.dart';

void main() {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserState()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: locator<NavigationService>().navigatorKey,
      title: 'VVEX',
      onGenerateRoute: router.generateRoute,
      initialRoute: router.HomePageRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
