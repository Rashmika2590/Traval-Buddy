import 'package:hive_flutter/hive_flutter.dart';
import '../models/destination.dart';

/// Service to manage Hive initialization and storage boxes
class StorageService {
  static const String _destinationsBoxName = 'destinations';
  static const String _settingsBoxName = 'settings';
  
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  bool _initialized = false;

  /// Initialize Hive and register type adapters
  Future<void> init() async {
    if (_initialized) return;

    try {
      // Initialize Hive with Flutter
      await Hive.initFlutter();

      // Register type adapters
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(DestinationAdapter());
      }

      // Open boxes
      await Hive.openBox<Destination>(_destinationsBoxName);
      await Hive.openBox(_settingsBoxName);

      _initialized = true;
    } catch (e) {
      throw Exception('Failed to initialize storage: $e');
    }
  }

  /// Get the destinations box
  Box<Destination> get destinationsBox {
    if (!_initialized) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return Hive.box<Destination>(_destinationsBoxName);
  }

  /// Get the settings box
  Box get settingsBox {
    if (!_initialized) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return Hive.box(_settingsBoxName);
  }

  /// Clear all data (for testing/debugging)
  Future<void> clearAll() async {
    await destinationsBox.clear();
    await settingsBox.clear();
  }

  /// Close all boxes
  Future<void> close() async {
    await Hive.close();
    _initialized = false;
  }
}
