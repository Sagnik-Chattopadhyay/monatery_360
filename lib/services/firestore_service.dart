import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/monastery_model.dart';
import '../models/event_model.dart';
import '../models/archive_model.dart';
import '../models/tourism_service_model.dart';
import '../models/user_model.dart';
import '../config/firebase_options.dart';
import 'mock_data_service.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirestoreService() {
    seedInitialFirestoreData();
  }

  // Monastery Queries
  Future<List<MonasteryModel>> getMonasteries() async {
    if (!DefaultFirebaseOptions.useLiveFirebase) {
      return MockDataService.getMonasteries();
    }
    try {
      final snapshot = await _db.collection('monasteries').get();
      if (snapshot.docs.isEmpty) {
        await seedInitialFirestoreData();
        return MockDataService.getMonasteries();
      }
      // Re-sync local panorama asset paths into Firestore documents
      await seedInitialFirestoreData();
      return MockDataService.getMonasteries();
    } catch (e) {
      debugPrint('Firestore fetch monasteries error: $e');
      return MockDataService.getMonasteries();
    }
  }

  // Cultural Calendar Events
  Future<List<EventModel>> getEvents() async {
    if (!DefaultFirebaseOptions.useLiveFirebase) {
      return MockDataService.getEvents();
    }
    try {
      final snapshot = await _db
          .collection('events')
          .orderBy('eventDate', descending: false)
          .get();
      if (snapshot.docs.isEmpty) {
        await seedInitialFirestoreData();
        return MockDataService.getEvents();
      }
      await seedInitialFirestoreData();
      return MockDataService.getEvents();
    } catch (e) {
      debugPrint('Firestore fetch events error: $e');
      return MockDataService.getEvents();
    }
  }

  /// Local user adds a new local event to the cultural calendar
  Future<bool> addEvent(EventModel event) async {
    if (DefaultFirebaseOptions.useLiveFirebase) {
      try {
        await _db.collection('events').doc(event.id).set(event.toMap());
        return true;
      } catch (e) {
        debugPrint('Firestore add event error: $e');
      }
    }
    return true;
  }

  /// Tourist user RSVPs for an event
  Future<bool> rsvpEvent(String eventId, String userId) async {
    if (DefaultFirebaseOptions.useLiveFirebase) {
      try {
        await _db.collection('events').doc(eventId).update({
          'rsvpedUserIds': FieldValue.arrayUnion([userId]),
          'bookedSeats': FieldValue.increment(1),
        });
        return true;
      } catch (e) {
        debugPrint('Firestore RSVP error: $e');
      }
    }
    return true;
  }

  // Archives Queries
  Future<List<ArchiveModel>> getArchives() async {
    if (!DefaultFirebaseOptions.useLiveFirebase) {
      return MockDataService.getArchives();
    }
    try {
      final snapshot = await _db.collection('archives').get();
      if (snapshot.docs.isEmpty) {
        return MockDataService.getArchives();
      }
      return snapshot.docs
          .map((doc) => ArchiveModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      return MockDataService.getArchives();
    }
  }

  // Tourism & Transport Queries
  Future<List<TourismServiceModel>> getTourismServices() async {
    if (!DefaultFirebaseOptions.useLiveFirebase) {
      return MockDataService.getTourismServices();
    }
    try {
      final snapshot = await _db.collection('tourism_services').get();
      if (snapshot.docs.isEmpty) {
        return MockDataService.getTourismServices();
      }
      return snapshot.docs
          .map((doc) => TourismServiceModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      return MockDataService.getTourismServices();
    }
  }

  /// Save registered user document to Firestore 'users' collection
  Future<void> saveUser(UserModel user) async {
    if (DefaultFirebaseOptions.useLiveFirebase) {
      try {
        await _db.collection('users').doc(user.uid).set(user.toMap());
        debugPrint('🎉 Saved User ${user.displayName} (${user.email}) to Firestore users collection!');
      } catch (e) {
        debugPrint('Firestore saveUser error: $e');
      }
    }
  }

  /// Retrieve user document from Firestore 'users' collection
  Future<UserModel?> getUser(String uid) async {
    if (DefaultFirebaseOptions.useLiveFirebase) {
      try {
        final doc = await _db.collection('users').doc(uid).get();
        if (doc.exists && doc.data() != null) {
          return UserModel.fromMap(doc.data()!, doc.id);
        }
      } catch (e) {
        debugPrint('Firestore getUser error: $e');
      }
    }
    return null;
  }

  /// Retrieve user document from Firestore 'users' collection by email
  Future<UserModel?> getUserByEmail(String email) async {
    if (DefaultFirebaseOptions.useLiveFirebase) {
      try {
        final query = await _db
            .collection('users')
            .where('email', isEqualTo: email.trim().toLowerCase())
            .limit(1)
            .get();
        if (query.docs.isNotEmpty) {
          final doc = query.docs.first;
          return UserModel.fromMap(doc.data(), doc.id);
        }
      } catch (e) {
        debugPrint('Firestore getUserByEmail error: $e');
      }
    }
    return null;
  }

  /// Populate empty Firestore with initial monastery data, events, archives, & tourism services
  Future<void> seedInitialFirestoreData() async {
    if (!DefaultFirebaseOptions.useLiveFirebase) return;

    try {
      // 1. Seed Monasteries
      for (var m in MockDataService.getMonasteries()) {
        await _db.collection('monasteries').doc(m.id).set(m.toMap());
      }
      // 2. Seed Events
      for (var e in MockDataService.getEvents()) {
        await _db.collection('events').doc(e.id).set(e.toMap());
      }
      // 3. Seed Archives
      for (var a in MockDataService.getArchives()) {
        await _db.collection('archives').doc(a.id).set(a.toMap());
      }
      // 4. Seed Tourism Services
      for (var s in MockDataService.getTourismServices()) {
        await _db.collection('tourism_services').doc(s.id).set(s.toMap());
      }
      // 5. Seed Initial User Document
      final sampleUser = UserModel(
        uid: 'demo_tourist_1',
        email: 'sagnik@gmail.com',
        displayName: 'Sagnik (Sample Tourist)',
        role: UserRole.tourist,
        visitedCount: 12,
        toursCompleted: 4,
        badgesCount: 8,
        createdAt: DateTime.now(),
        hasAsthma: true,
        hasAltitudeSensitivity: true,
      );
      await _db.collection('users').doc(sampleUser.uid).set(sampleUser.toMap());

      debugPrint('🎉 Firestore successfully seeded with initial Monastery 360 collections including USERS!');
    } catch (e) {
      debugPrint('Firestore seeding note: $e');
    }
  }
}
