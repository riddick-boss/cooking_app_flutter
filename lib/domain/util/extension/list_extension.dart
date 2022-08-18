extension ListExtension<T extends Comparable<T>> on List<T> {
  List<T> sorted() {
    sort();
    return this;
  }
}
