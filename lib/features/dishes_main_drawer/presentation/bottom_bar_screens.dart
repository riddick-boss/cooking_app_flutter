import 'package:cooking_app_flutter/features/account/presentation/account_screen.dart';
import 'package:cooking_app_flutter/features/dishes/presentation/dishes_screen.dart';
import 'package:cooking_app_flutter/features/dishes_main_drawer/presentation/widget/dishes_fab.dart';
import 'package:flutter/material.dart';

enum BottomBarScreen {
  dishes,
  // shopping,
  account
}

extension BottomBarItem on BottomBarScreen {
  BottomNavigationBarItem get bottomBarItem {
    switch(this) {
      case BottomBarScreen.dishes:
        return const BottomNavigationBarItem(icon: Icon(Icons.food_bank_outlined), label: "Food");
      // case BottomBarScreen.shopping:
      //   return const BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: "Shopping");
      case BottomBarScreen.account:
        return const BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: "Account");
    }
  }
}

extension BottomBarItems on List<BottomBarScreen> {
  List<BottomNavigationBarItem> get bottomBarItems => map((item) => item.bottomBarItem).toList();
}

extension Screen on BottomBarScreen {
  Widget get screen {
    switch(this) {
      case BottomBarScreen.dishes:
        return const DishesScreen();
      // case BottomBarScreen.shopping:
        // return Center(child: Text("Shopping"),);
      case BottomBarScreen.account:
        return const AccountScreen();
    }
  }
}

extension BottomBarScreens on List<BottomBarScreen> {
  List<Widget> get screens => map((item) => item.screen).toList();
}

extension BottomBarFAB on BottomBarScreen {
  Widget? get fab {
    switch(this) {
      case BottomBarScreen.dishes:
        return const DishesFAB();
      // case BottomBarScreen.shopping:
      //   return null;
      case BottomBarScreen.account:
        return null;
    }
  }
}
