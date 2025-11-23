import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String title;
  String description;
  DateTime date;
  String location;
  int maxParticipants;
  int currentParticipants;
  String imageUrl;
  String category;
  bool isActive;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.imageUrl,
    required this.category,
    required this.isActive,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: data['date']?.toDate() ?? DateTime.now(),
      location: data['location'] ?? '',
      maxParticipants: data['maxParticipants'] ?? 0,
      currentParticipants: data['currentParticipants'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? 'Cultural',
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'location': location,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'imageUrl': imageUrl,
      'category': category,
      'isActive': isActive,
    };
  }

  bool get isFull => currentParticipants >= maxParticipants;
  bool get canRegister => isActive && !isFull && date.isAfter(DateTime.now());
  int get availableSpots => maxParticipants - currentParticipants;
}
