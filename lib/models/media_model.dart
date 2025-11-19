import 'package:cloud_firestore/cloud_firestore.dart'; // ADD THIS IMPORT

class Media {
  String id;
  String title;
  String author;
  String type; // 'book', 'magazine', 'film'
  String description;
  String category;
  bool available;
  String imageUrl;
  int? pages; // For books
  int? duration; // For films in minutes
  String? isbn; // For books
  DateTime? publicationDate;
  double rating;

  Media({
    required this.id,
    required this.title,
    required this.author,
    required this.type,
    required this.description,
    required this.category,
    required this.available,
    required this.imageUrl,
    this.pages,
    this.duration,
    this.isbn,
    this.publicationDate,
    this.rating = 0.0,
  });

  // Create Media from Firestore document
  factory Media.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Media(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      type: data['type'] ?? 'book',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      available: data['available'] ?? true,
      imageUrl: data['imageUrl'] ?? '',
      pages: data['pages'],
      duration: data['duration'],
      isbn: data['isbn'],
      publicationDate: data['publicationDate']?.toDate(),
      rating: (data['rating'] ?? 0.0).toDouble(),
    );
  }

  // Convert Media to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'author': author,
      'type': type,
      'description': description,
      'category': category,
      'available': available,
      'imageUrl': imageUrl,
      'pages': pages,
      'duration': duration,
      'isbn': isbn,
      'publicationDate': publicationDate,
      'rating': rating,
    };
  }
}
