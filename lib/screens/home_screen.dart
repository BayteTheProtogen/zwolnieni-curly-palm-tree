import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../data/lesson_data.dart';
import '../models/lesson_models.dart';
import 'lesson_screen.dart';
import 'profile_screen.dart';
import '../widgets/mascot.dart';
import '../utils/transitions.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    LessonMap(),
    Placeholder(child: Center(child: Text('Słowniczek'))),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color neonCyan = Color(0xFF00FFE0);

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: neonCyan.withValues(alpha: 0.1), width: 1)),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF0A0C10),
          selectedItemColor: neonCyan,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Ścieżka'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Słownik'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}

class LessonMap extends StatelessWidget {
  const LessonMap({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                expandedHeight: 250,
                backgroundColor: const Color(0xFF0A0C10),
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      const CyberMascot(
                        expression: MascotExpression.neutral,
                        size: 120,
                        showContainer: false,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Gotowy na lekcję?',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('CyberBezpieczni',
                      style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 18)),
                    Row(
                      children: [
                        _buildStatChip(Icons.local_fire_department, '${provider.streak}', Colors.orange),
                        const SizedBox(width: 8),
                        _buildStatChip(Icons.stars, '${provider.xp}', Colors.amber),
                      ],
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, moduleIndex) {
                      final module = cybersecurityModules[moduleIndex];
                      return ModuleSection(module: module, moduleIndex: moduleIndex);
                    },
                    childCount: cybersecurityModules.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

class ModuleSection extends StatelessWidget {
  final CybersecurityModule module;
  final int moduleIndex;

  const ModuleSection({super.key, required this.module, required this.moduleIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            module.title.toUpperCase(),
            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
        ),
        ...List.generate(module.lessons.length, (index) {
          final lesson = module.lessons[index];
          double offset = math.sin(index * 1.5) * 60;
          bool isLast = index == module.lessons.length - 1;

          return LessonNode(
            lesson: lesson,
            offset: offset,
            showLine: !isLast || (moduleIndex < cybersecurityModules.length - 1),
          );
        }),
      ],
    );
  }
}

class LessonNode extends StatelessWidget {
  final Lesson lesson;
  final double offset;
  final bool showLine;

  const LessonNode({
    super.key,
    required this.lesson,
    required this.offset,
    required this.showLine,
  });

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final bool isCompleted = appProvider.completedLessons.contains(lesson.id);
    const Color neonCyan = Color(0xFF00FFE0);

    return Column(
      children: [
        Transform.translate(
          offset: Offset(offset, 0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MagicMoveRoute(page: LessonScreen(lesson: lesson)),
                  );
                },
                child: Hero(
                  tag: 'lesson_${lesson.id}',
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted ? neonCyan : const Color(0xFF161B22),
                      border: Border.all(
                        color: isCompleted ? neonCyan : Colors.grey.withValues(alpha: 0.3),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isCompleted ? neonCyan : Colors.white).withValues(alpha: 0.1),
                          blurRadius: 15,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : _getIconForModule(lesson.id),
                      color: isCompleted ? Colors.black : Colors.grey,
                      size: 35,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxWidth: 120),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  lesson.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showLine)
          Container(
            height: 50,
            width: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  isCompleted ? neonCyan : Colors.grey.withValues(alpha: 0.3),
                  Colors.grey.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
      ],
    );
  }

  IconData _getIconForModule(String lessonId) {
    if (lessonId.contains('pass')) return Icons.lock;
    if (lessonId.contains('phishing')) return Icons.email;
    if (lessonId.contains('bank')) return Icons.account_balance;
    return Icons.security;
  }
}
