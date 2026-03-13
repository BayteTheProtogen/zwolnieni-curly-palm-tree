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

    // Neon Colors
    const Color neonCyan = Color(0xFF00FFE0);
    const Color darkBg = Color(0xFF0A0C10);
    const Color cardBg = Color(0xFF161B22);

    return MaterialApp(
      title: 'CyberBezpieczni',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkBg,
        primaryColor: neonCyan,
        colorScheme: const ColorScheme.dark(
          primary: neonCyan,
          secondary: Color(0xFF007BFF),
          surface: cardBg,
          onSurface: Colors.white,
        ),
        textTheme: GoogleFonts.lexendTextTheme(ThemeData.dark().textTheme).apply(
          fontSizeFactor: appProvider.fontSizeMultiplier,
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: neonCyan,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            shadowColor: neonCyan.withValues(alpha: 0.5),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: neonCyan.withValues(alpha: 0.1), width: 1),
          ),
        ),
      ),
      home: startScreen,
    );
  }
}
