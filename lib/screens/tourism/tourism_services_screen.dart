import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/monastery_provider.dart';
import '../../config/app_theme.dart';

class TourismServicesScreen extends StatelessWidget {
  const TourismServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final monasteryProvider = Provider.of<MonasteryProvider>(context);
    final services = monasteryProvider.tourismServices;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tourism & Transport Services'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final item = services[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: item.imageUrl.startsWith('assets/')
                        ? Image.asset(
                            item.imageUrl,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            item.imageUrl,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, st) {
                              return Image.asset('assets/images/rumtek_preview.jpg', width: 90, height: 90, fit: BoxFit.cover);
                            },
                          ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.serviceType,
                            style: TextStyle(
                              color: Colors.teal.shade900,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Provider: ${item.providerName}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.pricing,
                          style: const TextStyle(
                            color: AppTheme.primaryOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.phone_in_talk, color: Colors.green),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling ${item.providerName}: ${item.phoneContact}')),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
