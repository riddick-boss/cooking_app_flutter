import 'package:flutter/material.dart';

class LocalDishesNav {
  static GlobalKey<NavigatorState> localDishesNav = GlobalKey();

  static const String registrationRoute = "/";
  static const String dishesListRoute = "/localDishesNav/dishes_list";
}