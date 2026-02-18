import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../data/lesson_data.dart';
import '../models/lesson_models.dart';
import 'lesson_screen.dart';
import 'profile_screen.dart';
import '../widgets/mascot.dart';
import '../utils/transitions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    LessonMap(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Lekcje'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

class LessonMap extends StatelessWidget {
  const LessonMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const Hero(
        tag: 'mascot_main',
        child: CyberMascot(expression: MascotExpression.neutral, size: 80),
      ),
      appBar: AppBar(
        title: Consumer<AppProvider>(
          builder: (context, provider, _) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Twoja Ścieżka', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orange),
                  Text('${provider.streak}'),
                  const SizedBox(width: 16),
                  const Icon(Icons.stars, color: Colors.amber),
                  Text('${provider.xp} XP'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24),
        itemCount: appModules.length,
        itemBuilder: (context, moduleIndex) {
          final module = appModules[moduleIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  module.title.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1.2, color: Colors.grey),
                ),
              ),
              ...module.lessons.map((lesson) {
                return LessonNode(lesson: lesson, moduleColor: _getModuleColor(moduleIndex));
              }).toList(),
            ],
          );
        },
      ),
    );
  }

  Color _getModuleColor(int index) {
    final colors = [Colors.blue, Colors.indigo, Colors.teal, Colors.cyan];
    return colors[index % colors.length];
  }
}

class LessonNode extends StatelessWidget {
  final Lesson lesson;
  final Color moduleColor;

  const LessonNode({super.key, required this.lesson, required this.moduleColor});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final bool isCompleted = appProvider.completedLessons.contains(lesson.id);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: [
          Hero(
            tag: 'lesson_${lesson.id}',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MagicMoveRoute(page: LessonScreen(lesson: lesson)),
                  );
                },
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isCompleted ? moduleColor : Colors.grey[300],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isCompleted ? moduleColor : Colors.grey).withOpacity(0.4),
                        offset: const Offset(0, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            lesson.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
