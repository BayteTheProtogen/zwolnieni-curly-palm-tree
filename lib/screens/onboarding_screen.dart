import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_provider.dart';
import '../widgets/mascot.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Witaj w CyberBezpieczni!',
      description: 'Razem nauczymy się, jak bezpiecznie poruszać się po internecie.',
      expression: MascotExpression.happy,
    ),
    OnboardingData(
      title: 'Dostosuj aplikację',
      description: 'Dla Twojej wygody możesz powiększyć tekst i zmienić kontrast.',
      expression: MascotExpression.thinking,
      isAccessibilityPage: true,
    ),
    OnboardingData(
      title: 'Zaczynajmy!',
      description: 'Czekają na Ciebie krótkie lekcje i ciekawe zadania.',
      expression: MascotExpression.dancing,
    ),
  ];

  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color neonCyan = Color(0xFF00FFE0);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) => setState(() => _currentPage = page),
                itemCount: _pages.length,
                itemBuilder: (context, index) => _OnboardingPage(data: _pages[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index ? neonCyan : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        _finishOnboarding();
                      }
                    },
                    child: Text(_currentPage == _pages.length - 1 ? 'START' : 'DALEJ'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final MascotExpression expression;
  final bool isAccessibilityPage;

  OnboardingData({
    required this.title,
    required this.description,
    required this.expression,
    this.isAccessibilityPage = false,
  });
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CyberMascot(expression: data.expression, size: 200),
          const SizedBox(height: 48),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          if (data.isAccessibilityPage) ...[
            const SizedBox(height: 32),
            const Text('Wielkość tekstu', style: TextStyle(color: Colors.white70)),
            Slider(
              value: provider.fontSizeMultiplier,
              min: 1.0,
              max: 2.0,
              onChanged: (val) => provider.setFontSizeMultiplier(val),
              activeColor: const Color(0xFF00FFE0),
            ),
          ],
        ],
      ),
    );
  }
}
