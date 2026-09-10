import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/firestore_service.dart';

class EventProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<EventModel> _events = [];
  bool _isLoading = false;

  EventProvider() {
    loadEvents();
  }

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;

  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners();
    _events = await _firestoreService.getEvents();
    _isLoading = false;
    notifyListeners();
  }

  /// Local Host adds a local event
  Future<bool> addEvent(EventModel event) async {
    final success = await _firestoreService.addEvent(event);
    if (success) {
      await loadEvents();
    }
    return success;
  }

  /// Tourist user RSVPs for an event
  Future<bool> rsvpEvent(String eventId, String userId) async {
    final success = await _firestoreService.rsvpEvent(eventId, userId);
    if (success) {
      await loadEvents();
    }
    return success;
  }
}
