import 'package:cooking_app_flutter/core/navigation/navigator_util.dart';
import 'package:cooking_app_flutter/features/registration/presentation/registration_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LocalDishesContainer extends StatelessWidget {
  const LocalDishesContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => WillPopScope(
      child: Navigator(
        key: NavigatorUtil.localDishesNav,
        initialRoute: "/",
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;

          switch (settings.name) {
            case "/":
              builder = (BuildContext _) => const RegistrationScreen();
              break;
            case "/localDishesNav/dishes_list":
              builder = (BuildContext _) => const Text("dishes_list");
              break;
            default:
              throw Exception("Invalid route: ${settings.name}");
          }

          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
      onWillPop: () async {
        if (kDebugMode) {
          print("current state ${NavigatorUtil.localDishesNav.currentState}");
        }
        if (NavigatorUtil.localDishesNav.currentState != null) {
          final bool shouldPop = await NavigatorUtil.localDishesNav.currentState!.maybePop();
          return !shouldPop;
        }
        return true;
      });
}