import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';
import '../../models/event_model.dart';
import '../../config/app_theme.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController(text: '09:00 AM - 02:00 PM');
  final TextEditingController _seatsController = TextEditingController(text: '100');
  
  String _selectedMonastery = 'Rumtek Monastery';
  String _selectedCategory = 'Sacred Ritual';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 3));

  final List<String> _monasteries = [
    'Rumtek Monastery',
    'Pemayangtse Monastery',
    'Enchey Monastery',
    'Tashiding Monastery',
    'Ranka Monastery',
  ];

  final List<String> _categories = [
    'Sacred Ritual',
    'Monastic Dance',
    'Festival',
    'Meditation & Teaching',
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Local Cultural Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentAmber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accentAmber),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user, color: AppTheme.primaryOrange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Posting as Local Host: ${user?.displayName ?? 'Local'} (${user?.monasteryAffiliation ?? 'Sikkim Host'})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  hintText: 'e.g., Annual Losar Mask Dance Ceremony',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter event title' : null,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedMonastery,
                decoration: const InputDecoration(
                  labelText: 'Monastery Venue',
                  border: OutlineInputBorder(),
                ),
                items: _monasteries.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (val) => setState(() => _selectedMonastery = val!),
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Event Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),

              const SizedBox(height: 16),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                trailing: const Icon(Icons.calendar_today, color: AppTheme.primaryOrange),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Timing',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _seatsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Total Visitor Capacity / Seats',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Event Description & Etiquette Instructions',
                  hintText: 'Describe ritual significance, entry rules, etc.',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Please enter description' : null,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String _getMonasteryBannerImage(String monastery) {
                        final lower = monastery.toLowerCase();
                        if (lower.contains('pemayangtse')) return 'assets/images/pemayangtse_preview.jpg';
                        if (lower.contains('enchey')) return 'assets/images/enchey_preview.jpg';
                        if (lower.contains('tashiding')) return 'assets/images/tashiding_preview.jpg';
                        return 'assets/images/rumtek_preview.jpg';
                      }

                      final newEvent = EventModel(
                        id: 'event_${DateTime.now().millisecondsSinceEpoch}',
                        title: _titleController.text,
                        monasteryId: _selectedMonastery.toLowerCase().split(' ').first,
                        monasteryName: _selectedMonastery,
                        createdByUid: user?.uid ?? 'local_user',
                        createdByName: '${user?.displayName ?? 'Local'} (Local Host)',
                        eventDate: _selectedDate,
                        timeString: _timeController.text,
                        category: _selectedCategory,
                        description: _descriptionController.text,
                        bannerImageUrl: _getMonasteryBannerImage(_selectedMonastery),
                        totalSeats: int.tryParse(_seatsController.text) ?? 100,
                        bookedSeats: 0,
                      );

                      final success = await eventProvider.addEvent(newEvent);
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('🎉 Local Event Published! Visible to all Tourists.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    }
                  },
                  icon: const Icon(Icons.publish),
                  label: const Text('Publish Event to Tourist Calendar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
