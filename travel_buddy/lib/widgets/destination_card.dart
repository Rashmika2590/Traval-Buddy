import 'package:flutter/material.dart';
import '../models/destination.dart';
import '../theme/app_theme.dart';

/// Card widget to display a single destination
class DestinationCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback onTap;
  final VoidCallback onToggleVisited;
  final VoidCallback onDelete;

  const DestinationCard({
    super.key,
    required this.destination,
    required this.onTap,
    required this.onToggleVisited,
    required this.onDelete,
  });

  // Get country flag emoji (simplified version)
  String _getCountryFlag(String country) {
    final flags = {
      'france': '🇫🇷', 'japan': '🇯🇵', 'usa': '🇺🇸', 'uk': '🇬🇧',
      'italy': '🇮🇹', 'spain': '🇪🇸', 'germany': '🇩🇪', 'canada': '🇨🇦',
      'australia': '🇦🇺', 'brazil': '🇧🇷', 'india': '🇮🇳', 'china': '🇨🇳',
      'mexico': '🇲🇽', 'thailand': '🇹🇭', 'greece': '🇬🇷', 'egypt': '🇪🇬',
      'turkey': '🇹🇷', 'peru': '🇵🇪', 'argentina': '🇦🇷', 'switzerland': '🇨🇭',
    };
    return flags[country.toLowerCase()] ?? '🌍';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with place name and status
              Row(
                children: [
                  // Country flag
                  Text(
                    _getCountryFlag(destination.country),
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 12),
                  
                  // Place name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          destination.placeName,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          destination.country,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Visited badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: destination.isVisited
                          ? AppTheme.visitedColor.withOpacity(0.2)
                          : AppTheme.unvisitedColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          destination.isVisited ? Icons.check_circle : Icons.pending,
                          size: 16,
                          color: destination.isVisited
                              ? AppTheme.visitedColor
                              : AppTheme.unvisitedColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          destination.isVisited ? 'Visited' : 'Pending',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: destination.isVisited
                                ? AppTheme.visitedColor
                                : AppTheme.unvisitedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Notes if available
              if (destination.notes.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  destination.notes,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),
              
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Toggle visited button
                  TextButton.icon(
                    onPressed: onToggleVisited,
                    icon: Icon(
                      destination.isVisited ? Icons.undo : Icons.check,
                      size: 18,
                    ),
                    label: Text(
                      destination.isVisited ? 'Mark Pending' : 'Mark Visited',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Delete button
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red,
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
