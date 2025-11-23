import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/event_model.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all upcoming events
  Stream<List<Event>> getUpcomingEvents() {
    return _firestore
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: DateTime.now())
        .where('isActive', isEqualTo: true)
        .orderBy('date')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList(),
        );
  }

  // Get events by category
  Stream<List<Event>> getEventsByCategory(String category) {
    return _firestore
        .collection('events')
        .where('category', isEqualTo: category)
        .where('isActive', isEqualTo: true)
        .where('date', isGreaterThanOrEqualTo: DateTime.now())
        .orderBy('date')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList(),
        );
  }

  // Register for an event
  Future<void> registerForEvent(String eventId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Check if already registered
    final existingRegistration = await _firestore
        .collection('event_registrations')
        .where('userId', isEqualTo: user.uid)
        .where('eventId', isEqualTo: eventId)
        .get();

    if (existingRegistration.docs.isNotEmpty) {
      throw Exception('Already registered for this event');
    }

    // Get event to check availability
    final eventDoc = await _firestore.collection('events').doc(eventId).get();
    if (!eventDoc.exists) throw Exception('Event not found');

    final event = Event.fromFirestore(eventDoc);
    if (!event.canRegister) {
      throw Exception('Event is full or not available');
    }

    // Create registration
    await _firestore.collection('event_registrations').add({
      'userId': user.uid,
      'eventId': eventId,
      'eventTitle': event.title,
      'registrationDate': DateTime.now(),
    });

    // Update participant count
    await _firestore.collection('events').doc(eventId).update({
      'currentParticipants': FieldValue.increment(1),
    });
  }

  // Unregister from event
  Future<void> unregisterFromEvent(String eventId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Find registration
    final registration = await _firestore
        .collection('event_registrations')
        .where('userId', isEqualTo: user.uid)
        .where('eventId', isEqualTo: eventId)
        .get();

    if (registration.docs.isNotEmpty) {
      // Delete registration
      await _firestore
          .collection('event_registrations')
          .doc(registration.docs.first.id)
          .delete();

      // Update participant count
      await _firestore.collection('events').doc(eventId).update({
        'currentParticipants': FieldValue.increment(-1),
      });
    }
  }

  // Check if user is registered for event
  Stream<bool> isUserRegistered(String eventId) {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('event_registrations')
        .where('userId', isEqualTo: user.uid)
        .where('eventId', isEqualTo: eventId)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  // Get user's event registrations
  Stream<List<EventRegistration>> getUserRegistrations() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('event_registrations')
        .where('userId', isEqualTo: user.uid)
        .orderBy('registrationDate', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final registrations = <EventRegistration>[];

          for (final doc in snapshot.docs) {
            final data = doc.data();
            final eventDoc = await _firestore
                .collection('events')
                .doc(data['eventId'])
                .get();

            if (eventDoc.exists) {
              registrations.add(
                EventRegistration(
                  id: doc.id,
                  userId: data['userId'],
                  eventId: data['eventId'],
                  eventTitle: data['eventTitle'],
                  registrationDate: data['registrationDate'].toDate(),
                  event: Event.fromFirestore(eventDoc),
                ),
              );
            }
          }

          return registrations;
        });
  }
}

class EventRegistration {
  String id;
  String userId;
  String eventId;
  String eventTitle;
  DateTime registrationDate;
  Event event;

  EventRegistration({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.eventTitle,
    required this.registrationDate,
    required this.event,
  });
}
