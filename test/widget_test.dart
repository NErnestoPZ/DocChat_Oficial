import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:DocChat_Oficial/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    //Verifica que el contador inicie en 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Verifica cada vez que alguien toque un icono o active un marco/frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifica que nuestro contador se este incrementando.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
