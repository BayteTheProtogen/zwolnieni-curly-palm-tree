import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/lesson_models.dart';
import '../providers/app_provider.dart';
import '../widgets/mascot.dart';
import '../data/lesson_data.dart';
import 'dart:async';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _currentTaskIndex = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;
  int? _selectedOption;
  MascotExpression _mascotExpression = MascotExpression.neutral;

  // Stats tracking
  int _totalErrors = 0;
  late DateTime _startTime;
  List<TaskError> _errorsList = [];

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  void _checkAnswer(int index) {
    if (_isAnswered) return;

    final task = widget.lesson.tasks[_currentTaskIndex];
    setState(() {
      _selectedOption = index;
      _isAnswered = true;
      _isCorrect = index == task.correctOptionIndex;

      if (!_isCorrect) {
        _totalErrors++;
        _errorsList.add(TaskError(
          taskQuestion: task.question,
          userAnswer: task.options?[index] ?? 'Nieznana',
          correctAnswer: task.options?[task.correctOptionIndex!] ?? 'Nieznana',
          explanation: task.explanation,
        ));
      }

      _mascotExpression = _isCorrect ? MascotExpression.happy : MascotExpression.sad;
    });

    _showFeedback();
  }

  void _showFeedback() {
    final task = widget.lesson.tasks[_currentTaskIndex];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_isCorrect ? 'ŚWIETNIE!' : 'OJ, NIESTETY...'),
            Text(task.explanation, style: const TextStyle(fontSize: 14)),
          ],
        ),
        backgroundColor: _isCorrect ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'DALEJ',
          textColor: Colors.white,
          onPressed: () => _nextTask(),
        ),
      ),
    );
  }

  void _nextTask() {
    if (_currentTaskIndex < widget.lesson.tasks.length - 1) {
      setState(() {
        _currentTaskIndex++;
        _isAnswered = false;
        _isCorrect = false;
        _selectedOption = null;
        _mascotExpression = MascotExpression.neutral;
        _currentOrder.clear();
      });
    } else {
      _finishLesson();
    }
  }

  void _finishLesson() {
    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime);
    final totalTasks = widget.lesson.tasks.length;
    final correctTasks = totalTasks - _errorsList.length;
    final accuracy = (correctTasks / totalTasks) * 100;

    Navigator.of(context).pushReplacement(
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
    final progress = (_currentTaskIndex + 1) / widget.lesson.tasks.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(value: progress),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Hero(
                  tag: 'mascot_${widget.lesson.id}',
                  child: CyberMascot(expression: _mascotExpression, size: 100),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(task.question, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ).animate().fadeIn().slideX(),
            const SizedBox(height: 32),
            Expanded(
              child: _buildTaskBody(task),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskBody(Task task) {
    switch (task.type) {
      case TaskType.multipleChoice:
        return _buildMultipleChoice(task);
      case TaskType.chatSimulation:
        return _buildChatSimulation(task);
      case TaskType.theory:
        return _buildTheoryTask(task);
      case TaskType.ordering:
        return _buildOrderingTask(task);
      default:
        return const Center(child: Text('Typ zadania w budowie'));
    }
  }

  Widget _buildMultipleChoice(Task task) {
    return ListView.builder(
      itemCount: task.options?.length ?? 0,
      itemBuilder: (context, index) {
        final option = task.options![index];
        final bool isSelected = _selectedOption == index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: InkWell(
            onTap: () => _checkAnswer(index),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!, width: isSelected ? 3 : 1),
                borderRadius: BorderRadius.circular(16),
                color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.05) : null,
              ),
              child: Text(option, style: const TextStyle(fontSize: 18)),
            ),
          ).animate(delay: (index * 100).ms).fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
        );
      },
    );
  }

  Widget _buildChatSimulation(Task task) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: task.chatMessages?.length ?? 0,
            itemBuilder: (context, index) {
              final msg = task.chatMessages![index];
              return Align(
                alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: msg.isUser ? Colors.blue[100] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(msg.text, style: const TextStyle(fontSize: 16)),
                ),
              );
            },
          ),
        ),
        const Divider(),
        ...List.generate(task.options?.length ?? 0, (index) {
           return Padding(
             padding: const EdgeInsets.only(top: 8.0),
             child: SizedBox(
               width: double.infinity,
               child: OutlinedButton(
                 onPressed: () => _checkAnswer(index),
                 child: Text(task.options![index]),
               ),
             ),
           );
        }),
      ],
    );
  }

  Widget _buildTheoryTask(Task task) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              task.explanation,
              style: const TextStyle(fontSize: 20, height: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _nextTask(),
            child: const Text('ROZUMIEM'),
          ),
        ),
      ],
    );
  }

  List<int> _currentOrder = [];

  Widget _buildOrderingTask(Task task) {
    return Column(
      children: [
        const Text('Ułóż kroki w poprawnej kolejności:', style: TextStyle(fontStyle: FontStyle.italic)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: _currentOrder.map((idx) => Card(
              child: ListTile(
                leading: CircleAvatar(child: Text('${_currentOrder.indexOf(idx) + 1}')),
                title: Text(task.options![idx]),
              ),
            )).toList(),
          ),
        ),
        const Spacer(),
        Wrap(
          spacing: 8,
          children: List.generate(task.options?.length ?? 0, (index) {
            final bool isPicked = _currentOrder.contains(index);
            return ElevatedButton(
              onPressed: isPicked ? null : () {
                setState(() {
                  _currentOrder.add(index);
                  if (_currentOrder.length == task.options!.length) {
                    _isAnswered = true;
                    _isCorrect = true;
                    for (int i = 0; i < _currentOrder.length; i++) {
                      if (_currentOrder[i] != task.correctOrder![i]) {
                        _isCorrect = false;
                        break;
                      }
                    }
                    if (!_isCorrect) {
                       _totalErrors++;
                       _errorsList.add(TaskError(
                         taskQuestion: task.question,
                         userAnswer: 'Błędna kolejność',
                         correctAnswer: 'Poprawna kolejność',
                         explanation: task.explanation,
                       ));
                    }
                    _mascotExpression = _isCorrect ? MascotExpression.happy : MascotExpression.sad;
                    _showFeedback();
                  }
                });
              },
              child: Text(task.options![index]),
            );
          }),
        ),
      ],
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

    if (isPassed) {
      provider.addXp(xpEarned);
      provider.completeLesson(lesson.id);

      // Check if module is complete for badge
      final module = cybersecurityModules.firstWhere((m) => m.lessons.any((l) => l.id == lesson.id));
      final allLessonIds = module.lessons.map((l) => l.id).toSet();
      if (allLessonIds.every((id) => provider.completedLessons.contains(id) || id == lesson.id)) {
        if (module.badge != null) {
          provider.earnBadge(module.badge!.id);
        }
      }
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isPassed
              ? [Colors.blue[900]!, Colors.blue[700]!]
              : [Colors.red[900]!, Colors.red[700]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              CyberMascot(
                expression: isPassed ? MascotExpression.winning : MascotExpression.sobbing,
                size: 150,
              ).animate().scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut),
              const SizedBox(height: 32),
              Text(
                isPassed ? 'BRAWO!' : 'SPRÓBUJ PONOWNIE',
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                isPassed ? 'Lekcja ukończona pomyślnie' : 'Musisz uzyskać min. 35% poprawności',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const Spacer(),
              _buildStatRow('Poprawność', '${accuracy.toInt()}%', Icons.check_circle),
              _buildStatRow('Czas', '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}', Icons.timer),
              _buildStatRow('Zarobione XP', '+$xpEarned XP', Icons.stars),
              const Spacer(),
              if (errors.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: OutlinedButton(
                    onPressed: () => _showErrors(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                    ),
                    child: const Text('ZOBACZ PODSUMOWANIE BŁĘDÓW'),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: isPassed ? Colors.blue[900] : Colors.red[900],
                  ),
                  child: const Text('WRÓĆ DO MAPY'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showErrors(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Twoje błędy', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: errors.length,
                itemBuilder: (context, index) {
                  final e = errors[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.taskQuestion, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Twoja odpowiedź: ${e.userAnswer}', style: const TextStyle(color: Colors.red)),
                          Text('Poprawna: ${e.correctAnswer}', style: const TextStyle(color: Colors.green)),
                          const Divider(),
                          Text(e.explanation, style: const TextStyle(fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
