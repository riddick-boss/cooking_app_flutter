import 'package:cooking_app_flutter/core/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/core/navigation/main_app_nav.dart';
import 'package:cooking_app_flutter/features/dishes_main_drawer/presentation/screens.dart';
import 'package:flutter/material.dart';

class DishesMainDrawerScreen extends StatefulWidget {
  const DishesMainDrawerScreen({super.key});

  @override
  State createState() => _DishesMainDrawerScreenState();
}

class _DishesMainDrawerScreenState extends State<DishesMainDrawerScreen> {

  late DishesMainDrawerScreens _screen = DishesMainDrawerScreens.myDishes;

  void onDrawerItemClick(DishesMainDrawerScreens screen) {
    setState(() {
      _screen = screen;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(_screen.title),
    ),
    drawer: MainDrawer(
      onItemClick: onDrawerItemClick,
    ),
    body: _screen.body,
  );
}

// main drawer

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onItemClick});

  final void Function(DishesMainDrawerScreens screen) onItemClick;

  @override
  Widget build(BuildContext context) => Drawer(
    child: Material(
      color: Colors.blueAccent, // TODO: color
      child: Column(
        children: buildMainMenuList(context),
      ),
    ),
  );

  List<Widget> buildMainMenuList(BuildContext context) {
    final list = <Widget>[];

    list.add(const SizedBox(height: 40,));

    for (var element in DishesMainDrawerScreens.values) {
      list.add(buildMenuItem(screen: element, context: context));
    }

    list.add(const Spacer());



    return list;
  }

  Widget buildMenuItem({required DishesMainDrawerScreens screen, required BuildContext context}) =>
      ListTile(
        title: Text(
          screen.title,
          style: const TextStyle(color: Colors.white), // TODO: color
        ),
        hoverColor: Colors.white70,
        onTap: () {
          onItemClick(screen);
          MainAppNav.navigator.currentState?.pop(); // close drawer
        },
      );
}

class LogoutListTile extends StatelessWidget {
  const LogoutListTile({super.key});

  @override
  Widget build(BuildContext context) =>
      ListTile(
        title: const Text(
          AppStrings.logoutTitle,
          style: TextStyle(color: Colors.white), // TODO: color
        ),
        hoverColor: Colors.white70,
        onTap: () {
        //  TODO: logout
          MainAppNav.navigator.currentState?.pushNamedAndRemoveUntil(MainAppNav.loginRoute, (route) => false); // clear stack and go to login screen
        },
      );
}