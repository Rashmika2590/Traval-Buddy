import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Widget to display travel progress statistics
class ProgressIndicatorWidget extends StatelessWidget {
  final int visitedCount;
  final int totalCount;

  const ProgressIndicatorWidget({
    super.key,
    required this.visitedCount,
    required this.totalCount,
  });

  double get percentage => totalCount == 0 ? 0.0 : (visitedCount / totalCount);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.travel_explore, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Your Travel Progress',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 24,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  percentage >= 0.8
                      ? AppTheme.visitedColor
                      : (percentage >= 0.5
                          ? AppTheme.accentLight
                          : AppTheme.unvisitedColor),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Visited
                _StatItem(
                  icon: Icons.check_circle,
                  label: 'Visited',
                  value: visitedCount.toString(),
                  color: AppTheme.visitedColor,
                ),
                
                // Divider
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey[300],
                ),
                
                // Pending
                _StatItem(
                  icon: Icons.pending,
                  label: 'Pending',
                  value: (totalCount - visitedCount).toString(),
                  color: AppTheme.unvisitedColor,
                ),
                
                // Divider
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey[300],
                ),
                
                // Percentage
                _StatItem(
                  icon: Icons.emoji_events,
                  label: 'Progress',
                  value: '${(percentage * 100).toStringAsFixed(0)}%',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            
            // Motivational message
            if (totalCount > 0) ...[
              const SizedBox(height: 12),
              Text(
                _getMotivationalMessage(percentage),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getMotivationalMessage(double progress) {
    if (progress == 1.0) return '🎉 Amazing! You\'ve visited all destinations!';
    if (progress >= 0.8) return '🌟 Almost there! Keep exploring!';
    if (progress >= 0.5) return '✈️ Great progress! The world awaits!';
    if (progress >= 0.3) return '🗺️ Good start! Keep traveling!';
    return '🌍 Start your journey! Adventure awaits!';
  }
}

/// Individual stat item widget
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
