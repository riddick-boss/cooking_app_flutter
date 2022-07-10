import 'package:cooking_app_flutter/core/navigation/main_drawer/main_drawer_screen.dart';
import 'package:cooking_app_flutter/core/navigation/navigator_util.dart';
import 'package:flutter/material.dart';

// home screen

class HomeScreen extends StatelessWidget {

  final MainDrawerScreen startScreen = MainDrawerScreen.local;

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => HomeScreenContent(screen: startScreen);
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({Key? key, required this.screen}) : super(key: key);

  final MainDrawerScreen screen;

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenContent> {
  late MainDrawerScreen _screen = widget.screen;

  void onDrawerItemClick(MainDrawerScreen screen) {
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
  const MainDrawer({Key? key, required this.onItemClick}) : super(key: key);

  final void Function(MainDrawerScreen screen) onItemClick;

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

    for (var element in MainDrawerScreen.values) {
      list.add(buildMenuItem(screen: element, context: context));
    }

    // list.add(const Spacer());

    return list;
  }

  Widget buildMenuItem({required MainDrawerScreen screen, required BuildContext context}) =>
      ListTile(
        title: Text(
          screen.title,
          style: const TextStyle(color: Colors.white), // TODO: color
        ),
        hoverColor: Colors.white70,
        onTap: () {
          onItemClick(screen);
          NavigatorUtil.mainAppNav.currentState?.pop(); // close drawer
        },
      );
}