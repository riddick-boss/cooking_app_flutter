import 'package:cooking_app_flutter/domain/navigation/main_app_nav.dart';
import 'package:flutter/material.dart';

class DishesFAB extends StatelessWidget {
  const DishesFAB({super.key});

  @override
  Widget build(BuildContext context) => FloatingActionButton(
    onPressed: () {
      MainAppNav.navigator.currentState?.pushNamed(MainAppNavDestinations.addDish.route);
    },
    backgroundColor: Colors.indigoAccent,
    child: const Icon(Icons.add),
  );
}
