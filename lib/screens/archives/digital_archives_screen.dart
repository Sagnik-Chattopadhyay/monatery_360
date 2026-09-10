import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/monastery_provider.dart';
import '../../config/app_theme.dart';

class DigitalArchivesScreen extends StatefulWidget {
  const DigitalArchivesScreen({super.key});

  @override
  State<DigitalArchivesScreen> createState() => _DigitalArchivesScreenState();
}

class _DigitalArchivesScreenState extends State<DigitalArchivesScreen> {
  String _selectedType = 'All';

  @override
  Widget build(BuildContext context) {
    final monasteryProvider = Provider.of<MonasteryProvider>(context);
    final allArchives = monasteryProvider.archives;

    final archives = allArchives.where((a) {
      if (_selectedType == 'All') return true;
      return a.category.toLowerCase() == _selectedType.toLowerCase();
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Manuscript Archives'),
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('manuscript'),
                _buildFilterChip('mural'),
                _buildFilterChip('historical_record'),
              ],
            ),
          ),

          // Archives Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: archives.length,
              itemBuilder: (context, index) {
                final item = archives[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            item.imageUrl.startsWith('assets/')
                                ? Image.asset(
                                    item.imageUrl,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    item.imageUrl,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, err, st) {
                                      return Image.asset('assets/images/rumtek_preview.jpg', width: double.infinity, height: double.infinity, fit: BoxFit.cover);
                                    },
                                  ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.era,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item.monasteryName} • ${item.language}',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedType.toLowerCase() == label.toLowerCase();
    final displayLabel = label == 'historical_record' ? 'Records' : label.toUpperCase();

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(displayLabel),
        selected: isSelected,
        selectedColor: AppTheme.monasteryCrimson,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        onSelected: (_) => setState(() => _selectedType = label),
      ),
    );
  }
}
