import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/ingredient.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("ingredient initialized properly", () {
    const name = "Name";
    const quantity = "Quantity";
    final ingredient = Ingredient(name: name, quantity: quantity);
    expect(ingredient.name, name);
    expect(ingredient.quantity, quantity);
  });
}
