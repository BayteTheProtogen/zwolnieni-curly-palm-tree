enum TaskType { multipleChoice, chatSimulation, findTheCatch, theory, spotTheDifference, ordering }

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class CatchRegion {
  final double x;
  final double y;
  final double width;
  final double height;
  final String description;

  CatchRegion({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.description,
  });
}

class Task {
  final String id;
  final TaskType type;
  final String question;
  final String explanation;
  final List<String>? options;
  final int? correctOptionIndex;
  final List<ChatMessage>? chatMessages;
  final String? imageUrl;
  final String? secondaryImageUrl;
  final List<CatchRegion>? catchRegions;
  final List<int>? correctOrder;

  Task({
    required this.id,
    required this.type,
    required this.question,
    required this.explanation,
    this.options,
    this.correctOptionIndex,
    this.chatMessages,
    this.imageUrl,
    this.secondaryImageUrl,
    this.catchRegions,
    this.correctOrder,
  });
}

class Lesson {
  final String id;
  final String title;
  final List<Task> tasks;

  Lesson({required this.id, required this.title, required this.tasks});
}

class Module {
  final String id;
  final String title;
  final String description;
  final List<Lesson> lessons;
  final CyberBadge? badge;

  Module({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
    this.badge,
  });
}

class CyberBadge {
  final String id;
  final String name;
  final String description;
  final String icon;

  CyberBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });
}
