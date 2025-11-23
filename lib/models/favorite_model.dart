import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  String id;
  String userId;
  String mediaId;
  String mediaTitle;
  String mediaType;
  String mediaAuthor;
  DateTime addedDate;

  Favorite({
    required this.id,
    required this.userId,
    required this.mediaId,
    required this.mediaTitle,
    required this.mediaType,
    required this.mediaAuthor,
    required this.addedDate,
  });

  factory Favorite.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Favorite(
      id: doc.id,
      userId: data['userId'] ?? '',
      mediaId: data['mediaId'] ?? '',
      mediaTitle: data['mediaTitle'] ?? '',
      mediaType: data['mediaType'] ?? 'book',
      mediaAuthor: data['mediaAuthor'] ?? '',
      addedDate: data['addedDate']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'mediaId': mediaId,
      'mediaTitle': mediaTitle,
      'mediaType': mediaType,
      'mediaAuthor': mediaAuthor,
      'addedDate': addedDate,
    };
  }
}
