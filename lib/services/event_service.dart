import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/event_model.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all upcoming events
  Stream<List<Event>> getUpcomingEvents() {
    print('🎯 Fetching upcoming events from Firestore...');

    return _firestore
        .collection('events')
        .where('date', isGreaterThanOrEqualTo: DateTime.now())
        .where('isActive', isEqualTo: true)
        .orderBy('date')
        .snapshots()
        .handleError((error) {
          print('🔥 GET EVENTS STREAM ERROR: $error');
        })
        .map((snapshot) {
          print('✅ Loaded ${snapshot.docs.length} events');
          return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
        });
  }

  // Get events by category
  Stream<List<Event>> getEventsByCategory(String category) {
    print('🎯 Fetching events for category: $category');

    return _firestore
        .collection('events')
        .where('category', isEqualTo: category)
        .where('isActive', isEqualTo: true)
        .where('date', isGreaterThanOrEqualTo: DateTime.now())
        .orderBy('date')
        .snapshots()
        .handleError((error) {
          print('🔥 GET CATEGORY EVENTS ERROR: $error');
        })
        .map((snapshot) {
          print(
            '✅ Loaded ${snapshot.docs.length} events for category $category',
          );
          return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
        });
  }

  // Register for an event
  Future<void> registerForEvent(String eventId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      print('🎯 [REGISTER] Starting registration for event: $eventId');
      print('🎯 [REGISTER] User UID: ${user.uid}');

      // Check if already registered
      print('🔍 [REGISTER] Checking existing registrations...');
      final existingRegistration = await _firestore
          .collection('event_registrations')
          .where('userId', isEqualTo: user.uid)
          .where('eventId', isEqualTo: eventId)
          .get();

      print(
        '📊 [REGISTER] Existing registrations found: ${existingRegistration.docs.length}',
      );

      if (existingRegistration.docs.isNotEmpty) {
        throw Exception('Already registered for this event');
      }

      // Get event to check availability
      print('🔍 [REGISTER] Fetching event details...');
      final eventDoc = await _firestore.collection('events').doc(eventId).get();
      if (!eventDoc.exists) throw Exception('Event not found');

      final event = Event.fromFirestore(eventDoc);
      print(
        '📄 [REGISTER] Event details: ${event.title}, Available: ${event.canRegister}',
      );

      if (!event.canRegister) {
        throw Exception('Event is full or not available');
      }

      // Create registration
      print('➕ [REGISTER] Creating registration document...');
      await _firestore.collection('event_registrations').add({
        'userId': user.uid,
        'eventId': eventId,
        'eventTitle': event.title,
        'registrationDate': DateTime.now(),
      });
      print('✅ [REGISTER] Registration document created');

      // Update participant count
      print('📈 [REGISTER] Updating participant count...');
      await _firestore.collection('events').doc(eventId).update({
        'currentParticipants': FieldValue.increment(1),
      });
      print('✅ [REGISTER] Participant count updated');

      print('🎉 [REGISTER] Registration completed successfully!');
    } catch (e) {
      print('🔥 [REGISTER] ERROR DETAILS: $e');
      print('🔥 [REGISTER] Error type: ${e.runtimeType}');
      print('🔥 [REGISTER] Stack trace: ${e.toString()}');
      rethrow;
    }
  }

  // Cancel event registration
  Future<void> cancelEventRegistration(String eventId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      print('🗑️ [CANCEL] Starting cancellation for event: $eventId');
      print('🗑️ [CANCEL] User UID: ${user.uid}');

      // Find registration
      print('🔍 [CANCEL] Finding registration...');
      final registration = await _firestore
          .collection('event_registrations')
          .where('userId', isEqualTo: user.uid)
          .where('eventId', isEqualTo: eventId)
          .get();

      print(
        '📊 [CANCEL] Registration documents found: ${registration.docs.length}',
      );

      if (registration.docs.isNotEmpty) {
        final regId = registration.docs.first.id;
        print('➖ [CANCEL] Deleting registration document: $regId');

        // Delete registration
        await _firestore.collection('event_registrations').doc(regId).delete();
        print('✅ [CANCEL] Registration document deleted');

        // Update participant count
        print('📉 [CANCEL] Decreasing participant count...');
        await _firestore.collection('events').doc(eventId).update({
          'currentParticipants': FieldValue.increment(-1),
        });
        print('✅ [CANCEL] Participant count decreased');

        print('🎉 [CANCEL] Cancellation completed successfully!');
      } else {
        print('⚠️ [CANCEL] No registration found to cancel');
        throw Exception('No registration found');
      }
    } catch (e) {
      print('🔥 [CANCEL] ERROR DETAILS: $e');
      print('🔥 [CANCEL] Error type: ${e.runtimeType}');
      print('🔥 [CANCEL] Stack trace: ${e.toString()}');
      rethrow;
    }
  }

  // Check if user is registered for event
  Stream<bool> isUserRegistered(String eventId) {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    print('🔍 [CHECK] Checking if user is registered for event: $eventId');

    return _firestore
        .collection('event_registrations')
        .where('userId', isEqualTo: user.uid)
        .where('eventId', isEqualTo: eventId)
        .snapshots()
        .handleError((error) {
          print('🔥 [CHECK] ERROR: $error');
        })
        .map((snapshot) {
          final isRegistered = snapshot.docs.isNotEmpty;
          print('📊 [CHECK] Registration status: $isRegistered');
          return isRegistered;
        });
  }

  // Get user's event registrations
  Stream<List<EventRegistration>> getUserRegistrations() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    print('🎯 [MY EVENTS] Fetching user registrations for: ${user.uid}');

    return _firestore
        .collection('event_registrations')
        .where('userId', isEqualTo: user.uid)
        .orderBy('registrationDate', descending: true)
        .snapshots()
        .handleError((error) {
          print('🔥 [MY EVENTS] STREAM ERROR: $error');
        })
        .asyncMap((snapshot) async {
          print('📥 [MY EVENTS] Raw registrations: ${snapshot.docs.length}');

          final registrations = <EventRegistration>[];

          for (final doc in snapshot.docs) {
            final data = doc.data();
            print('🔍 [MY EVENTS] Processing registration: ${doc.id}');
            print('   Event ID: ${data['eventId']}');

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
              print(
                '✅ [MY EVENTS] Added registration for: ${data['eventTitle']}',
              );
            } else {
              print('⚠️ [MY EVENTS] Event not found: ${data['eventId']}');
            }
          }

          print('🎉 [MY EVENTS] Total processed: ${registrations.length}');
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
