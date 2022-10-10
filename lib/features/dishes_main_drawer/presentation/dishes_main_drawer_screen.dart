import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/navigation/main_app_nav.dart';
import 'package:cooking_app_flutter/domain/presentation/widget/glass_box.dart';
import 'package:cooking_app_flutter/features/dishes_main_drawer/presentation/bottom_bar_screens.dart';
import 'package:cooking_app_flutter/features/dishes_main_drawer/presentation/dishes_main_drawer_vm.dart';
import 'package:cooking_app_flutter/features/dishes_main_drawer/presentation/widget/bottom_bar.dart';
import 'package:flutter/material.dart';

class DishesMainDrawerScreen extends StatefulWidget {
  const DishesMainDrawerScreen({super.key});

  @override
  State createState() => _DishesMainDrawerScreenState();
}

class _DishesMainDrawerScreenState extends State<DishesMainDrawerScreen> {
  final _viewModel = getIt<DishesMainDrawerViewModel>();

  //bottom bar nav
  int _currentBottomIndex = 0;
  void _onBottomBarIconTap(int index) {
    setState(() {
      _currentBottomIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _viewModel.logoutStream.listen((_) {
      MainAppNav.navigator.currentState?.pushNamedAndRemoveUntil(MainAppNavDestinations.login.route, (route) => false); // clear stack and go to login screen
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.blue[900],
        extendBody: true,
        bottomNavigationBar: GlassBox(
          child: BottomBar(
            index: _currentBottomIndex,
            onTap: _onBottomBarIconTap,
          ),
        ),
        body: BottomBarScreen.values.screens[_currentBottomIndex],
        floatingActionButton: BottomBarScreen.values[_currentBottomIndex].fab,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
}
