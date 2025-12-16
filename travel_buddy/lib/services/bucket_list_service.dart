import 'package:uuid/uuid.dart';
import '../models/destination.dart';
import 'storage_service.dart';

/// Service to manage bucket list CRUD operations
class BucketListService {
  final StorageService _storage = StorageService();
  final _uuid = const Uuid();

  /// Get all destinations
  List<Destination> getAllDestinations() {
    return _storage.destinationsBox.values.toList();
  }

  /// Get a destination by ID
  Destination? getDestinationById(String id) {
    return _storage.destinationsBox.get(id);
  }

  /// Add a new destination
  Future<Destination> addDestination({
    required String placeName,
    required String country,
    String notes = '',
    bool isVisited = false,
  }) async {
    final destination = Destination(
      id: _uuid.v4(),
      placeName: placeName,
      country: country,
      notes: notes,
      isVisited: isVisited,
    );

    await _storage.destinationsBox.put(destination.id, destination);
    return destination;
  }

  /// Update an existing destination
  Future<void> updateDestination(Destination destination) async {
    await _storage.destinationsBox.put(destination.id, destination);
  }

  /// Toggle the visited status of a destination
  Future<void> toggleVisitedStatus(String id) async {
    final destination = getDestinationById(id);
    if (destination != null) {
      final updated = destination.copyWith(isVisited: !destination.isVisited);
      await updateDestination(updated);
    }
  }

  /// Delete a destination
  Future<void> deleteDestination(String id) async {
    await _storage.destinationsBox.delete(id);
  }

  /// Get visited destinations count
  int getVisitedCount() {
    return getAllDestinations().where((d) => d.isVisited).length;
  }

  /// Get total destinations count
  int getTotalCount() {
    return getAllDestinations().length;
  }

  /// Get visited percentage
  double getVisitedPercentage() {
    final total = getTotalCount();
    if (total == 0) return 0.0;
    return (getVisitedCount() / total) * 100;
  }

  /// Get destinations by visited status
  List<Destination> getDestinationsByStatus(bool isVisited) {
    return getAllDestinations().where((d) => d.isVisited == isVisited).toList();
  }

  /// Search destinations by place name or country
  List<Destination> searchDestinations(String query) {
    final lowerQuery = query.toLowerCase();
    return getAllDestinations().where((d) {
      return d.placeName.toLowerCase().contains(lowerQuery) ||
          d.country.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
