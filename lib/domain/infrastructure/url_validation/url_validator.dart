class UrlValidator {
  static bool isValid(String uri) =>
      Uri.tryParse(uri)?.host.isNotEmpty ?? false;
}
