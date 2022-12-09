import 'package:cooking_app_flutter/domain/navigation/main_app_nav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class _BuildContextMock extends Mock implements BuildContext {}

void main() {
  test("all destinations have different routes", () {
    final routes = MainAppNav.destinations.map((dest) => dest.route);
    final routesSet = routes.toSet(); // remove duplicates
    expect(routes.length, routesSet.length);
  });
  
  test("all destinations have different screen", () {
    final BuildContext ctx = _BuildContextMock();
    final screens = MainAppNav.destinations.map((dest) => dest.screen(ctx).runtimeType);
    final screensSet = screens.toSet(); // remove duplicates
    expect(screens.length, screensSet.length);
  });

  test("routes map contains all routes", () {
    final routes = MainAppNav.destinations.map((dest) => dest.route);
    expect(MainAppNav.routesMap.keys, routes);
  });

  test("routes map contains all screens", () {
    final BuildContext ctx = _BuildContextMock();
    final screens = MainAppNav.destinations.map((dest) => dest.screen(ctx).runtimeType);
    expect(MainAppNav.routesMap.values.map((e) => e(ctx).runtimeType), screens);
  });
}
