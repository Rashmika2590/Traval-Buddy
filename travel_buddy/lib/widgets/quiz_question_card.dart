import 'package:flutter/material.dart';
import '../models/quiz_question.dart';

/// Widget to display a quiz question with answer options
class QuizQuestionCard extends StatelessWidget {
  final QuizQuestion question;
  final int? selectedAnswer;
  final Function(int) onAnswerSelected;
  final bool showCorrectAnswer;

  const QuizQuestionCard({
    super.key,
    required this.question,
    this.selectedAnswer,
    required this.onAnswerSelected,
    this.showCorrectAnswer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                question.category,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Question text
            Text(
              question.question,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Answer options
            ...List.generate(question.options.length, (index) {
              final isSelected = selectedAnswer == index;
              final isCorrect = question.correctAnswerIndex == index;
              final shouldShowCorrect = showCorrectAnswer && isCorrect;
              final shouldShowWrong = showCorrectAnswer && isSelected && !isCorrect;
              
              Color? backgroundColor;
              Color? borderColor;
              IconData? icon;
              
              if (shouldShowCorrect) {
                backgroundColor = Colors.green.withOpacity(0.2);
                borderColor = Colors.green;
                icon = Icons.check_circle;
              } else if (shouldShowWrong) {
                backgroundColor = Colors.red.withOpacity(0.2);
                borderColor = Colors.red;
                icon = Icons.cancel;
              } else if (isSelected) {
                backgroundColor = Theme.of(context).colorScheme.primary.withOpacity(0.1);
                borderColor = Theme.of(context).colorScheme.primary;
              }
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: showCorrectAnswer ? null : () => onAnswerSelected(index),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border.all(
                        color: borderColor ?? Colors.grey[300]!,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Option letter
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: borderColor?.withOpacity(0.2) ?? Colors.grey[200],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index), // A, B, C, D
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: borderColor ?? Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // Option text
                        Expanded(
                          child: Text(
                            question.options[index],
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                        
                        // Correct/Wrong icon
                        if (icon != null) Icon(icon, color: borderColor),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
