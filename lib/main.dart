import 'package:cooking_app_flutter/core/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/core/assets/theme/colors.dart';
import 'package:cooking_app_flutter/core/domain/auth/manager/auth_manager.dart';
import 'package:cooking_app_flutter/core/navigation/main_app_nav.dart';
import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/features/add_dish/presentation/add_dish_screen.dart';
import 'package:cooking_app_flutter/features/dishes_main_drawer/presentation/dishes_main_drawer_screen.dart';
import 'package:cooking_app_flutter/features/login/presentation/login_screen.dart';
import 'package:cooking_app_flutter/features/sign_up/presentation/sign_up_screen.dart';
import 'package:cooking_app_flutter/firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<dynamic> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureInjection();

  final _authManager = getIt<AuthManager>();
  final initialRoute = _authManager.currentUser == null
      ? MainAppNav.loginRoute
      : MainAppNav.dishesMainDrawerRoute;

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
        routes: {
          MainAppNav.loginRoute: (context) => const LoginScreen(), // TODO: move to MainAppNav ?
          MainAppNav.signUpRoute: (context) => const SignUpScreen(),
          MainAppNav.dishesMainDrawerRoute: (context) => const DishesMainDrawerScreen(),
          MainAppNav.addDishRoute: (context) => const AddDishScreen(),
        },
      );
}
