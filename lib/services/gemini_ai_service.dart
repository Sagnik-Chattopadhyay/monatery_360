import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/event_model.dart';
import '../models/monastery_model.dart';

class GeminiAIService {
  static String apiKey = const String.fromEnvironment('GEMINI_API_KEY', defaultValue: 'YOUR_GEMINI_API_KEY');


  /// Personalized Monk AI Chat Assistant response generator with Database & Health RAG
  static Future<String> getMonkAIResponse({
    required String userMessage,
    UserModel? user,
    List<EventModel> events = const [],
    List<MonasteryModel> monasteries = const [],
  }) async {
    // If API key is placeholder, fallback to rich offline RAG engine
    if (apiKey == 'YOUR_GEMINI_API_KEY' || apiKey.isEmpty) {
      return _generateOfflineMonkResponse(userMessage, user, events, monasteries);
    }

    try {
      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');

      // Construct live database & medical profile context
      final userHealthSummary = user == null
          ? 'No registered user profile attached.'
          : '''
- Name: ${user.displayName}
- Account Role: ${user.role.name.toUpperCase()} (Permanent)
- Asthma / Respiratory Condition: ${user.hasAsthma ? "YES (Warning Required for >1700m altitude)" : "NO"}
- Heart / Cardiovascular Condition: ${user.hasHeartCondition ? "YES (Caution Required)" : "NO"}
- High-Altitude Sickness (AMS) History: ${user.hasAltitudeSensitivity ? "YES (Risk Warning Required)" : "NO"}
- Has Medical Risk Flag: ${user.hasHealthRisk}
''';

      final eventsSummary = events.isEmpty
          ? 'No upcoming events loaded.'
          : events
              .map((e) =>
                  '- ${e.title} at ${e.monasteryName} (Date: ${e.eventDate.toString().split(' ').first}, Seats Available: ${e.totalSeats - e.bookedSeats})')
              .join('\n');

      final monasteriesSummary = monasteries.isEmpty
          ? 'No monasteries loaded.'
          : monasteries
              .map((m) =>
                  '- ${m.name}: Altitude ${m.altitudeMeters}m (${m.locationName}), Order/Sect: ${m.orderSect}')
              .join('\n');

      final promptText = '''
You are "Monk AI", a wise, tranquil, and deeply knowledgeable spiritual companion & heritage guide for the ancient monasteries of Sikkim and the Himalayas.
Speak with warmth, respect, peace, and mindfulness (using traditional greetings like "Tashi Delek" or "Namaste").

You have direct access to our live Database & User Health Profile:

--- USER PROFILE & MEDICAL DATA ---
$userHealthSummary

--- LIVE CULTURAL EVENTS CALENDAR ---
$eventsSummary

--- MONASTERIES DATABASE ---
$monasteriesSummary

GUIDELINES:
1. Address the user by their name ("${user?.displayName ?? 'Traveler'}") naturally.
2. If the user asks about health, high-altitude travel, or specific high-altitude monasteries (like Pemayangtse 2,085m or Enchey 1,700m), check their medical profile (Asthma, Heart, AMS). If they have any medical conditions, give personalized, caring health advisories (e.g., carrying inhalers, acclimatization, resting).
3. If they ask about events or schedule, list relevant upcoming events from the live calendar provided above.
4. Keep answers peaceful, accurate, and helpful.

User query: "$userMessage"
''';

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': promptText}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['candidates'][0]['content']['parts'][0]['text'];
        return reply ?? 'Tashi Delek. May peace and clarity guide your journey.';
      } else {
        return _generateOfflineMonkResponse(userMessage, user, events, monasteries);
      }
    } catch (e) {
      return _generateOfflineMonkResponse(userMessage, user, events, monasteries);
    }
  }

  /// Dynamic Offline RAG Engine with User Medical & Database Context
  static String _generateOfflineMonkResponse(
    String query,
    UserModel? user,
    List<EventModel> events,
    List<MonasteryModel> monasteries,
  ) {
    final q = query.toLowerCase();
    final name = user?.displayName ?? 'Traveler';

    if (q.contains('health') || q.contains('medical') || q.contains('altitude') || q.contains('asthma') || q.contains('heart') || q.contains('safe')) {
      if (user != null && user.hasHealthRisk) {
        final List<String> risks = [];
        if (user.hasAsthma) risks.add('Asthma / Respiratory condition');
        if (user.hasHeartCondition) risks.add('Heart / Cardiovascular condition');
        if (user.hasAltitudeSensitivity) risks.add('Altitude Sickness (AMS) sensitivity');

        return 'Tashi Delek $name. I have reviewed your health profile. You reported: ${risks.join(', ')}.\n\n'
            '⚠️ High-Altitude Medical Safety Notice:\n'
            'Monasteries like Pemayangtse (2,085m) and Enchey (1,700m) are at high elevation with lower oxygen density.\n'
            '• Carry your prescribed inhaler and medications at all times.\n'
            '• Ascend slowly and allow time for acclimatization in Gangtok or Pelling.\n'
            '• Stay hydrated and avoid strenuous climbing up monastery staircases.';
      } else {
        return 'Tashi Delek $name. Your health profile indicates no high-altitude restrictions recorded. However, monasteries in Sikkim reach up to 2,085m (Pemayangtse). Stay hydrated, wear warm layers, and pace yourself while walking sacred paths.';
      }
    } else if (q.contains('event') || q.contains('calendar') || q.contains('bumchu') || q.contains('dance') || q.contains('festival')) {
      if (events.isNotEmpty) {
        final eventList = events
            .take(3)
            .map((e) => '• ${e.title} at ${e.monasteryName} (${e.totalSeats - e.bookedSeats} seats open)')
            .join('\n');
        return 'Tashi Delek $name! Here are upcoming sacred events from our live Cultural Calendar:\n\n$eventList\n\nYou can RSVP directly on the Cultural Calendar tab!';
      } else {
        return 'Tashi Delek $name! Bumchu at Tashiding Monastery and Cham Mask Dances at Pemayangtse are major upcoming highlights on our sacred calendar.';
      }
    } else if (q.contains('rumtek') || q.contains('pemayangtse') || q.contains('enchey') || q.contains('tashiding')) {
      MonasteryModel? match;
      for (var m in monasteries) {
        if (q.contains(m.name.toLowerCase()) || q.contains(m.id)) {
          match = m;
          break;
        }
      }
      if (match != null) {
        String healthWarn = '';
        if (user != null && user.hasHealthRisk && match.altitudeMeters >= 1700) {
          healthWarn = '\n\n⚠️ Health Notice for $name: ${match.name} is at ${match.altitudeMeters}m elevation. Based on your health profile, please take frequent rest stops during ascent.';
        }
        return 'Tashi Delek $name. ${match.name} sits at an elevation of ${match.altitudeMeters}m in ${match.locationName}. ${match.description}$healthWarn';
      }
    }

    if (q.contains('hello') || q.contains('hi') || q.contains('tashi delek') || q.contains('namaste')) {
      return 'Tashi Delek & Namaste, $name! I am Monk AI, connected live to your health profile and Sikkim’s monastery database. How may I guide your journey today?';
    } else {
      return 'Tashi Delek $name. The ancient mountains teach us presence and peace. I can answer questions about your health safety, upcoming events, monastery locations, or sacred traditions.';
    }
  }

  /// AI-Powered Monastery Classification
  static String categorizeMonastery(int year, String order) {
    String era;
    if (year < 1700) {
      era = '17th Century (Foundational Era)';
    } else if (year < 1800) {
      era = '18th Century (Royal Kingdom Era)';
    } else if (year < 1900) {
      era = '19th Century (Historic)';
    } else {
      era = '20th Century & Modern';
    }
    return '$era • $order';
  }
}
