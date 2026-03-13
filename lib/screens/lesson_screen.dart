import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_provider.dart';
import '../models/lesson_models.dart';
import '../widgets/mascot.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _currentTaskIndex = 0;
  int _correctAnswers = 0;
  int _totalErrors = 0;
  bool _isAnswered = false;
  bool? _isCorrect;
  MascotExpression _mascotExpression = MascotExpression.neutral;
  final List<TaskError> _errorsList = [];
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  void _checkAnswer(dynamic answer) {
    if (_isAnswered) return;

    final task = widget.lesson.tasks[_currentTaskIndex];
    bool correct = false;

    if (task.type == TaskType.multipleChoice || task.type == TaskType.findTheCatch) {
      correct = answer == task.correctOptionIndex;
    } else if (task.type == TaskType.chatSimulation) {
      correct = answer == task.correctOptionIndex;
    }

    setState(() {
      _isAnswered = true;
      _isCorrect = correct;
      if (correct) {
        _correctAnswers++;
        _mascotExpression = MascotExpression.happy;
      } else {
        _totalErrors++;
        _mascotExpression = MascotExpression.sad;
        _errorsList.add(TaskError(
          taskQuestion: task.question,
          userAnswer: (task.options != null && answer is int) ? task.options![answer] : answer.toString(),
          correctAnswer: (task.options != null && task.correctOptionIndex != null) ? task.options![task.correctOptionIndex!] : 'Błąd',
          explanation: task.explanation,
        ));
      }
    });

    _showFeedback();
  }

  void _showFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isCorrect! ? 'ŚWIETNIE!' : 'OJ, NIESTETY...',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: _isCorrect! ? Colors.green : Colors.red,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _nextTask() {
    if (_currentTaskIndex < widget.lesson.tasks.length - 1) {
      setState(() {
        _currentTaskIndex++;
        _isAnswered = false;
        _isCorrect = null;
        _mascotExpression = MascotExpression.neutral;
      });
    } else {
      _finishLesson();
    }
  }

  void _finishLesson() {
    final double accuracy = (_correctAnswers / widget.lesson.tasks.length) * 100;
    final duration = DateTime.now().difference(_startTime);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LessonCompletionScreen(
          lesson: widget.lesson,
          accuracy: accuracy,
          totalErrors: _totalErrors,
          duration: duration,
          errors: _errorsList,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.lesson.tasks[_currentTaskIndex];
    const Color neonCyan = Color(0xFF00FFE0);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      appBar: AppBar(
        title: LinearProgressIndicator(
          value: (_currentTaskIndex + 1) / widget.lesson.tasks.length,
          backgroundColor: Colors.grey[800],
          valueColor: const AlwaysStoppedAnimation<Color>(neonCyan),
          borderRadius: BorderRadius.circular(10),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                children: [
                  CyberMascot(expression: _mascotExpression, size: 80, showContainer: false),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161B22),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: neonCyan.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        task.question,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: _buildTaskContent(task),
              ),
              if (_isAnswered || task.type == TaskType.theory)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextTask,
                    child: const Text('DALEJ'),
                  ),
                ).animate().fadeIn(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskContent(Task task) {
    switch (task.type) {
      case TaskType.multipleChoice:
      case TaskType.findTheCatch:
        return _buildOptions(task);
      case TaskType.chatSimulation:
        return _buildChat(task);
      case TaskType.theory:
        return _buildTheory(task);
      default:
        return const Center(child: Text('Typ zadania w budowie...'));
    }
  }

  Widget _buildOptions(Task task) {
    return ListView.builder(
      itemCount: task.options?.length ?? 0,
      itemBuilder: (context, index) {
        Color? borderColor;
        if (_isAnswered) {
          if (index == task.correctOptionIndex) borderColor = Colors.green;
          // Note: we don't track which one user clicked specifically if wrong in MC yet for styling
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: InkWell(
            onTap: () => _checkAnswer(index),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF161B22),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: borderColor ?? Colors.grey.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Text(
                task.options![index],
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChat(Task task) {
     return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(task.question),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(task.options?.length ?? 0, (index) {
           return Padding(
             padding: const EdgeInsets.only(bottom: 8.0),
             child: SizedBox(
               width: double.infinity,
               child: OutlinedButton(
                 onPressed: () => _checkAnswer(index),
                 style: OutlinedButton.styleFrom(
                   side: const BorderSide(color: Color(0xFF00FFE0)),
                   foregroundColor: Colors.white,
                 ),
                 child: Text(task.options![index]),
               ),
             ),
           );
        }),
      ],
    );
  }

  Widget _buildTheory(Task task) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (task.imageUrl != null)
             ClipRRect(
               borderRadius: BorderRadius.circular(16),
               child: Image.asset('assets/images/\${task.imageUrl}', height: 200, fit: BoxFit.contain,
                errorBuilder: (c, e, s) => Container(height: 100, color: Colors.grey[900], child: const Icon(Icons.image_not_supported)),
               ),
             ),
          const SizedBox(height: 16),
          Text(
            task.explanation,
            style: const TextStyle(fontSize: 18, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class TaskError {
  final String taskQuestion;
  final String userAnswer;
  final String correctAnswer;
  final String explanation;

  TaskError({
    required this.taskQuestion,
    required this.userAnswer,
    required this.correctAnswer,
    required this.explanation,
  });
}

class LessonCompletionScreen extends StatelessWidget {
  final Lesson lesson;
  final double accuracy;
  final int totalErrors;
  final Duration duration;
  final List<TaskError> errors;

  const LessonCompletionScreen({
    super.key,
    required this.lesson,
    required this.accuracy,
    required this.totalErrors,
    required this.duration,
    required this.errors,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPassed = accuracy >= 35;
    final int xpEarned = isPassed ? (accuracy * 0.5).toInt() + 10 : 0;
    final provider = Provider.of<AppProvider>(context, listen: false);
    const Color neonCyan = Color(0xFF00FFE0);

    if (isPassed) {
      provider.addXp(xpEarned);
      provider.completeLesson(lesson.id);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              CyberMascot(
                expression: isPassed ? MascotExpression.winning : MascotExpression.sobbing,
                size: 150,
                showContainer: false,
              ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
              const SizedBox(height: 32),
              Text(
                isPassed ? 'BRAWO!' : 'SPRÓBUJ PONOWNIE',
                style: TextStyle(
                  color: isPassed ? neonCyan : Colors.redAccent,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    if (isPassed) Shadow(color: neonCyan, blurRadius: 20),
                  ]
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isPassed ? 'Lekcja ukończona pomyślnie' : 'Uzyskaj min. 35% poprawności (Twój wynik: \${accuracy.toInt()}%)',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const Spacer(),
              _buildStatBox('Poprawność', '\${accuracy.toInt()}%', Icons.check_circle, neonCyan),
              _buildStatBox('Zarobione XP', '+\$xpEarned XP', Icons.stars, Colors.amber),
              const Spacer(),
              if (errors.isNotEmpty)
                TextButton(
                  onPressed: () => _showErrors(context),
                  child: const Text('ZOBACZ CO POSZŁO NIE TAK', style: TextStyle(color: Colors.grey)),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('WRÓĆ DO MAPY'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Text(label, style: const TextStyle(fontSize: 18)),
            ],
          ),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  void _showErrors(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161B22),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Podsumowanie błędów', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: errors.length,
                  itemBuilder: (context, index) {
                    final e = errors[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.taskQuestion, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 8),
                          Text('Twoja: \${e.userAnswer}', style: const TextStyle(color: Colors.redAccent)),
                          Text('Poprawna: \${e.correctAnswer}', style: const TextStyle(color: Colors.greenAccent)),
                          const Divider(height: 24, color: Colors.white10),
                          Text(e.explanation, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white70)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
