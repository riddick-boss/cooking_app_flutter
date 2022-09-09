// ignore_for_file: cascade_invocations

import 'package:cooking_app_flutter/domain/util/extension/behavior_subject_list_extension.dart';
import 'package:rxdart/subjects.dart';
import 'package:test/test.dart';

void main() {
  late BehaviorSubject<List<String>> subject;
  
  setUp(() {
    subject = BehaviorSubject<List<String>>.seeded(List.empty());
  });

  tearDown(() async {
    await subject.close();
  });
  
  test("addElement adds element to existing list", () {
    final initialSize = subject.value.length;
    subject.addElement("any element");
    final finalSize = subject.value.length;

    expect(initialSize, finalSize - 1); // 1 added element
  });

  test("removeElement removes existing element", () {
    const elementToTest = "element2";
    final initialList = ["element1", elementToTest, "element3"];
    final initialSize = initialList.length;
    subject.add(initialList);

    subject.removeElement(elementToTest);

    final finalSize = subject.value.length;

    expect(initialSize, finalSize + 1); // 1 removed element
  });

  test("removeElement does not throw exception when removing non-existing element", () {
    const nonExistingElement = "nonExistingElement";
    final initialList = ["element1", "element2", "element3"];
    final initialSize = initialList.length;
    subject.add(initialList);

    Object? exception;

    try {
      subject.removeElement(nonExistingElement);
    } catch(e) {
      exception = e;
    }

    final finalSize = subject.value.length;

    expect(exception, null);
    expect(initialSize, finalSize); // 0 removed elements
  });

  test("removeElementWhere removes elements matching condition", () {
    final initialList = ["element1", "el3ment", "element2", "element3"];
    final initialSize = initialList.length;
    subject.add(initialList);


    subject.removeElementWhere((p0) => p0.contains("3")); // remove elements containing "3"

    final finalSize = subject.value.length;

    expect(initialSize, finalSize + 2); // 2 removed elements
  });
}
