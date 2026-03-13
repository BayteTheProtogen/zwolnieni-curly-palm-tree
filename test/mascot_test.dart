import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyber_secure_app/widgets/mascot.dart';

void main() {
  testWidgets('CyberMascot displays correct ASCII face', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CyberMascot(expression: MascotExpression.happy),
        ),
      ),
    );

    expect(find.text('( ^ ◡ ^ )'), findsOneWidget);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CyberMascot(expression: MascotExpression.sad),
        ),
      ),
    );

    expect(find.text('( u _ u )'), findsOneWidget);
  });
}
