import 'package:flutter/foundation.dart';
import '../models/quiz_question.dart';
import '../models/quiz_result.dart';
import '../services/quiz_service.dart';

/// Provider to manage quiz state and sessions
class QuizProvider extends ChangeNotifier {
  final QuizService _service = QuizService();

  List<QuizQuestion> _currentQuestions = [];
  int _currentQuestionIndex = 0;
  Map<int, int> _userAnswers = {}; // questionIndex -> answerIndex
  DateTime? _quizStartTime;
  bool _isQuizActive = false;

  List<QuizQuestion> get currentQuestions => _currentQuestions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get totalQuestions => _currentQuestions.length;
  bool get isQuizActive => _isQuizActive;
  bool get isLastQuestion => _currentQuestionIndex >= totalQuestions - 1;
  QuizQuestion? get currentQuestion =>
      _currentQuestions.isEmpty ? null : _currentQuestions[_currentQuestionIndex];

  /// Start a new quiz with random questions
  void startQuiz({int questionCount = 10}) {
    _currentQuestions = _service.getRandomQuestions(count: questionCount);
    _currentQuestionIndex = 0;
    _userAnswers = {};
    _quizStartTime = DateTime.now();
    _isQuizActive = true;
    notifyListeners();
  }

  /// Submit an answer for the current question
  void submitAnswer(int answerIndex) {
    if (!_isQuizActive || currentQuestion == null) return;

    _userAnswers[_currentQuestionIndex] = answerIndex;
    notifyListeners();
  }

  /// Move to next question
  void nextQuestion() {
    if (!_isQuizActive || isLastQuestion) return;

    _currentQuestionIndex++;
    notifyListeners();
  }

  /// Move to previous question
  void previousQuestion() {
    if (!_isQuizActive || _currentQuestionIndex == 0) return;

    _currentQuestionIndex--;
    notifyListeners();
  }

  /// Get the user's answer for a specific question
  int? getUserAnswer(int questionIndex) {
    return _userAnswers[questionIndex];
  }

  /// Check if user has answered the current question
  bool get hasAnsweredCurrentQuestion {
    return _userAnswers.containsKey(_currentQuestionIndex);
  }

  /// Calculate and return quiz result
  QuizResult finishQuiz() {
    if (!_isQuizActive) {
      throw Exception('No active quiz to finish');
    }

    int score = 0;
    for (int i = 0; i < _currentQuestions.length; i++) {
      final userAnswer = _userAnswers[i];
      if (userAnswer != null && _currentQuestions[i].isCorrect(userAnswer)) {
        score++;
      }
    }

    final timeTaken = DateTime.now().difference(_quizStartTime!);
    final result = QuizResult(
      score: score,
      totalQuestions: totalQuestions,
      timeTaken: timeTaken,
    );

    _isQuizActive = false;
    notifyListeners();

    return result;
  }

  /// Reset quiz state
  void resetQuiz() {
    _currentQuestions = [];
    _currentQuestionIndex = 0;
    _userAnswers = {};
    _quizStartTime = null;
    _isQuizActive = false;
    notifyListeners();
  }

  /// Get all available categories
  List<String> getCategories() {
    return _service.getCategories();
  }

  /// Get total number of available questions
  int getTotalAvailableQuestions() {
    return _service.getTotalQuestions();
  }

  /// Check if an answer is correct (for review)
  bool isAnswerCorrect(int questionIndex, int answerIndex) {
    if (questionIndex >= _currentQuestions.length) return false;
    return _currentQuestions[questionIndex].isCorrect(answerIndex);
  }
}
