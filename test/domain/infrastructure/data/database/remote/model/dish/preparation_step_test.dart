import 'package:cooking_app_flutter/domain/infrastructure/data/database/remote/model/dish/preparation_step.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("preparation step compareTo sorting properly", () {
    final step1 = PreparationStep(name: "BBB", sortOrder: 0);
    final step2 = PreparationStep(name: "AAA", sortOrder: 1);
    final step3 = PreparationStep(name: "CCC", sortOrder: 2);

    final list = [step2, step3, step1]
      ..sort();

    expect(list.map((e) => e.name), [step1.name, step2.name, step3.name]);
    expect(list, [step1, step2, step3]);
  });
}
