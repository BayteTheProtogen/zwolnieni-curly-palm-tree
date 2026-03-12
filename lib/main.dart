import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/app_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: CyberApp(startScreen: seenOnboarding ? const HomeScreen() : const OnboardingScreen()),
    ),
  );
}

class CyberApp extends StatelessWidget {
  final Widget startScreen;
  const CyberApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return MaterialApp(
      title: 'CyberBezpieczni',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E), // Deep Navy
          primary: const Color(0xFF1A237E),
          brightness: appProvider.highContrast ? Brightness.dark : Brightness.light,
        ),
        textTheme: GoogleFonts.lexendTextTheme().apply(
          fontSizeFactor: appProvider.fontSizeMultiplier,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: startScreen,
    );
  }
}
