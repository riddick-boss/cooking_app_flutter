import 'package:cooking_app_flutter/core/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/core/navigation/main_drawer/main_drawer.dart';
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
        theme: ThemeData(
          primarySwatch: Colors.blue, // TODO
        ),
        home: const HomeScreen(),
      );
}