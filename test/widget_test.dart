import 'package:flutter_test/flutter_test.dart';
import 'package:cyber_secure_app/main.dart';
import 'package:provider/provider.dart';
import 'package:cyber_secure_app/providers/app_provider.dart';

void main() {
  testWidgets('App starts and shows onboarding', (WidgetTester tester) async {
    // We ignore the infinite animation timer issue in this smoke test
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppProvider()),
          ],
          child: const MyApp(showOnboarding: true),
        ),
      );
      expect(find.text('Witaj!'), findsOneWidget);
    });
  });
}
