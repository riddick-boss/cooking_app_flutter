// ignore_for_file: cascade_invocations

import 'package:cooking_app_flutter/domain/util/extension/list_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("reorder works correctly", () {
    const elem1 = "elem1";
    const elem2 = "elem2";
    const elem3 = "elem3";
    final list = [elem1, elem2, elem3];
    list.reorder(2, 1);
    expect(list, [elem1, elem3, elem2]);
  });

  test("sorted works correctly", () {
    const num elem1 = 1;
    const num elem2 = 2;
    const num elem3 = 3;
    final list = [elem2, elem1, elem3];
    final sortedList = list.sorted();
    expect(sortedList, [elem1, elem2, elem3]);
  });
}
