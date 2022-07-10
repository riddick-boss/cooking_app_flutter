import 'package:cooking_app_flutter/core/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/core/navigation/main_drawer/main_drawer.dart';
import 'package:cooking_app_flutter/core/navigation/navigator_util.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      MaterialApp(
        title: AppStrings.appName,
        navigatorKey: NavigatorUtil.mainAppNav,
        theme: ThemeData(
          primarySwatch: Colors.blue, // TODO
        ),
        // home: const HomeScreen(),
        initialRoute: "/",
        routes: {
          "/": (context) => const HomeScreen(),
        },
        // home: Navigator(
        //   key: NavigatorUtil.mainAppNav,
        //   initialRoute: "/",
        //   onGenerateRoute: (RouteSettings settings) {
        //     WidgetBuilder builder;
        //
        //     switch(settings.name) {
        //       case "/mainAppNav/main_drawer":
        //         builder = (BuildContext _) => const HomeScreen();
        //         break;
        //       default:
        //         throw Exception("Invalid route: ${settings.name}");
        //     }
        //
        //     return MaterialPageRoute(builder: builder, settings: settings);
        //   },
        // ),
      );
}