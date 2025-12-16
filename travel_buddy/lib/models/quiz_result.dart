/// Represents the result of a completed quiz session
class QuizResult {
  final int score;
  final int totalQuestions;
  final DateTime completedAt;
  final Duration timeTaken;

  QuizResult({
    required this.score,
    required this.totalQuestions,
    DateTime? completedAt,
    Duration? timeTaken,
  }) : completedAt = completedAt ?? DateTime.now(),
       timeTaken = timeTaken ?? const Duration(seconds: 0);

  /// Calculate the percentage score
  double get percentage => (score / totalQuestions) * 100;

  /// Get a friendly message based on the score
  String get congratulationsMessage {
    final percent = percentage;
    if (percent == 100) {
      return '🎉 Perfect! You\'re a travel expert!';
    } else if (percent >= 80) {
      return '🌟 Excellent! You know your travel facts!';
    } else if (percent >= 60) {
      return '👍 Good job! Keep exploring!';
    } else if (percent >= 40) {
      return '📚 Not bad! Learn more and try again!';
    } else {
      return '🌍 Keep learning! Travel awaits!';
    }
  }

  /// Get emoji based on score
  String get emoji {
    final percent = percentage;
    if (percent == 100) return '🎉';
    if (percent >= 80) return '🌟';
    if (percent >= 60) return '👍';
    if (percent >= 40) return '📚';
    return '🌍';
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'totalQuestions': totalQuestions,
      'completedAt': completedAt.toIso8601String(),
      'timeTaken': timeTaken.inSeconds,
    };
  }

  /// Create from JSON
  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      score: json['score'] as int,
      totalQuestions: json['totalQuestions'] as int,
      completedAt: DateTime.parse(json['completedAt'] as String),
      timeTaken: Duration(seconds: json['timeTaken'] as int),
    );
  }

  @override
  String toString() {
    return 'QuizResult(score: $score/$totalQuestions, percentage: ${percentage.toStringAsFixed(1)}%)';
  }
}
