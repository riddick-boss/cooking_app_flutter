extension ListExtension<T> on List<T> {
  void reorder(int oldIndex, int newIndex) {
    final element = removeAt(oldIndex);
    insert(newIndex, element);
  }
}

extension ListComparableExtension<T extends Comparable<T>> on List<T> {
  List<T> sorted() {
    sort();
    return this;
  }
}
