enum TaskType {
  multipleChoice,
  chatSimulation,
  findTheCatch,
}

class Module {
  final String id;
  final String title;
  final String description;
  final List<Lesson> lessons;

  Module({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
  });
}

class Lesson {
  final String id;
  final String title;
  final List<Task> tasks;

  Lesson({
    required this.id,
    required this.title,
    required this.tasks,
  });
}

class Task {
  final String id;
  final TaskType type;
  final String question;
  final List<String>? options;
  final int? correctOptionIndex;
  final List<ChatMessage>? chatMessages;
  final String? imageUrl;
  final List<CatchRegion>? catchRegions;
  final String explanation;

  Task({
    required this.id,
    required this.type,
    required this.question,
    this.options,
    this.correctOptionIndex,
    this.chatMessages,
    this.imageUrl,
    this.catchRegions,
    required this.explanation,
  });
}

class ChatMessage {
  final String text;
  final bool isUser;
  final List<ChatOption>? options;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.options,
  });
}

class ChatOption {
  final String text;
  final bool isCorrect;
  final String feedback;

  ChatOption({
    required this.text,
    required this.isCorrect,
    required this.feedback,
  });
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
