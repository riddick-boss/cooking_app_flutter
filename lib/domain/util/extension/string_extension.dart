extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;
  String get orEmpty => this ?? "";
}

extension StringExtension on String {
  bool get isBlankOrEmpty => trim().isEmpty;
}
