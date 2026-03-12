import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/mascot.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildPage(
                    title: 'Witaj!',
                    description: 'Jestem Twoim przewodnikiem po świecie cyberbezpieczeństwa.',
                    expression: MascotExpression.happy,
                  ),
                  _buildPage(
                    title: 'Bezpieczeństwo jest proste',
                    description: 'Nauczysz się jak rozpoznawać oszustwa i chronić swoje pieniądze.',
                    expression: MascotExpression.neutral,
                  ),
                  _buildAccessibilityPage(),
                  _buildStartPage(),
                ],
              ),
            ),
            _buildDots(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 8,
        width: _currentPage == index ? 24 : 8,
        decoration: BoxDecoration(
          color: _currentPage == index ? Theme.of(context).primaryColor : Colors.grey,
          borderRadius: BorderRadius.circular(4),
        ),
      )),
    );
  }

  Widget _buildPage({required String title, required String description, MascotExpression expression = MascotExpression.neutral}) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'mascot_main',
            child: CyberMascot(expression: expression, size: 150),
          ).animate().scale(delay: 200.ms),
          const SizedBox(height: 48),
          Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Text(description, style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildAccessibilityPage() {
    final appProvider = Provider.of<AppProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CyberMascot(expression: MascotExpression.thinking, size: 120),
          const SizedBox(height: 32),
          const Text('Dostosujmy aplikację do Ciebie', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Slider(
                    value: appProvider.fontSizeMultiplier,
                    min: 1.0,
                    max: 1.8,
                    divisions: 4,
                    label: 'Wielkość tekstu',
                    onChanged: (val) => appProvider.setFontSizeMultiplier(val),
                  ),
                  const Text('Przesuń, aby powiększyć tekst'),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Wysoki kontrast'),
                    value: appProvider.highContrast,
                    onChanged: (value) => appProvider.setHighContrast(value),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartPage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CyberMascot(expression: MascotExpression.dancing, size: 150),
          const SizedBox(height: 48),
          const Text('Zaczynamy?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('seenOnboarding', true);
                if (mounted) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: const Text('Rozpocznij Naukę', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
