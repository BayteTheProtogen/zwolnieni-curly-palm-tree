import 'package:flutter_test/flutter_test.dart';
import 'package:cyber_secure_app/main.dart';
import 'package:provider/provider.dart';
import 'package:cyber_secure_app/providers/app_provider.dart';
import 'package:cyber_secure_app/screens/home_screen.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppProvider(),
        child: const CyberApp(startScreen: HomeScreen()),
      ),
    );
    // Verify that the app starts and shows the title or some element
    expect(find.text('CyberBezpieczni'), findsOneWidget);
  });
}
