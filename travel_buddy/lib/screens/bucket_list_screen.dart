import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/destination.dart';
import '../providers/bucket_list_provider.dart';
import '../widgets/destination_card.dart';
import '../widgets/progress_indicator_widget.dart';
import 'add_edit_destination_screen.dart';

/// Screen displaying the travel bucket list
class BucketListScreen extends StatefulWidget {
  const BucketListScreen({super.key});

  @override
  State<BucketListScreen> createState() => _BucketListScreenState();
}

class _BucketListScreenState extends State<BucketListScreen> {
  String _filter = 'all'; // all, visited, unvisited

  @override
  Widget build(BuildContext context) {
    return Consumer<BucketListProvider>(
      builder: (context, provider, child) {
        // Get filtered destinations
        List<Destination> destinations;
        if (_filter == 'visited') {
          destinations = provider.getDestinationsByStatus(true);
        } else if (_filter == 'unvisited') {
          destinations = provider.getDestinationsByStatus(false);
        } else {
          destinations = provider.destinations;
        }

        return Column(
          children: [
            // Progress indicator
            if (provider.totalCount > 0)
              ProgressIndicatorWidget(
                visitedCount: provider.visitedCount,
                totalCount: provider.totalCount,
              ),

            // Filter chips
            if (provider.totalCount > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All (${provider.totalCount})',
                      isSelected: _filter == 'all',
                      onTap: () => setState(() => _filter = 'all'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Visited (${provider.visitedCount})',
                      isSelected: _filter == 'visited',
                      onTap: () => setState(() => _filter = 'visited'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Pending (${provider.unvisitedCount})',
                      isSelected: _filter == 'unvisited',
                      onTap: () => setState(() => _filter = 'unvisited'),
                    ),
                  ],
                ),
              ),

            // Destinations list or empty state
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : destinations.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: () => provider.loadDestinations(),
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 80),
                            itemCount: destinations.length,
                            itemBuilder: (context, index) {
                              final destination = destinations[index];
                              return DestinationCard(
                                destination: destination,
                                onTap: () => _editDestination(destination),
                                onToggleVisited: () =>
                                    provider.toggleVisited(destination.id),
                                onDelete: () =>
                                    _confirmDelete(context, provider, destination),
                              );
                            },
                          ),
                        ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    String message;
    String emoji;
    
    if (_filter == 'visited') {
      message = 'No visited destinations yet!\nStart traveling!';
      emoji = '✈️';
    } else if (_filter == 'unvisited') {
      message = 'No pending destinations!\nAdd some dream places!';
      emoji = '🌟';
    } else {
      message = 'Your bucket list is empty!\nAdd your dream destinations!';
      emoji = '🌍';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),
          if (_filter == 'all')
            ElevatedButton.icon(
              onPressed: () => _addDestination(),
              icon: const Icon(Icons.add),
              label: const Text('Add Destination'),
            ),
        ],
      ),
    );
  }

  void _addDestination() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditDestinationScreen(),
      ),
    );
  }

  void _editDestination(Destination destination) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditDestinationScreen(
          destination: destination,
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    BucketListProvider provider,
    Destination destination,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Destination?'),
        content: Text(
          'Are you sure you want to delete "${destination.placeName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteDestination(destination.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Destination deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Filter chip widget
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
