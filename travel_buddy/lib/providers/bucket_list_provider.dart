import 'package:flutter/foundation.dart';
import '../models/destination.dart';
import '../services/bucket_list_service.dart';

/// Provider to manage bucket list state
class BucketListProvider extends ChangeNotifier {
  final BucketListService _service = BucketListService();
  
  List<Destination> _destinations = [];
  bool _isLoading = false;
  String? _error;

  List<Destination> get destinations => _destinations;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  int get totalCount => _destinations.length;
  int get visitedCount => _destinations.where((d) => d.isVisited).length;
  int get unvisitedCount => totalCount - visitedCount;
  double get visitedPercentage => totalCount == 0 ? 0.0 : (visitedCount / totalCount) * 100;

  /// Load all destinations from storage
  Future<void> loadDestinations() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _destinations = _service.getAllDestinations();
      // Sort by created date (newest first)
      _destinations.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load destinations: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new destination
  Future<void> addDestination({
    required String placeName,
    required String country,
    String notes = '',
    bool isVisited = false,
  }) async {
    try {
      _error = null;
      await _service.addDestination(
        placeName: placeName,
        country: country,
        notes: notes,
        isVisited: isVisited,
      );
      await loadDestinations();
    } catch (e) {
      _error = 'Failed to add destination: $e';
      notifyListeners();
    }
  }

  /// Update an existing destination
  Future<void> updateDestination(Destination destination) async {
    try {
      _error = null;
      await _service.updateDestination(destination);
      await loadDestinations();
    } catch (e) {
      _error = 'Failed to update destination: $e';
      notifyListeners();
    }
  }

  /// Toggle visited status
  Future<void> toggleVisited(String id) async {
    try {
      _error = null;
      await _service.toggleVisitedStatus(id);
      await loadDestinations();
    } catch (e) {
      _error = 'Failed to toggle visited status: $e';
      notifyListeners();
    }
  }

  /// Delete a destination
  Future<void> deleteDestination(String id) async {
    try {
      _error = null;
      await _service.deleteDestination(id);
      await loadDestinations();
    } catch (e) {
      _error = 'Failed to delete destination: $e';
      notifyListeners();
    }
  }

  /// Get destinations filtered by visited status
  List<Destination> getDestinationsByStatus(bool isVisited) {
    return _destinations.where((d) => d.isVisited == isVisited).toList();
  }

  /// Search destinations
  List<Destination> searchDestinations(String query) {
    if (query.isEmpty) return _destinations;
    
    final lowerQuery = query.toLowerCase();
    return _destinations.where((d) {
      return d.placeName.toLowerCase().contains(lowerQuery) ||
          d.country.toLowerCase().contains(lowerQuery) ||
          d.notes.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
