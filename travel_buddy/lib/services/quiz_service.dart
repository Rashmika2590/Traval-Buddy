import 'dart:math';
import '../models/quiz_question.dart';

/// Service to manage quiz questions and quiz sessions
class QuizService {
  // Sample quiz questions organized by category
  static final List<QuizQuestion> _allQuestions = [
    // CAPITALS Category
    QuizQuestion(
      question: 'What is the capital of France?',
      options: ['London', 'Paris', 'Berlin', 'Madrid'],
      correctAnswerIndex: 1,
      category: 'Capitals',
    ),
    QuizQuestion(
      question: 'Which city is the capital of Japan?',
      options: ['Seoul', 'Beijing', 'Tokyo', 'Bangkok'],
      correctAnswerIndex: 2,
      category: 'Capitals',
    ),
    QuizQuestion(
      question: 'What is the capital of Australia?',
      options: ['Sydney', 'Melbourne', 'Canberra', 'Perth'],
      correctAnswerIndex: 2,
      category: 'Capitals',
    ),
    QuizQuestion(
      question: 'Which city is the capital of Canada?',
      options: ['Toronto', 'Vancouver', 'Montreal', 'Ottawa'],
      correctAnswerIndex: 3,
      category: 'Capitals',
    ),
    QuizQuestion(
      question: 'What is the capital of Brazil?',
      options: ['Rio de Janeiro', 'São Paulo', 'Brasília', 'Salvador'],
      correctAnswerIndex: 2,
      category: 'Capitals',
    ),
    QuizQuestion(
      question: 'Which city is the capital of Egypt?',
      options: ['Cairo', 'Alexandria', 'Giza', 'Luxor'],
      correctAnswerIndex: 0,
      category: 'Capitals',
    ),
    QuizQuestion(
      question: 'What is the capital of Spain?',
      options: ['Barcelona', 'Madrid', 'Valencia', 'Seville'],
      correctAnswerIndex: 1,
      category: 'Capitals',
    ),

    // LANDMARKS Category
    QuizQuestion(
      question: 'In which country is the Taj Mahal located?',
      options: ['Pakistan', 'India', 'Bangladesh', 'Nepal'],
      correctAnswerIndex: 1,
      category: 'Landmarks',
    ),
    QuizQuestion(
      question: 'Where is the Eiffel Tower located?',
      options: ['London', 'Paris', 'Rome', 'Berlin'],
      correctAnswerIndex: 1,
      category: 'Landmarks',
    ),
    QuizQuestion(
      question: 'Which country is home to the Great Wall?',
      options: ['Japan', 'Mongolia', 'China', 'Korea'],
      correctAnswerIndex: 2,
      category: 'Landmarks',
    ),
    QuizQuestion(
      question: 'Where is Machu Picchu located?',
      options: ['Mexico', 'Peru', 'Chile', 'Argentina'],
      correctAnswerIndex: 1,
      category: 'Landmarks',
    ),
    QuizQuestion(
      question: 'In which city is the Statue of Liberty?',
      options: ['Washington D.C.', 'Los Angeles', 'New York', 'Boston'],
      correctAnswerIndex: 2,
      category: 'Landmarks',
    ),
    QuizQuestion(
      question: 'Where is the Colosseum located?',
      options: ['Athens', 'Rome', 'Cairo', 'Istanbul'],
      correctAnswerIndex: 1,
      category: 'Landmarks',
    ),
    QuizQuestion(
      question: 'Which country is home to Angkor Wat?',
      options: ['Thailand', 'Vietnam', 'Cambodia', 'Laos'],
      correctAnswerIndex: 2,
      category: 'Landmarks',
    ),

    // CULTURE & FACTS Category
    QuizQuestion(
      question: 'Which is the largest country by land area?',
      options: ['Canada', 'China', 'USA', 'Russia'],
      correctAnswerIndex: 3,
      category: 'Culture',
    ),
    QuizQuestion(
      question: 'What is the most visited country in the world?',
      options: ['USA', 'France', 'Spain', 'China'],
      correctAnswerIndex: 1,
      category: 'Culture',
    ),
    QuizQuestion(
      question: 'Which ocean is the largest?',
      options: ['Atlantic', 'Indian', 'Pacific', 'Arctic'],
      correctAnswerIndex: 2,
      category: 'Culture',
    ),
    QuizQuestion(
      question: 'In which country did the Renaissance begin?',
      options: ['France', 'Italy', 'Spain', 'Greece'],
      correctAnswerIndex: 1,
      category: 'Culture',
    ),
    QuizQuestion(
      question: 'What is the longest river in the world?',
      options: ['Amazon', 'Nile', 'Yangtze', 'Mississippi'],
      correctAnswerIndex: 1,
      category: 'Culture',
    ),
    QuizQuestion(
      question: 'Which continent has the most countries?',
      options: ['Asia', 'Europe', 'Africa', 'South America'],
      correctAnswerIndex: 2,
      category: 'Culture',
    ),
    QuizQuestion(
      question: 'What is the smallest country in the world?',
      options: ['Monaco', 'Vatican City', 'San Marino', 'Liechtenstein'],
      correctAnswerIndex: 1,
      category: 'Culture',
    ),
    QuizQuestion(
      question: 'Which language is the most spoken worldwide?',
      options: ['English', 'Spanish', 'Mandarin Chinese', 'Hindi'],
      correctAnswerIndex: 2,
      category: 'Culture',
    ),
    QuizQuestion(
      question: 'Which city is known as the "City of Love"?',
      options: ['Rome', 'Venice', 'Paris', 'Vienna'],
      correctAnswerIndex: 2,
      category: 'Culture',
    ),
  ];

  /// Get a random selection of questions for a quiz
  List<QuizQuestion> getRandomQuestions({int count = 10}) {
    if (count >= _allQuestions.length) {
      return List.from(_allQuestions)..shuffle();
    }

    final random = Random();
    final shuffled = List<QuizQuestion>.from(_allQuestions)..shuffle(random);
    return shuffled.take(count).toList();
  }

  /// Get questions by category
  List<QuizQuestion> getQuestionsByCategory(String category) {
    return _allQuestions.where((q) => q.category == category).toList();
  }

  /// Get all available categories
  List<String> getCategories() {
    return _allQuestions.map((q) => q.category).toSet().toList();
  }

  /// Get total number of questions
  int getTotalQuestions() {
    return _allQuestions.length;
  }

  /// Validate an answer
  bool validateAnswer(QuizQuestion question, int answerIndex) {
    return question.isCorrect(answerIndex);
  }
}
