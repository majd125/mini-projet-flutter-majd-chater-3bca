/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/favorite_model.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add media to favorites
  Future<void> addToFavorites({
    required String mediaId,
    required String mediaTitle,
    required String mediaType,
    required String mediaAuthor,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    print('🎯 Adding to favorites: $mediaTitle');

    // Check if already in favorites
    final existing = await _firestore
        .collection('favorites')
        .where('userId', isEqualTo: user.uid)
        .where('mediaId', isEqualTo: mediaId)
        .get();

    if (existing.docs.isNotEmpty) {
      throw Exception('Already in favorites');
    }

    // Add to favorites
    await _firestore.collection('favorites').add({
      'userId': user.uid,
      'mediaId': mediaId,
      'mediaTitle': mediaTitle,
      'mediaType': mediaType,
      'mediaAuthor': mediaAuthor,
      'addedDate': DateTime.now(),
    });

    print('✅ Added to favorites successfully');
  }

  // Remove media from favorites
  Future<void> removeFromFavorites(String favoriteId) async {
    print('🗑️ Removing favorite: $favoriteId');
    await _firestore.collection('favorites').doc(favoriteId).delete();
    print('✅ Favorite removed successfully');
  }

  // Remove from favorites by mediaId
  Future<void> removeFromFavoritesByMediaId(String mediaId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    print('🗑️ Removing favorite by mediaId: $mediaId');

    final favorite = await _firestore
        .collection('favorites')
        .where('userId', isEqualTo: user.uid)
        .where('mediaId', isEqualTo: mediaId)
        .get();

    if (favorite.docs.isNotEmpty) {
      await _firestore
          .collection('favorites')
          .doc(favorite.docs.first.id)
          .delete();
      print('✅ Favorite removed successfully');
    }
  }

  // Get user's favorites
  Stream<List<Favorite>> getUserFavorites() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    print('📚 Getting user favorites for: ${user.uid}');

    return _firestore
        .collection('favorites')
        .where('userId', isEqualTo: user.uid)
        .orderBy('addedDate', descending: true)
        .snapshots()
        .handleError((error) {
          print('🔥 FAVORITES ERROR: $error');
        })
        .map((snapshot) {
          print('✅ Loaded ${snapshot.docs.length} favorites');
          return snapshot.docs
              .map((doc) => Favorite.fromFirestore(doc))
              .toList();
        });
  }

  // Check if media is in user's favorites
  Stream<bool> isMediaInFavorites(String mediaId) {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('favorites')
        .where('userId', isEqualTo: user.uid)
        .where('mediaId', isEqualTo: mediaId)
        .snapshots()
        .handleError((error) {
          print('🔥 FAVORITES CHECK ERROR: $error');
        })
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  // Get favorite ID for a media item
  Future<String?> getFavoriteId(String mediaId) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final snapshot = await _firestore
        .collection('favorites')
        .where('userId', isEqualTo: user.uid)
        .where('mediaId', isEqualTo: mediaId)
        .get();

    return snapshot.docs.isNotEmpty ? snapshot.docs.first.id : null;
  }
}
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/favorite_model.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add media to favorites
  Future<void> addToFavorites({
    required String mediaId,
    required String mediaTitle,
    required String mediaType,
    required String mediaAuthor,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Check if already in favorites
    final existing = await _firestore
        .collection('favorites')
        .where('userId', isEqualTo: user.uid)
        .where('mediaId', isEqualTo: mediaId)
        .get();

    if (existing.docs.isNotEmpty) {
      throw Exception('Already in favorites');
    }

    // Add to favorites
    await _firestore.collection('favorites').add({
      'userId': user.uid,
      'mediaId': mediaId,
      'mediaTitle': mediaTitle,
      'mediaType': mediaType,
      'mediaAuthor': mediaAuthor,
      'addedDate': DateTime.now(),
    });
  }

  // Remove media from favorites
  Future<void> removeFromFavorites(String favoriteId) async {
    await _firestore.collection('favorites').doc(favoriteId).delete();
  }

  // Remove from favorites by mediaId
  Future<void> removeFromFavoritesByMediaId(String mediaId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final favorite = await _firestore
        .collection('favorites')
        .where('userId', isEqualTo: user.uid)
        .where('mediaId', isEqualTo: mediaId)
        .get();

    if (favorite.docs.isNotEmpty) {
      await _firestore
          .collection('favorites')
          .doc(favorite.docs.first.id)
          .delete();
    }
  }

  // Get user's favorites
  Stream<List<Favorite>> getUserFavorites() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('favorites')
        .where('userId', isEqualTo: user.uid)
        .orderBy('addedDate', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Favorite.fromFirestore(doc)).toList(),
        );
  }

  // Check if media is in user's favorites
  Stream<bool> isMediaInFavorites(String mediaId) {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('favorites')
        .where('userId', isEqualTo: user.uid)
        .where('mediaId', isEqualTo: mediaId)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  // Get favorite ID for a media item
  Future<String?> getFavoriteId(String mediaId) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final snapshot = await _firestore
        .collection('favorites')
        .where('userId', isEqualTo: user.uid)
        .where('mediaId', isEqualTo: mediaId)
        .get();

    return snapshot.docs.isNotEmpty ? snapshot.docs.first.id : null;
  }
}
