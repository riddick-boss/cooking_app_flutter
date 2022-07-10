import 'package:cooking_app_flutter/core/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/core/navigation/main_drawer/main_drawer.dart';
import 'package:cooking_app_flutter/core/navigation/navigator_util.dart';
import 'package:cooking_app_flutter/firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
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
      );
}
