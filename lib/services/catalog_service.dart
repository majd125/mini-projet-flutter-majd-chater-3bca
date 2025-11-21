import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/media_model.dart';

class CatalogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all media
  Stream<List<Media>> getMedia() {
    return _firestore
        .collection('media')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Media.fromFirestore(doc)).toList(),
        );
  }

  // Get media by type
  Stream<List<Media>> getMediaByType(String type) {
    return _firestore
        .collection('media')
        .where('type', isEqualTo: type)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Media.fromFirestore(doc)).toList(),
        );
  }

  // Search media
  Stream<List<Media>> searchMedia(String query) {
    return _firestore
        .collection('media')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThan: query + 'z')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Media.fromFirestore(doc)).toList(),
        );
  }

  // Add new media (for admin)
  Future<void> addMedia(Media media) async {
    await _firestore.collection('media').doc(media.id).set(media.toFirestore());
  }

  // Update media availability
  Future<void> updateMediaAvailability(String mediaId, bool available) async {
    await _firestore.collection('media').doc(mediaId).update({
      'available': available,
    });
  }
}
