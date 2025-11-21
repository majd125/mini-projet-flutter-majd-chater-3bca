/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/borrowing_model.dart';

class BorrowingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Borrow a media item
  Future<void> borrowMedia(String mediaId, String mediaTitle) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final borrowDate = DateTime.now();
    final dueDate = DateTime.now().add(Duration(days: 21)); // 3 weeks

    // Create borrowing record
    await _firestore.collection('borrowings').add({
      'userId': user.uid,
      'mediaId': mediaId,
      'mediaTitle': mediaTitle,
      'borrowDate': borrowDate,
      'dueDate': dueDate,
      'status': 'active',
    });

    // TODO: We'll handle media availability differently later
    // For now, comment out this part to make borrowing work
    /*
    // Update media availability
    await _firestore.collection('media').doc(mediaId).update({
      'available': false,
    });
    */
  }

  // Return a media item
  Future<void> returnMedia(String borrowingId, String mediaId) async {
    await _firestore.collection('borrowings').doc(borrowingId).update({
      'returnDate': DateTime.now(),
      'status': 'returned',
    });

    // TODO: We'll handle media availability differently later
    // For now, comment out this part
    /*
    // Update media availability
    await _firestore.collection('media').doc(mediaId).update({
      'available': true,
    });
    */
  }

  // Get user's active borrowings
  Stream<List<Borrowing>> getUserBorrowings() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('borrowings')
        .where('userId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Borrowing.fromFirestore(doc)).toList(),
        );
  }

  // Get user's borrowing history
  Stream<List<Borrowing>> getUserBorrowingHistory() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('borrowings')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Borrowing.fromFirestore(doc)).toList(),
        );
  }
}
*/
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/borrowing_model.dart';

class BorrowingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Borrow a media item
  Future<void> borrowMedia(String mediaId, String mediaTitle) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // First check if media is available
    final mediaDoc = await _firestore.collection('media').doc(mediaId).get();
    if (!mediaDoc.exists) {
      throw Exception('Media not found');
    }

    final mediaData = mediaDoc.data();
    if (mediaData == null || mediaData['available'] == false) {
      throw Exception('Media is not available');
    }

    final borrowDate = DateTime.now();
    final dueDate = DateTime.now().add(Duration(days: 21)); // 3 weeks

    // Create borrowing record
    await _firestore.collection('borrowings').add({
      'userId': user.uid,
      'mediaId': mediaId,
      'mediaTitle': mediaTitle,
      'borrowDate': borrowDate,
      'dueDate': dueDate,
      'status': 'active',
    });

    // Update media availability
    await _firestore.collection('media').doc(mediaId).update({
      'available': false,
    });
  }

  // Return a media item
  Future<void> returnMedia(String borrowingId, String mediaId) async {
    await _firestore.collection('borrowings').doc(borrowingId).update({
      'returnDate': DateTime.now(),
      'status': 'returned',
    });

    // Update media availability
    await _firestore.collection('media').doc(mediaId).update({
      'available': true,
    });
  }

  // Get user's active borrowings
  Stream<List<Borrowing>> getUserBorrowings() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('borrowings')
        .where('userId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Borrowing.fromFirestore(doc)).toList(),
        );
  }

  // Get user's borrowing history
  Stream<List<Borrowing>> getUserBorrowingHistory() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('borrowings')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Borrowing.fromFirestore(doc)).toList(),
        );
  }

  // Check if user has already borrowed this media
  Future<bool> hasUserBorrowedMedia(String mediaId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final snapshot = await _firestore
        .collection('borrowings')
        .where('userId', isEqualTo: user.uid)
        .where('mediaId', isEqualTo: mediaId)
        .where('status', isEqualTo: 'active')
        .get();

    return snapshot.docs.isNotEmpty;
  }
}
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/borrowing_model.dart';

class BorrowingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Borrow a media item
  Future<void> borrowMedia(String mediaId, String mediaTitle) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      // First check if media is available
      final mediaDoc = await _firestore.collection('media').doc(mediaId).get();
      if (!mediaDoc.exists) {
        throw Exception('Media not found');
      }

      final mediaData = mediaDoc.data();
      if (mediaData == null || mediaData['available'] == false) {
        throw Exception('Media is not available');
      }

      final borrowDate = DateTime.now();
      final dueDate = DateTime.now().add(Duration(days: 21)); // 3 weeks

      // Create borrowing record
      await _firestore.collection('borrowings').add({
        'userId': user.uid,
        'mediaId': mediaId,
        'mediaTitle': mediaTitle,
        'borrowDate': borrowDate,
        'dueDate': dueDate,
        'status': 'active',
      });

      // Update media availability
      await _firestore.collection('media').doc(mediaId).update({
        'available': false,
      });
    } catch (e) {
      print('Borrowing error: $e');
      rethrow;
    }
  }

  // Return a media item
  Future<void> returnMedia(String borrowingId, String mediaId) async {
    try {
      await _firestore.collection('borrowings').doc(borrowingId).update({
        'returnDate': DateTime.now(),
        'status': 'returned',
      });

      // Update media availability
      await _firestore.collection('media').doc(mediaId).update({
        'available': true,
      });
    } catch (e) {
      print('Return error: $e');
      rethrow;
    }
  }

  // Get user's active borrowings
  Stream<List<Borrowing>> getUserBorrowings() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('borrowings')
        .where('userId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Borrowing.fromFirestore(doc)).toList(),
        );
  }

  // Get user's borrowing history
  Stream<List<Borrowing>> getUserBorrowingHistory() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('borrowings')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Borrowing.fromFirestore(doc)).toList(),
        );
  }

  // Check if user has already borrowed this media
  Future<bool> hasUserBorrowedMedia(String mediaId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final snapshot = await _firestore
        .collection('borrowings')
        .where('userId', isEqualTo: user.uid)
        .where('mediaId', isEqualTo: mediaId)
        .where('status', isEqualTo: 'active')
        .get();

    return snapshot.docs.isNotEmpty;
  }
}
