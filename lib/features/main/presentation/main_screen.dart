import 'package:cooking_app_flutter/di/cooking_app_injection.dart';
import 'package:cooking_app_flutter/domain/navigation/main_app_nav.dart';
import 'package:cooking_app_flutter/domain/presentation/widget/glass_box.dart';
import 'package:cooking_app_flutter/features/main/presentation/bottom_bar_screens.dart';
import 'package:cooking_app_flutter/features/main/presentation/main_vm.dart';
import 'package:cooking_app_flutter/features/main/presentation/widget/bottom_bar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _viewModel = getIt<MainViewModel>();

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
