import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cyber_secure_app/main.dart';
import 'package:provider/provider.dart';
import 'package:cyber_secure_app/providers/app_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppProvider(),
        child: const CyberApp(startScreen: Scaffold(body: Text('Test'))),
      ),
    );
    expect(find.text('Test'), findsOneWidget);
  });
}
