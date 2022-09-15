import 'package:cooking_app_flutter/domain/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/features/dishes/presentation/dishes_screen.dart';
import 'package:flutter/cupertino.dart';

enum DishesMainDrawerScreens { myDishes, public }

extension Title on DishesMainDrawerScreens {
  String get title {
    switch (this) {
      case DishesMainDrawerScreens.myDishes:
        return AppStrings.myDishesTitle;
      case DishesMainDrawerScreens.public:
        return AppStrings.publicTitle;
    }
  }
}

extension Body on DishesMainDrawerScreens {
  Widget get body {
    // todo: widgets
    switch (this) {
      case DishesMainDrawerScreens.myDishes:
        return const DishesScreen();
      case DishesMainDrawerScreens.public:
        return Text(title);
    }
  }
}
