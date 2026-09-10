import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/monastery_provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/app_theme.dart';
import 'panorama_viewer_screen.dart';

class VirtualToursScreen extends StatefulWidget {
  const VirtualToursScreen({super.key});

  @override
  State<VirtualToursScreen> createState() => _VirtualToursScreenState();
}

class _VirtualToursScreenState extends State<VirtualToursScreen> {
  String _selectedFilter = 'All Tours';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final monasteryProvider = Provider.of<MonasteryProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    var filtered = monasteryProvider.monasteries.where((m) {
      if (_searchQuery.isNotEmpty && !m.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      if (_selectedFilter == 'Prayer Halls') return m.name.contains('Rumtek') || m.name.contains('Pemayangtse');
      if (_selectedFilter == 'Sacred Murals') return m.name.contains('Enchey');
      if (_selectedFilter == 'Aerial Overflights') return m.name.contains('Tashiding');
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.surfaceCanvas,
      body: SafeArea(
        child: Column(
          children: [
            // Top Ambient Atmospheric Header & Toolbar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.view_in_ar, size: 16, color: AppTheme.tertiarySage),
                              const SizedBox(width: 4),
                              Text(
                                'SPATIAL AUDIO & AR SANCTUARIES',
                                style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.tertiarySage, letterSpacing: 0.8),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '360° Virtual Tours',
                            style: GoogleFonts.plusJakartaSans(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.primaryEmerald),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.cardLow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.hdr_on, size: 16, color: AppTheme.secondaryTerracotta),
                            const SizedBox(width: 4),
                            Text(
                              '4K SPATIAL',
                              style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryEmerald),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [BoxShadow(color: Color(0x0A112D23), blurRadius: 8, offset: Offset(0, 2))],
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Search monasteries, murals, prayer halls...',
                        hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppTheme.textMuted),
                        border: InputBorder.none,
                        icon: const Icon(Icons.search, color: AppTheme.textMuted),
                        suffixIcon: const Icon(Icons.tune, color: AppTheme.primaryEmerald, size: 20),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Category Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All Tours', Icons.grid_view),
                        _buildFilterChip('Prayer Halls', Icons.temple_buddhist),
                        _buildFilterChip('Sacred Murals', Icons.palette),
                        _buildFilterChip('Aerial Overflights', Icons.paragliding),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Virtual Tours Feed List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final monastery = filtered[index];
                  final hasAltitudeRisk = (user?.hasHealthRisk ?? false) && monastery.isHighAltitude;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [BoxShadow(color: Color(0x0F112D23), blurRadius: 16, offset: Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Media Frame with 360 Overlay
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              child: SizedBox(
                                height: 210,
                                width: double.infinity,
                                child: monastery.imageUrl.startsWith('assets/')
                                    ? Image.asset(monastery.imageUrl, fit: BoxFit.cover)
                                    : Image.network(monastery.imageUrl, fit: BoxFit.cover),
                              ),
                            ),
                            Container(
                              height: 210,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Color(0xD0112D23)],
                                ),
                              ),
                            ),

                            // Top Badges
                            Positioned(
                              top: 12,
                              left: 12,
                              right: 12,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.secondarySaffron,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.sync, size: 12, color: Colors.white),
                                        const SizedBox(width: 4),
                                        Text('360° AR ACTIVE', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  if (hasAltitudeRisk)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppTheme.accentAmber,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.warning, size: 12, color: Colors.white),
                                          const SizedBox(width: 4),
                                          Text('Alt ${monastery.altitude} • Caution', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Play Button Trigger
                            Positioned.fill(
                              child: Center(
                                child: GestureDetector(
                                  onTap: () => _launchTour(context, monastery),
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.85),
                                      shape: BoxShape.circle,
                                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                                    ),
                                    child: const Icon(Icons.play_arrow, size: 32, color: AppTheme.primaryEmerald),
                                  ),
                                ),
                              ),
                            ),

                            // Bottom Info Overlay inside media
                            Positioned(
                              bottom: 12,
                              left: 14,
                              right: 14,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${monastery.locationName} • ${monastery.orderSect}',
                                          style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.secondarySaffron),
                                        ),
                                        Text(
                                          monastery.name,
                                          style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                                    child: Text(monastery.altitude, style: GoogleFonts.outfit(fontSize: 10, color: Colors.white)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Card Footer & Functional Action Buttons
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.schedule, size: 16, color: AppTheme.secondaryTerracotta),
                                      const SizedBox(width: 4),
                                      Text('12 min immersive tour', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textMuted)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.record_voice_over, size: 16, color: AppTheme.tertiarySage),
                                      const SizedBox(width: 4),
                                      Text('Lama Norbu Audio Guide', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textMuted)),
                                    ],
                                  ),
                                ],
                              ),

                              if (hasAltitudeRisk) ...[
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: AppTheme.monasteryCrimson),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.warning_amber_rounded, color: AppTheme.monasteryCrimson, size: 18),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '⚠️ High Altitude Warning (${monastery.altitude}): Profile flags respiratory/cardiac risk. Use spatial tour for remote darshan.',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.monasteryCrimson,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _launchTour(context, monastery),
                                      icon: const Icon(Icons.view_in_ar, size: 18),
                                      label: const Text('Launch AR Portal'),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('📥 Downloaded 142 MB 360° tour for ${monastery.name} offline use!'),
                                          backgroundColor: AppTheme.tertiarySage,
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      shape: const StadiumBorder(),
                                    ),
                                    icon: const Icon(Icons.download_for_offline, size: 18, color: AppTheme.primaryEmerald),
                                    label: Text('142 MB', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryEmerald)),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        avatar: Icon(icon, size: 15, color: isSelected ? Colors.white : AppTheme.secondaryTerracotta),
        label: Text(label),
        selected: isSelected,
        selectedColor: AppTheme.primaryEmerald,
        labelStyle: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppTheme.textOnSurface),
        onSelected: (_) => setState(() => _selectedFilter = label),
      ),
    );
  }

  void _launchTour(BuildContext context, dynamic monastery) {
    if (monastery.panoramaUrls.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PanoramaViewerScreen(
            monasteryName: monastery.name,
            panoramaUrl: monastery.panoramaUrls.first,
          ),
        ),
      );
    }
  }
}
