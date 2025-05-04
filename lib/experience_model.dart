// experience_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String userId;
  final String text;
  final int rating;
  final DateTime timestamp;

  Review({
    required this.userId,
    required this.text,
    required this.rating,
    required this.timestamp,
  });

  factory Review.fromMap(Map<String, dynamic> data) => Review(
        userId: data['userId'],
        text: data['text'],
        rating: data['rating'],
        timestamp: (data['timestamp'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'text': text,
        'rating': rating,
        'timestamp': timestamp,
      };
}

class Experience {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final bool isFavorite;
  final String category;
  final List<Review> reviews;

  Experience({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.isFavorite = false,
    required this.category,
    this.reviews = const [],
  });

  factory Experience.fromMap(String id, Map<String, dynamic> data) => Experience(
        id: id,
        title: data['title'],
        description: data['description'],
        latitude: data['latitude'],
        longitude: data['longitude'],
        timestamp: (data['timestamp'] as Timestamp).toDate(),
        isFavorite: data['isFavorite'] ?? false,
        category: data['category'] ?? 'Uncategorized',
        reviews: (data['reviews'] as List<dynamic>? ?? [])
            .map((r) => Review.fromMap(r as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': timestamp,
        'isFavorite': isFavorite,
        'category': category,
        'reviews': reviews.map((r) => r.toMap()).toList(),
      };
}