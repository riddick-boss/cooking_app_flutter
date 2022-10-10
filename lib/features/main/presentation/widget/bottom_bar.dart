import 'package:cooking_app_flutter/features/main/presentation/bottom_bar_screens.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.index, required this.onTap});
  final int index;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        currentIndex: index,
        onTap: onTap,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[300],
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: BottomBarScreen.values.bottomBarItems,
      );
}
