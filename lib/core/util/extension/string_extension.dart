extension NullableStringExtension on String? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;
}

extension StringExtension on String {
  bool get isBlankOrEmpty => trim().isEmpty;
}
