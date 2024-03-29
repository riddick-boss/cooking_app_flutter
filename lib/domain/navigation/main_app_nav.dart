import 'package:cooking_app_flutter/features/add_dish/presentation/add_dish_screen.dart';
import 'package:cooking_app_flutter/features/dish/presentation/dish_screen.dart';
import 'package:cooking_app_flutter/features/login/presentation/login_screen.dart';
import 'package:cooking_app_flutter/features/main/presentation/main_screen.dart';
import 'package:cooking_app_flutter/features/sign_up/presentation/sign_up_screen.dart';
import 'package:flutter/material.dart';

class MainAppNav { // TODO: named routes are no longer recommended (https://docs.flutter.dev/development/ui/navigation)
  static GlobalKey<NavigatorState> navigator = GlobalKey();

  static const destinations = MainAppNavDestinations.values;
  
  static final routesMap = { for (var dest in destinations) dest.route : (BuildContext context) => dest.screen(context) };
}

enum MainAppNavDestinations {
  login,
  signUp,
  main,
  addDish,
  userDish,
}

extension Route on MainAppNavDestinations {
  String get route {
    switch(this) {
      case MainAppNavDestinations.login: return "/mainAppNav/login";
      case MainAppNavDestinations.signUp: return "/mainAppNav/signUp";
      case MainAppNavDestinations.main: return "/mainAppNav/dishesMainDrawer";
      case MainAppNavDestinations.addDish: return "/mainAppNav/addDish";
      case MainAppNavDestinations.userDish: return "/mainAppNav/userDish";
    }
  }
}

extension Screen on MainAppNavDestinations {
  Widget screen(BuildContext context) {
    switch(this) {
      case MainAppNavDestinations.login: return const LoginScreen();
      case MainAppNavDestinations.signUp: return const SignUpScreen();
      case MainAppNavDestinations.main: return const MainScreen();
      case MainAppNavDestinations.addDish: return const AddDishScreen();
      case MainAppNavDestinations.userDish: return const DishScreen();
    }
  }
}
