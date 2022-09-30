import 'package:cooking_app_flutter/features/add_dish/presentation/add_dish_screen.dart';
import 'package:cooking_app_flutter/features/dishes_main_drawer/presentation/dishes_main_drawer_screen.dart';
import 'package:cooking_app_flutter/features/login/presentation/login_screen.dart';
import 'package:cooking_app_flutter/features/sign_up/presentation/sign_up_screen.dart';
import 'package:flutter/material.dart';

class MainAppNav {
  static GlobalKey<NavigatorState> navigator = GlobalKey();

  static const destinations = MainAppNavDestinations.values;
  
  static final routesMap = { for (var e in destinations) e.route : (BuildContext context) => e.screen(context) };
}

enum MainAppNavDestinations {
  login,
  signUp,
  dishesMainDrawer,
  addDish,
  userDish,
}

extension Route on MainAppNavDestinations {
  String get route {
    switch(this) {
      case MainAppNavDestinations.login: return "/mainAppNav/login";
      case MainAppNavDestinations.signUp: return "/mainAppNav/signUp";
      case MainAppNavDestinations.dishesMainDrawer: return "/mainAppNav/dishesMainDrawer";
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
      case MainAppNavDestinations.dishesMainDrawer: return const DishesMainDrawerScreen();
      case MainAppNavDestinations.addDish: return const AddDishScreen();
      case MainAppNavDestinations.userDish: return const AddDishScreen(); //TODO
    }
  }
}
