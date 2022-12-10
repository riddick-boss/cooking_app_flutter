import 'package:cooking_app_flutter/domain/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("snackBar is show once", (WidgetTester tester) async {
    const txt = "Dummy message";
    const tapTarget = Key("tap-target");
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                key: tapTarget,
                onTap: () {
                  showSnackBar(context, txt);
                },
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(tapTarget));
    await tester.pump();

    expect(find.text(txt), findsOneWidget);
  });
}
