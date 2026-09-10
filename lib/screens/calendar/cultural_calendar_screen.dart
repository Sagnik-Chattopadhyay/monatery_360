import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/event_provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/app_theme.dart';
import 'add_event_screen.dart';

class CulturalCalendarScreen extends StatelessWidget {
  const CulturalCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final events = eventProvider.events;
    final isLocal = authProvider.isLocal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cultural Calendar'),
        actions: [
          if (isLocal)
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppTheme.primaryOrange, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddEventScreen()),
                );
              },
            ),
        ],
      ),
      floatingActionButton: isLocal
          ? FloatingActionButton.extended(
              backgroundColor: AppTheme.primaryOrange,
              icon: const Icon(Icons.event),
              label: const Text('Post Local Event'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddEventScreen()),
                );
              },
            )
          : null,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final hasRsvped = event.rsvpedUserIds.contains(authProvider.user?.uid);

          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Builder(
                      builder: (context) {
                        String bannerPath = event.bannerImageUrl;
                        if (!bannerPath.startsWith('assets/')) {
                          final lower = event.monasteryName.toLowerCase();
                          if (lower.contains('pemayangtse')) {
                            bannerPath = 'assets/images/pemayangtse_preview.jpg';
                          } else if (lower.contains('enchey')) {
                            bannerPath = 'assets/images/enchey_preview.jpg';
                          } else if (lower.contains('tashiding')) {
                            bannerPath = 'assets/images/tashiding_preview.jpg';
                          } else {
                            bannerPath = 'assets/images/rumtek_preview.jpg';
                          }
                        }
                        return Image.asset(
                          bannerPath,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/images/rumtek_preview.jpg', height: 160, width: double.infinity, fit: BoxFit.cover);
                          },
                        );
                      },
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.monasteryCrimson,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          event.category,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          DateFormat('MMM dd').format(event.eventDate),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: AppTheme.primaryOrange, size: 16),
                          const SizedBox(width: 4),
                          Text(event.monasteryName, style: const TextStyle(fontWeight: FontWeight.w600)),
                          const Spacer(),
                          const Icon(Icons.access_time, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(event.timeString, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hosted by: ${event.createdByName}',
                        style: const TextStyle(fontSize: 12, color: AppTheme.primaryOrange, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        style: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Seats: ${event.bookedSeats} / ${event.totalSeats} Booked',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: hasRsvped ? Colors.green : AppTheme.primaryOrange,
                            ),
                            onPressed: hasRsvped
                                ? null
                                : () async {
                                    final userId = authProvider.user?.uid ?? 'guest';
                                    await eventProvider.rsvpEvent(event.id, userId);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('✅ Event Booked! Check your Profile Pass.')),
                                      );
                                    }
                                  },
                            icon: Icon(hasRsvped ? Icons.check_circle : Icons.bookmark_add),
                            label: Text(hasRsvped ? 'RSVP Confirmed' : 'Book Visitor Pass'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
