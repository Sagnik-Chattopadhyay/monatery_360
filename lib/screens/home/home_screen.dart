import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../providers/monastery_provider.dart';
import '../../config/app_theme.dart';
import '../calendar/cultural_calendar_screen.dart';
import '../archives/digital_archives_screen.dart';
import '../tourism/tourism_services_screen.dart';
import '../tours/panorama_viewer_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final monasteryProvider = Provider.of<MonasteryProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppTheme.surfaceCanvas,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Bar with Sikkim Sanctuary Emblem & Telemetry
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryEmerald,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.temple_buddhist, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sikkim Sanctuary',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryEmerald,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              'Home',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.cardLow,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.landscape, size: 14, color: AppTheme.secondaryTerracotta),
                              const SizedBox(width: 4),
                              Text(
                                'Gangtok • 1,650m',
                                style: GoogleFonts.outfit(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryEmerald,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('LoggedIn as ${user?.displayName ?? 'Traveler'}'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: AppTheme.primaryEmerald.withOpacity(0.1),
                            child: const Icon(Icons.person, color: AppTheme.primaryEmerald, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // 2. Greeting & Ambient Telemetry Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTheme.secondarySaffron,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Dharmachakra Season',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.secondaryTerracotta,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tashi Delek, ${user?.displayName?.split(' ').first ?? 'Traveler'}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryEmerald,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Breathe easy in the Eastern Himalayas',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'ATMOSPHERIC',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textMuted,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.cardLow,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.air, size: 14, color: AppTheme.tertiarySage),
                              const SizedBox(width: 4),
                              Text(
                                '842 hPa',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryEmerald,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 3. High-Altitude Acclimatization Health Watch Widget
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0F112D23),
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: const Color(0x15112D23)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppTheme.secondarySaffron.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.monitor_heart, color: AppTheme.secondaryTerracotta, size: 18),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Elevation Health Advisory',
                                        style: GoogleFonts.outfit(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryEmerald,
                                        ),
                                      ),
                                      Text(
                                        user?.hasHealthRisk ?? false
                                            ? 'Profile watch: Active respiratory / altitude sensitivity'
                                            : 'Profile watch: Normal acclimatization baseline',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          color: AppTheme.textMuted,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => _showEmergencyHotlineModal(context),
                            icon: const Icon(Icons.phone_in_talk, color: AppTheme.secondaryTerracotta, size: 20),
                            style: IconButton.styleFrom(
                              backgroundColor: AppTheme.cardLow,
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Gauge Visual Meter
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Base 1,200m', style: GoogleFonts.outfit(fontSize: 10, color: AppTheme.textMuted)),
                          Text('Caution 1,500m+', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.secondaryTerracotta)),
                          Text('Summit 3,800m', style: GoogleFonts.outfit(fontSize: 10, color: AppTheme.textMuted)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 8,
                          child: Row(
                            children: [
                              Expanded(flex: 40, child: Container(color: AppTheme.tertiarySage)),
                              Expanded(flex: 25, child: Container(color: AppTheme.secondarySaffron)),
                              Expanded(flex: 35, child: Container(color: AppTheme.accentAmber.withOpacity(0.5))),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryTerracotta.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.warning, size: 12, color: AppTheme.secondaryTerracotta),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Oxygen Advisory >1,500m',
                                    style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.secondaryTerracotta),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.cardLow,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.local_drink, size: 12, color: AppTheme.tertiarySage),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Hydrate 3.5L Daily',
                                    style: GoogleFonts.outfit(fontSize: 11, color: AppTheme.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            TextButton.icon(
                              onPressed: () => _showProtocolModal(context),
                              iconAlignment: IconAlignment.end,
                              icon: const Icon(Icons.chevron_right, size: 16, color: AppTheme.secondaryTerracotta),
                              label: Text(
                                'Protocol',
                                style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.secondaryTerracotta),
                              ),
                              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 4. Tactile Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(color: Color(0x0A112D23), blurRadius: 10, offset: Offset(0, 2)),
                    ],
                  ),
                  child: TextField(
                    onChanged: (val) => monasteryProvider.setSearchQuery(val),
                    decoration: InputDecoration(
                      hintText: 'Search monasteries, gompas, high trails...',
                      hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppTheme.textMuted),
                      border: InputBorder.none,
                      icon: const Icon(Icons.search, color: AppTheme.primaryEmerald),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.tune, color: AppTheme.primaryEmerald, size: 20),
                        onPressed: () => _showFilterSheet(context, monasteryProvider),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 5. Sanctuary Modules Carousel
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sanctuary Modules',
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryEmerald),
                    ),
                    Text(
                      'Live feeds',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildModuleTile(
                      context,
                      title: 'Cultural Rites',
                      subtitle: 'Bumchu & Cham dance',
                      tag: 'Next: 3d',
                      icon: Icons.calendar_month,
                      iconBg: AppTheme.secondarySaffron.withOpacity(0.2),
                      iconColor: AppTheme.secondaryTerracotta,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CulturalCalendarScreen())),
                    ),
                    const SizedBox(width: 12),
                    _buildModuleTile(
                      context,
                      title: 'Manuscripts',
                      subtitle: '320 Sacred xylographs',
                      tag: 'Kangyur',
                      icon: Icons.menu_book,
                      iconBg: AppTheme.tertiarySage.withOpacity(0.15),
                      iconColor: AppTheme.tertiarySage,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DigitalArchivesScreen())),
                    ),
                    const SizedBox(width: 12),
                    _buildModuleTile(
                      context,
                      title: 'Transit Desk',
                      subtitle: 'Permits & 4x4 passes',
                      tag: '4x4 Fleet',
                      icon: Icons.directions_car,
                      iconBg: AppTheme.cardHigh,
                      iconColor: AppTheme.primaryEmerald,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TourismServicesScreen())),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 6. Category Pills Filter Strip
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildCategoryPill(context, 'All Sanctuaries', Icons.temple_buddhist),
                    _buildCategoryPill(context, 'Historic Gompas', Icons.history_edu),
                    _buildCategoryPill(context, 'Nyingma Order', Icons.flare),
                    _buildCategoryPill(context, 'Kagyu Lineage', Icons.all_inclusive),
                    _buildCategoryPill(context, 'Alpine Trails', Icons.hiking),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 7. Featured Sanctuaries Vertical Cards Stack
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Featured Sanctuaries',
                            style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryEmerald),
                          ),
                          Text(
                            'Sacred architectural monuments open for darshan',
                            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => monasteryProvider.setCategoryFilter('All Sanctuaries'),
                      icon: const Icon(Icons.arrow_forward, size: 14, color: AppTheme.secondaryTerracotta),
                      label: Text(
                        'Explore all (${monasteryProvider.monasteries.length})',
                        style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.secondaryTerracotta),
                      ),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    ),
                  ],
                ),
              ),


              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: monasteryProvider.monasteries.length,
                itemBuilder: (context, index) {
                  final item = monasteryProvider.monasteries[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildSanctuaryCard(context, item, user?.hasHealthRisk ?? false),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showEmergencyHotlineModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.phone_in_talk, color: AppTheme.monasteryCrimson, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'Sikkim High-Altitude Emergency Hotline',
                    style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryEmerald),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Instant access to Sikkim Disaster Management & High-Altitude Rescue Medical Units.',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.monasteryCrimson.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.emergency, color: AppTheme.monasteryCrimson),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Medical Evacuation Rescue', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                          Text('+91 3592 202011 • 24/7 Helpline', style: GoogleFonts.outfit(color: AppTheme.monasteryCrimson, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.monasteryCrimson),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('📞 Dialing Sikkim High-Altitude Medical Emergency Hotline...')),
                        );
                      },
                      child: const Text('Call Now'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showProtocolModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.health_and_safety, color: AppTheme.secondaryTerracotta, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'High Altitude Safety Protocol',
                    style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryEmerald),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '1. Ascend slowly (max 500m elevation gain per day above 2,000m).\n'
                '2. Drink 3.5L of water daily to prevent dehydration.\n'
                '3. Avoid alcohol or heavy exertion during the first 24 hours.\n'
                '4. If experiencing dizziness or severe headache, descend immediately.',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, height: 1.5, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Understood'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterSheet(BuildContext context, MonasteryProvider monasteryProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Sanctuaries by Sect',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryEmerald),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: ['All Sanctuaries', 'Nyingma Order', 'Kagyu Lineage', 'Historic Gompas', 'Alpine Trails'].map((cat) {
                  return ChoiceChip(
                    label: Text(cat),
                    selected: monasteryProvider.selectedCategory == cat,
                    onSelected: (_) {
                      monasteryProvider.setCategoryFilter(cat);
                      Navigator.pop(ctx);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModuleTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String tag,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Color(0x0A112D23), blurRadius: 10, offset: Offset(0, 3)),
          ],
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppTheme.surfaceCanvas, borderRadius: BorderRadius.circular(10)),
                  child: Text(tag, style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryEmerald)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(title, style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.primaryEmerald)),
            const SizedBox(height: 2),
            Text(subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppTheme.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPill(BuildContext context, String category, IconData icon) {
    final monasteryProvider = Provider.of<MonasteryProvider>(context);
    final isActive = monasteryProvider.selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isActive,
        avatar: Icon(icon, size: 16, color: isActive ? Colors.white : AppTheme.primaryEmerald),
        label: Text(category),
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
          color: isActive ? Colors.white : AppTheme.primaryEmerald,
        ),
        backgroundColor: Colors.white,
        selectedColor: AppTheme.secondaryTerracotta,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onSelected: (_) => monasteryProvider.setCategoryFilter(category),
      ),
    );
  }

  Widget _buildSanctuaryCard(BuildContext context, dynamic item, bool hasHealthRisk) {
    final showAltitudeWarning = item.isHighAltitude && hasHealthRisk;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Color(0x0C112D23), blurRadius: 14, offset: Offset(0, 4)),
        ],
        border: showAltitudeWarning 
            ? Border.all(color: AppTheme.monasteryCrimson, width: 1.5)
            : Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: item.imageUrl.startsWith('assets/')
                    ? Image.asset(item.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover)
                    : Image.network(item.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
              ),
              if (showAltitudeWarning)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.monasteryCrimson,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 4)],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.warning, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          'HIGH ALTITUDE RISK (${item.altitude})',
                          style: GoogleFonts.outfit(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryEmerald.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    item.altitude,
                    style: GoogleFonts.outfit(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.name, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryEmerald)),
                    Text(item.era, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.textMuted)),
                  ],
                ),
                const SizedBox(height: 4),
                Text('${item.locationName} • ${item.orderSect}', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppTheme.secondaryTerracotta)),
                const SizedBox(height: 8),
                Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.grey[700])),
                
                const SizedBox(height: 12),

                // Prominent High Altitude Health Warning Banner inside Feed Card
                if (showAltitudeWarning) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.monasteryCrimson, width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: AppTheme.monasteryCrimson, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '⚠️ HIGH-ALTITUDE HEALTH ADVISORY (${item.altitude})',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.monasteryCrimson,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Your health profile flags altitude / respiratory sensitivity (Asthma, Heart or AMS risk). Acclimatize thoroughly and carry oxygen / prescribed inhalers before visiting ${item.name}.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: Colors.red.shade900,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.monasteryCrimson,
                                  side: const BorderSide(color: AppTheme.monasteryCrimson),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                onPressed: () => _showEmergencyHotlineModal(context),
                                icon: const Icon(Icons.medical_services_outlined, size: 16),
                                label: Text('Medical Emergency Rescue', style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (item.panoramaUrls.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PanoramaViewerScreen(
                                  monasteryName: item.name,
                                  panoramaUrl: item.panoramaUrls.first,
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.threed_rotation),
                        label: Text('Launch 360° AR Portal', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


