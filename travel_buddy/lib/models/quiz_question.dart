/// Represents a single quiz question with multiple choice answers
class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String category;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.category,
  }) : assert(options.length == 4, 'Quiz must have exactly 4 options'),
       assert(correctAnswerIndex >= 0 && correctAnswerIndex < 4, 'Correct answer index must be 0-3');

  /// Check if the given answer index is correct
  bool isCorrect(int answerIndex) => answerIndex == correctAnswerIndex;

  /// Get the correct answer text
  String get correctAnswer => options[correctAnswerIndex];

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'category': category,
    };
  }

  /// Create from JSON
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswerIndex: json['correctAnswerIndex'] as int,
      category: json['category'] as String,
    );
  }

  @override
  String toString() {
    return 'QuizQuestion(question: $question, category: $category)';
  }
}
