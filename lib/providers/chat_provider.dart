import 'package:flutter/material.dart';
import '../services/gemini_ai_service.dart';
import '../models/user_model.dart';
import '../models/event_model.dart';
import '../models/monastery_model.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isError;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
  });
}

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          'Namaste & Tashi Delek! I am Monk AI, your spiritual companion & health safety guide. How may I assist your journey through the sacred monasteries of Sikkim today?',
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];

  bool _isTyping = false;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;

  Future<void> sendMessage({
    required String text,
    UserModel? user,
    List<EventModel> events = const [],
    List<MonasteryModel> monasteries = const [],
  }) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    _messages.add(userMsg);
    _isTyping = true;
    notifyListeners();

    final responseText = await GeminiAIService.getMonkAIResponse(
      userMessage: text,
      user: user,
      events: events,
      monasteries: monasteries,
    );

    _isTyping = false;
    _messages.add(ChatMessage(
      text: responseText,
      isUser: false,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  void clearChat() {
    _messages.clear();
    _messages.add(
      ChatMessage(
        text:
            'Namaste & Tashi Delek! I am Monk AI, your spiritual companion. How may I assist your journey through the sacred monasteries of Sikkim today?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
