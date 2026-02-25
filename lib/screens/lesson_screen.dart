import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lesson_models.dart';
import '../providers/app_provider.dart';
import '../widgets/mascot.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _currentTaskIndex = 0;
  bool _isAnswered = false;
  int? _selectedOption;
  bool _isCorrect = false;
  MascotExpression _mascotExpression = MascotExpression.neutral;

  void _checkAnswer(int index) {
    if (_isAnswered) return;

    final task = widget.lesson.tasks[_currentTaskIndex];
    if (task.type == TaskType.theory) {
      _nextTask();
      return;
    }
    setState(() {
      _selectedOption = index;
      _isAnswered = true;
      _isCorrect = (index == task.correctOptionIndex);
      _mascotExpression = _isCorrect ? MascotExpression.happy : MascotExpression.sad;
    });
    _showFeedback();
  }

  void _showFeedback() {
    final task = widget.lesson.tasks[_currentTaskIndex];
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: _isCorrect ? Colors.green[100] : Colors.red[100],
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: 250,
        child: Column(
          children: [
            Row(
              children: [
                Icon(_isCorrect ? Icons.check_circle : Icons.error, color: _isCorrect ? Colors.green : Colors.red, size: 40),
                const SizedBox(width: 16),
                Text(_isCorrect ? 'Świetnie!' : 'Nie martw się!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _isCorrect ? Colors.green[900] : Colors.red[900])),
              ],
            ),
            const SizedBox(height: 16),
            Text(task.explanation, style: const TextStyle(fontSize: 18)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _nextTask();
                },
                style: ElevatedButton.styleFrom(backgroundColor: _isCorrect ? Colors.green : Colors.red, foregroundColor: Colors.white),
                child: const Text('DALEJ'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextTask() {
    if (_currentTaskIndex < widget.lesson.tasks.length - 1) {
      setState(() {
        _currentTaskIndex++;
        _isAnswered = false;
        _selectedOption = null;
        _mascotExpression = MascotExpression.neutral;
      });
    } else {
      _finishLesson();
    }
  }

  void _finishLesson() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.addXp(10);
    provider.completeLesson(widget.lesson.id);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Lekcja Ukończona!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CyberMascot(expression: MascotExpression.dancing, size: 150),
            const SizedBox(height: 16),
            const Text('Zyskałeś +10 XP'),
          ],
        ),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          }, child: const Text('WRÓĆ DO MAPY')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.lesson.tasks[_currentTaskIndex];
    final progress = (_currentTaskIndex + 1) / widget.lesson.tasks.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: Row(
          children: [
            Expanded(child: LinearProgressIndicator(value: progress, minHeight: 12, borderRadius: BorderRadius.circular(6))),
            const SizedBox(width: 8),
            Hero(
              tag: 'lesson_${widget.lesson.id}',
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                child: const Icon(Icons.school, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Hero(
                  tag: 'mascot_main',
                  child: CyberMascot(expression: _mascotExpression, size: 80),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
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
      case TaskType.findTheCatch:
        return _buildFindTheCatch(task);
      case TaskType.theory:
        return _buildTheoryTask(task);
      case TaskType.spotTheDifference:
        return _buildSpotTheDifference(task);
      case TaskType.ordering:
        return _buildOrderingTask(task);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.explanation,
                  style: const TextStyle(fontSize: 20, height: 1.5),
                ),
                if (task.imageUrl != null) ...[
                  const SizedBox(height: 24),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.info_outline, size: 64, color: Colors.blue),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _nextTask(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
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
                    _mascotExpression = _isCorrect ? MascotExpression.happy : MascotExpression.sad;
                    _showFeedback();
                  }
                });
              },
              child: Text(task.options![index]),
            );
          }),
        ),
        if (_currentOrder.isNotEmpty)
          TextButton(
            onPressed: () => setState(() => _currentOrder.clear()),
            child: const Text('Zacznij od nowa'),
          ),
      ],
    );
  }

  Widget _buildSpotTheDifference(Task task) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _checkAnswer(0),
            child: _buildSpotCard('Opcja A', task.imageUrl, 0),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: InkWell(
            onTap: () => _checkAnswer(1),
            child: _buildSpotCard('Opcja B', task.secondaryImageUrl, 1),
          ),
        ),
      ],
    );
  }

  Widget _buildSpotCard(String label, String? url, int index) {
    final bool isSelected = _selectedOption == index;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!, width: isSelected ? 3 : 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: const Center(child: Icon(Icons.image_search, size: 48, color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Kliknij, aby wybrać', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFindTheCatch(Task task) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Stack(
              children: [
                // Container simulating an image since I don't have real assets
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Center(child: Text('FAŁSZYWA WIADOMOŚĆ SMS\n\nOd: InPost\n"Twoja paczka czeka..."\nLink: bit.ly/123-xyz', textAlign: TextAlign.center)),
                ),
                // Clickable regions
                ...task.catchRegions?.map((region) {
                  return Positioned(
                    left: region.x * 300, // Very simplified mapping
                    top: region.y * 200,
                    width: 100,
                    height: 50,
                    child: GestureDetector(
                      onTap: () => _checkAnswer(0), // Correct in this simple mock
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: _isAnswered ? Colors.red : Colors.transparent, width: 2),
                        ),
                      ),
                    ),
                  );
                }).toList() ?? [],
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Kliknij w element, który wydaje Ci się podejrzany.', style: TextStyle(fontStyle: FontStyle.italic)),
        ),
      ],
    );
  }
}
