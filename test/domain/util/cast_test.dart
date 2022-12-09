import 'package:cooking_app_flutter/domain/util/cast.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("cast returns casted type when superType", () {
    dynamic dynVar = "number";
    dynVar = 1;
    final casted = cast<int>(dynVar);
    expect(casted.runtimeType, int);
  });

  test("cast returns null when not superType", () {
    dynamic dynVar = 1;
    dynVar = "number";
    final casted = cast<int>(dynVar);
    expect(casted, null);
  });
}
