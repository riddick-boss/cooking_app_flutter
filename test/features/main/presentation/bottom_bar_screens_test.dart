import 'package:cooking_app_flutter/features/main/presentation/bottom_bar_screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
   test("all labels different", () {
     final labels = BottomBarScreen.values.map((e) => e.bottomBarItem.label);
     final labelsSet = labels.toSet();
     expect(labels.length, labelsSet.length);
   });

   test("all icons different", () {
     final icons = BottomBarScreen.values.map((e) => (e.bottomBarItem.icon as Icon).icon);
     final iconsSet = icons.toSet();
     expect(icons.length, iconsSet.length);
   });
   
   test("bottomBarItems contains all items in same order", () {
     final items = BottomBarScreen.values.map((e) => e.bottomBarItem).toList();
     expect(listEquals(items, BottomBarScreen.values.bottomBarItems), true);
     expect(BottomBarScreen.values.bottomBarItems.first.label, "Food");
     expect(BottomBarScreen.values.bottomBarItems.last.label, "Account");
   });

   test("all screens different", () {
     final screens = BottomBarScreen.values.screens.map((e) => e.runtimeType);
     final screensSet = screens.toSet();
     expect(screens.length, screensSet.length);
   });

   test("bottomBarItems contains all items in same order", () {
     final items = BottomBarScreen.values.map((e) => e.screen).toList();
     expect(listEquals(items, BottomBarScreen.values.screens), true);
     expect(BottomBarScreen.values.screens.first.runtimeType.toString(), "DishesScreen");
     expect(BottomBarScreen.values.screens.last.runtimeType.toString(), "AccountScreen");
   });

   test("dishes list has specified FAB", () {
     expect(BottomBarScreen.dishes.fab != null, true);
   });

   test("account has NOT specified FAB", () {
     expect(BottomBarScreen.account.fab == null, true);
   });
}
