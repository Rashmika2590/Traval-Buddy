import 'package:hive/hive.dart';

part 'destination.g.dart';

/// Model representing a travel destination in the bucket list
@HiveType(typeId: 0)
class Destination {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String placeName;

  @HiveField(2)
  final String country;

  @HiveField(3)
  final String notes;

  @HiveField(4)
  final bool isVisited;

  @HiveField(5)
  final DateTime createdAt;

  Destination({
    required this.id,
    required this.placeName,
    required this.country,
    this.notes = '',
    this.isVisited = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Create a copy of this destination with updated fields
  Destination copyWith({
    String? id,
    String? placeName,
    String? country,
    String? notes,
    bool? isVisited,
    DateTime? createdAt,
  }) {
    return Destination(
      id: id ?? this.id,
      placeName: placeName ?? this.placeName,
      country: country ?? this.country,
      notes: notes ?? this.notes,
      isVisited: isVisited ?? this.isVisited,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert to JSON for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'placeName': placeName,
      'country': country,
      'notes': notes,
      'isVisited': isVisited,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] as String,
      placeName: json['placeName'] as String,
      country: json['country'] as String,
      notes: json['notes'] as String? ?? '',
      isVisited: json['isVisited'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Destination(id: $id, placeName: $placeName, country: $country, isVisited: $isVisited)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Destination && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
