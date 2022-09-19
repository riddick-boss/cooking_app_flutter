import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/domain/infrastructure/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/domain/navigation/main_app_nav.dart';
import 'package:cooking_app_flutter/domain/presentation/theme/colors.dart';
import 'package:cooking_app_flutter/firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<dynamic> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureInjection();

  final _authManager = getIt<AuthManager>();
  final initialRoute = _authManager.currentUser == null
      ? MainAppNavDestinations.login.route
      : MainAppNavDestinations.dishesMainDrawer.route;

  runApp(
    MyApp(
      initialRoute: initialRoute,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: AppStrings.appName,
        navigatorKey: MainAppNav.navigator,
        theme: ThemeData(
          colorScheme: AppColors.defaultColorScheme,
          primarySwatch: Colors.blue, // TODO
        ),
        initialRoute: initialRoute,
        routes: MainAppNav.routesMap,
      );
}
