import 'package:rxdart/subjects.dart';

extension BehaviorSubjectListExtension<T> on BehaviorSubject<List<T>> {
  void addElement(T element) {
    final updatedList = List<T>.from(value)..add(element);
    add(updatedList);
  }

  void removeElement(T element) {
    final updatedList = List<T>.from(value)..remove(element);
    add(updatedList);
  }

  void removeElementWhere(bool Function(T) condition) {
    final updatedList = List<T>.from(value)..removeWhere(condition);
    add(updatedList);
  }
}
