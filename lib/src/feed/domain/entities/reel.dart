import 'package:cloud_firestore/cloud_firestore.dart';

class Reel {
  final String id;
  final String videoUrl;
  final String title;
  final String description;
  final Timestamp createdAt;

  Reel({
    required this.id,
    required this.videoUrl,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  // Convert Firestore data to Reel object
  factory Reel.fromMap(Map<String, dynamic> map, String id) {
    return Reel(
      id: id,
      videoUrl: map['videoUrl'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  // Convert Reel object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'videoUrl': videoUrl,
      'title': title,
      'description': description,
      'createdAt': createdAt,
    };
  }
}
