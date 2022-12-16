import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/preparation_steps_group.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("preparation step group compareTo sorting properly", () {
    final group1 = PreparationStepsGroup(name: "BBB", sortOrder: 0, steps: List.empty());
    final group2 = PreparationStepsGroup(name: "AAA", sortOrder: 1, steps: List.empty());
    final group3 = PreparationStepsGroup(name: "CCC", sortOrder: 2, steps: List.empty());

    final list = [group2, group3, group1]
      ..sort();

    expect(list.map((e) => e.name), [group1.name, group2.name, group3.name]);
    expect(list, [group1, group2, group3]);
  });
}
