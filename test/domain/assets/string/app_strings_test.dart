import 'package:cooking_app_flutter/domain/assets/string/app_strings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("main drawer welcome message returns expected result", () {
    expect(AppStrings.dishesMainDrawerWelcomeMessage("Name"), 'Hi, Name 😃');
  });

  test("add dish preparation time returns expected result", () {
    expect(AppStrings.addDishPreparationTime(321), 'Preparation time: 321');
  });

  test("account title returns only title when name is null", () {
    expect(AppStrings.accountTitle(null), "Hi!");
  });

  test("account title returns title with name when name is given", () {
    expect(AppStrings.accountTitle("DummyName"), "Hi, \nDummyName");
  });
}
