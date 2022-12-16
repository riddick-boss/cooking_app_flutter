import 'package:cooking_app_flutter/domain/infrastructure/url_validation/url_validator.dart';
import 'package:test/test.dart';

void main() {
  test("should return false with invalid url", () {
    final isValid = UrlValidator.isValid("cooking_app_flutter/domain/infrastructure/url_validation/url_validator.dart"); // invalid url

    expect(isValid, false);
  });

  test("should return true with valid url", () {
    final isValid = UrlValidator.isValid("https://docs.flutter.dev/cookbook/testing/unit/introduction"); // valid url

    expect(isValid, true);
  });
}
