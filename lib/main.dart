import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MyApp(showOnboarding: showOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool showOnboarding;

  const MyApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return MaterialApp(
          title: 'CyberBezpieczni',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: appProvider.highContrast ? Colors.black : const Color(0xFF1A237E),
              primary: appProvider.highContrast ? Colors.black : const Color(0xFF1A237E), // Deep Navy
              secondary: appProvider.highContrast ? Colors.yellow : const Color(0xFF2962FF), // Bright Blue
              surface: appProvider.highContrast ? Colors.white : const Color(0xFFF5F7FA),
              onSurface: appProvider.highContrast ? Colors.black : Colors.black,
            ),
            useMaterial3: true,
            textTheme: GoogleFonts.lexendTextTheme().apply(
              fontSizeFactor: appProvider.fontSizeMultiplier,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          home: showOnboarding ? const OnboardingScreen() : const HomeScreen(),
        );
      },
    );
  }
}

// Color constant for easier use
const Color kNavy = Color(0xFF1A237E);
const Color kLightBlue = Color(0xFFE3F2FD);
const Color kAccentBlue = Color(0xFF2962FF);
const Color kSuccessGreen = Color(0xFF4CAF50);
const Color kErrorRed = Color(0xFFF44336);
