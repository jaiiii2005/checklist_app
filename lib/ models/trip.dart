// lib/models/trip.dart
class Trip {
  String? id;
  final String purpose;
  final double progress;

  Trip({
    this.id,
    required this.purpose,
    this.progress = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "purpose": purpose,
      "progress": progress,
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id']?.toString(),
      purpose: map['purpose']?.toString() ?? '',
      progress: (map['progress'] is num) ? (map['progress'] as num).toDouble() : 0.0,
    );
  }
}
