import 'package:cooking_app_flutter/domain/util/extension/string_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("isNullOrEmpty returns true when null", () {
    const String? nullString = null;
    expect(nullString.isNullOrEmpty, true);
  });

  test("isNullOrEmpty returns true when empty", () {
    const emptyString = "";
    expect(emptyString.isNullOrEmpty, true);
  });

  test("isNullOrEmpty returns false when not null nor empty", () {
    const text = "dummyText ";
    expect(text.isNullOrEmpty, false);
  });

  test("orEmpty returns empty when null", () {
    const String? nullString = null;
    expect(nullString.orEmpty, "");
  });

  test("orEmpty returns same string when not null", () {
    String? txt;
    txt = "nonNull";
    expect(txt.orEmpty, txt);
  });

  test("orEmpty returns same string when blank", () {
    String? txt;
    txt = "            "; // DO NOT CHANGE: intentionally left blank
    expect(txt.orEmpty, txt);
  });

  test("isBlankOrEmpty returns true when blank", () {
    const txt = "     "; // DO NOT CHANGE: intentionally left blank
    expect(txt.isBlankOrEmpty, true);
  });

  test("isBlankOrEmpty returns true when empty", () {
    const txt = "";
    expect(txt.isBlankOrEmpty, true);
  });

  test("isBlankOrEmpty returns false when filled", () {
    const txt = "dummyFilledText";
    expect(txt.isBlankOrEmpty, false);
  });
}
