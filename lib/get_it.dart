import 'package:get_it/get_it.dart';
import 'package:vvex/services/navigation_service.dart';
import 'package:vvex/services/user_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerSingleton(UserService(), signalsReady: true);
}
