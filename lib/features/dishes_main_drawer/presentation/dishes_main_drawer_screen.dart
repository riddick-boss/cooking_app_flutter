import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/assets/string/app_strings.dart';
import 'package:cooking_app_flutter/domain/navigation/main_app_nav.dart';
import 'package:cooking_app_flutter/features/dishes_main_drawer/presentation/dishes_main_drawer_vm.dart';
import 'package:cooking_app_flutter/features/dishes_main_drawer/presentation/screens.dart';
import 'package:flutter/material.dart';

class DishesMainDrawerScreen extends StatefulWidget {
  const DishesMainDrawerScreen({super.key});

  @override
  State createState() => _DishesMainDrawerScreenState();
}

class _DishesMainDrawerScreenState extends State<DishesMainDrawerScreen> {
  final _viewModel = getIt<DishesMainDrawerViewModel>();

  late DishesMainDrawerScreens _screen = DishesMainDrawerScreens.myDishes;

  void onDrawerItemClick(DishesMainDrawerScreens screen) {
    setState(() {
      _screen = screen;
    });
  }

  @override
  void initState() {
    super.initState();

    _viewModel.onNavigateToLogInScreenStream.listen((event) {
      MainAppNav.navigator.currentState?.pushNamedAndRemoveUntil(MainAppNav.loginRoute, (route) => false); // clear stack and go to login screen
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(_screen.title),
    ),
    drawer: MainDrawer(
      onItemClick: onDrawerItemClick, viewModel: _viewModel,
    ),
    body: _screen.body,
    floatingActionButton: const DishesDrawerFAB(),
  );
}

// main drawer

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onItemClick, required this.viewModel});

  final void Function(DishesMainDrawerScreens screen) onItemClick;

  final DishesMainDrawerViewModel viewModel;

  @override
  Widget build(BuildContext context) => Drawer( // TODO: use floating drawer (or similar)
    child: Material(
      color: Colors.blueAccent, // TODO: color
      child: Column(
        children: buildMainMenuList(context),
      ),
    ),
  );

  List<Widget> buildMainMenuList(BuildContext context) => [
        const SizedBox(height: 40),
        Text((viewModel.userDisplayValue == null) ? AppStrings.dishesMainDrawerDefaultWelcomeMessage : AppStrings.dishesMainDrawerWelcomeMessage(viewModel.userDisplayValue!)),
        const SizedBox(height: 40),
        ...buildScreensMenuItems(context),
        const Spacer(),
        LogoutListTile(signOut: viewModel.signOut)
      ];

  List<Widget> buildScreensMenuItems(BuildContext context) {
    final list = <Widget>[];

    for (final screen in DishesMainDrawerScreens.values) {
      list.add(buildMenuItem(screen: screen, context: context));
    }

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
  const LogoutListTile({super.key, required this.signOut});

  final Future<void> Function() signOut;

  @override
  Widget build(BuildContext context) =>
      ListTile(
        title: const Text(
          AppStrings.logoutTitle,
          style: TextStyle(color: Colors.white), // TODO: color
        ),
        hoverColor: Colors.white70,
        onTap: signOut,
      );
}

class DishesDrawerFAB extends StatelessWidget {
  const DishesDrawerFAB({super.key});

  @override
  Widget build(BuildContext context) => FloatingActionButton(
    onPressed: () {
      MainAppNav.navigator.currentState?.pushNamed(MainAppNav.addDishRoute);
    },
    backgroundColor: Colors.indigoAccent,
    child: const Icon(Icons.add),
  );
}
