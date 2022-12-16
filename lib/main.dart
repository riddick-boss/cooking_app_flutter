import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/domain/infrastructure/main_initializer/main_initializer.dart';
import 'package:cooking_app_flutter/domain/navigation/main_app_nav.dart';
import 'package:cooking_app_flutter/domain/navigation/main_nav_launcher.dart';
import 'package:cooking_app_flutter/domain/presentation/loading/eay_loading_configurator.dart';
import 'package:cooking_app_flutter/domain/presentation/theme/colors.dart';
import 'package:flutter/material.dart';

Future<dynamic> main() async {
  await MainInitializer.init();

  final initialRoute = getIt<MainNavLauncher>().initialRoute;

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
        ),
        initialRoute: initialRoute,
        routes: MainAppNav.routesMap,
        builder: EasyLoadingConfigurator.config(),
      );
}
