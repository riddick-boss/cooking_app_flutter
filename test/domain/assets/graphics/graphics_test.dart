import 'package:cooking_app_flutter/domain/assets/graphics/graphics.dart';
import 'package:test/test.dart';

void main() {
  test("all paths different", () {
    final paths = Graphics.values.map((e) => e.path);
    final pathsSet = paths.toSet();
    expect(paths.length, pathsSet.length);
  });
}
