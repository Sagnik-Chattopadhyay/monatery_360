import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/monastery_provider.dart';
import '../../config/app_theme.dart';

class MonkAIChatScreen extends StatefulWidget {
  const MonkAIChatScreen({super.key});

  @override
  State<MonkAIChatScreen> createState() => _MonkAIChatScreenState();
}

class _MonkAIChatScreenState extends State<MonkAIChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend(
    String text,
    ChatProvider chatProvider,
    AuthProvider authProvider,
    EventProvider eventProvider,
    MonasteryProvider monasteryProvider,
  ) {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    chatProvider.sendMessage(
      text: cleanText,
      user: authProvider.user,
      events: eventProvider.events,
      monasteries: monasteryProvider.monasteries,
    );
    _textController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    final monasteryProvider = Provider.of<MonasteryProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.surfaceCanvas,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryEmerald,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.secondaryTerracotta.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.psychology, color: AppTheme.secondaryTerracotta, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monk AI RAG Assistant',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      authProvider.user != null
                          ? 'Vitals Connected (${authProvider.user!.displayName.split(' ').first})'
                          : 'Awake & Mindful',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              chatProvider.clearChat();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Chat history cleared', style: GoogleFonts.plusJakartaSans()),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: chatProvider.messages.length,
              itemBuilder: (context, index) {
                final message = chatProvider.messages[index];
                final isUser = message.isUser;

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppTheme.primaryEmerald
                          : (message.isError ? Colors.red.shade50 : Colors.white),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isUser ? 20 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 20),
                      ),
                      border: message.isError
                          ? Border.all(color: AppTheme.monasteryCrimson)
                          : Border.all(color: Colors.black.withOpacity(0.05)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      message.text,
                      style: GoogleFonts.plusJakartaSans(
                        color: isUser
                            ? Colors.white
                            : (message.isError ? AppTheme.monasteryCrimson : Colors.black87),
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (chatProvider.isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.secondaryTerracotta),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Monk AI is analyzing medical vitals & event database...',
                    style: GoogleFonts.plusJakartaSans(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),

          // Interactive Suggested Query Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                _buildQuickChip(
                  icon: Icons.health_and_safety,
                  label: 'Check My High-Altitude Risk',
                  onTap: () => _handleSend(
                    'Check my health safety for high-altitude monasteries',
                    chatProvider,
                    authProvider,
                    eventProvider,
                    monasteryProvider,
                  ),
                ),
                const SizedBox(width: 8),
                _buildQuickChip(
                  icon: Icons.calendar_month,
                  label: 'Upcoming Festivals & Cham Dance',
                  onTap: () => _handleSend(
                    'What upcoming events are on our cultural calendar?',
                    chatProvider,
                    authProvider,
                    eventProvider,
                    monasteryProvider,
                  ),
                ),
                const SizedBox(width: 8),
                _buildQuickChip(
                  icon: Icons.landscape,
                  label: 'Pemayangtse High Pass (2085m)',
                  onTap: () => _handleSend(
                    'Tell me about Pemayangtse Monastery altitude and details',
                    chatProvider,
                    authProvider,
                    eventProvider,
                    monasteryProvider,
                  ),
                ),
              ],
            ),
          ),

          // Bottom Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: GoogleFonts.plusJakartaSans(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Seek wisdom from Monk AI (Vitals, Events, Heritage)...',
                      hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[400], fontSize: 13),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (val) => _handleSend(
                      val,
                      chatProvider,
                      authProvider,
                      eventProvider,
                      monasteryProvider,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _handleSend(
                    _textController.text,
                    chatProvider,
                    authProvider,
                    eventProvider,
                    monasteryProvider,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppTheme.secondaryTerracotta,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip({required IconData icon, required String label, required VoidCallback onTap}) {
    return ActionChip(
      avatar: Icon(icon, size: 15, color: AppTheme.secondaryTerracotta),
      label: Text(
        label,
        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryEmerald),
      ),
      backgroundColor: Colors.white,
      side: const BorderSide(color: AppTheme.secondaryTerracotta, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: onTap,
    );
  }
}

