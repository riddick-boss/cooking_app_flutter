import 'package:flutter/material.dart';

class MainAppNav {
  static GlobalKey<NavigatorState> navigator = GlobalKey();

  static const String loginRoute = "/mainAppNav/login";
  static const String signUpRoute = "/mainAppNav/signUp";
  static const String dishesMainDrawerRoute = "/mainAppNav/dishesMainDrawer";
}