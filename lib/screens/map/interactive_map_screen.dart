import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/monastery_provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/app_theme.dart';
import '../../models/monastery_model.dart';
import '../tours/panorama_viewer_screen.dart';

class InteractiveMapScreen extends StatefulWidget {
  const InteractiveMapScreen({super.key});

  @override
  State<InteractiveMapScreen> createState() => _InteractiveMapScreenState();
}

class _InteractiveMapScreenState extends State<InteractiveMapScreen> {
  final MapController _mapController = MapController();
  
  String _selectedCircuit = 'Sacred Circuit'; // 'Sacred Circuit', 'Valley Trails', 'High Passes'
  bool _isSatelliteLayer = false;
  MonasteryModel? _selectedMonastery;

  final Map<String, LatLng> _circuitCenters = {
    'Sacred Circuit': const LatLng(27.25, 88.25), // West Sikkim (Pemayangtse, Tashiding)
    'Valley Trails': const LatLng(27.33, 88.60),  // East Sikkim (Rumtek, Enchey)
    'High Passes': const LatLng(27.60, 88.50),   // North Sikkim
  };

  void _onCircuitSelected(String circuit) {
    setState(() {
      _selectedCircuit = circuit;
    });
    final center = _circuitCenters[circuit] ?? const LatLng(27.33, 88.50);
    _mapController.move(center, 10.5);
  }

  void _toggleMapLayer() {
    setState(() {
      _isSatelliteLayer = !_isSatelliteLayer;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isSatelliteLayer 
              ? '🛰️ Switched to High-Resolution Satellite Terrain Layer' 
              : '🗺️ Switched to Sikkim Heritage Topographic Map Layer',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppTheme.primaryEmerald,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showElevationProfileSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.show_chart, color: AppTheme.secondaryTerracotta),
                      const SizedBox(width: 8),
                      Text(
                        'Circuit Elevation Profiles',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryEmerald,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Topographic elevation gradient of sacred Sikkim sanctuaries above sea level (m):',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),
              _buildElevationItem('Pemayangtse Gompa', 2085, 'West Sikkim • High Altitude Alert'),
              _buildElevationItem('Enchey Monastery', 1800, 'Gangtok Ridge • Moderate Altitude'),
              _buildElevationItem('Rumtek Monastery', 1500, 'East Sikkim • Acclimatized Entry'),
              _buildElevationItem('Tashiding Monastery', 1460, 'Heartland Ridge • Sacred Circuit'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Return to Interactive Map'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildElevationItem(String name, int meters, String tag) {
    final percent = (meters / 2500.0).clamp(0.1, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('$meters m', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppTheme.secondaryTerracotta)),
            ],
          ),
          const SizedBox(height: 4),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percent,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: meters > 2000 
                          ? [AppTheme.secondaryTerracotta, AppTheme.monasteryCrimson]
                          : [AppTheme.tertiarySage, AppTheme.primaryEmerald],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(tag, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey[600])),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final monasteryProvider = Provider.of<MonasteryProvider>(context);
    final monasteries = monasteryProvider.monasteries;

    return Scaffold(
      body: Stack(
        children: [
          // OpenStreetMap Tile Layer
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(27.33, 88.50),
              initialZoom: 9.8,
            ),
            children: [
              TileLayer(
                urlTemplate: _isSatelliteLayer
                    ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.monastery_360',
              ),
              MarkerLayer(
                markers: monasteries.map((m) {
                  final isSelected = _selectedMonastery?.id == m.id;
                  return Marker(
                    point: LatLng(m.latitude, m.longitude),
                    width: 110,
                    height: 70,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMonastery = m;
                        });
                        _mapController.move(LatLng(m.latitude, m.longitude), 11.5);
                        _showMonasteryBottomSheet(context, m);
                      },
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.secondaryTerracotta : AppTheme.primaryEmerald,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.temple_buddhist,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceCanvas,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 4),
                              ],
                            ),
                            child: Text(
                              m.name.split(' ').first,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryEmerald,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Top Circuit Selector Control Panel
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Header Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryEmerald.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryTerracotta.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.explore, color: AppTheme.secondaryTerracotta, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sacred Monastic Routes',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Interactive Geo-Spatial Waypoints • Sikkim',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '27.33° N',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Circuit Filter Pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Sacred Circuit', 'Valley Trails', 'High Passes'].map((circuit) {
                      final isActive = _selectedCircuit == circuit;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: isActive,
                          label: Text(circuit),
                          labelStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                            color: isActive ? Colors.white : AppTheme.primaryEmerald,
                          ),
                          backgroundColor: Colors.white.withOpacity(0.92),
                          selectedColor: AppTheme.secondaryTerracotta,
                          checkmarkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isActive ? AppTheme.secondaryTerracotta : Colors.transparent,
                            ),
                          ),
                          onSelected: (_) => _onCircuitSelected(circuit),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Floating Map Tools (Right Rail)
          Positioned(
            right: 16,
            top: 200,
            child: Column(
              children: [
                // Layer Toggle Button
                FloatingActionButton.small(
                  heroTag: 'map_layer_toggle_btn',
                  backgroundColor: Colors.white,
                  child: Icon(
                    _isSatelliteLayer ? Icons.map_outlined : Icons.satellite_alt_outlined,
                    color: AppTheme.primaryEmerald,
                  ),
                  onPressed: _toggleMapLayer,
                ),
                const SizedBox(height: 10),

                // Elevation Profile Sheet Button
                FloatingActionButton.small(
                  heroTag: 'elevation_profile_btn',
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.area_chart_outlined,
                    color: AppTheme.secondaryTerracotta,
                  ),
                  onPressed: _showElevationProfileSheet,
                ),
                const SizedBox(height: 10),

                // Recenter GPS Button
                FloatingActionButton.small(
                  heroTag: 'recenter_gps_btn',
                  backgroundColor: AppTheme.primaryEmerald,
                  child: const Icon(Icons.my_location, color: Colors.white),
                  onPressed: () {
                    _mapController.move(const LatLng(27.33, 88.50), 9.8);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Centered on Sikkim Heritage Region', style: GoogleFonts.plusJakartaSans()),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Bottom Horizontal Waypoint Preview Deck
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: monasteries.length,
                itemBuilder: (context, index) {
                  final m = monasteries[index];
                  final isSelected = _selectedMonastery?.id == m.id;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMonastery = m;
                      });
                      _mapController.move(LatLng(m.latitude, m.longitude), 11.5);
                      _showMonasteryBottomSheet(context, m);
                    },
                    child: Container(
                      width: 260,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppTheme.secondaryTerracotta : Colors.black12,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: m.imageUrl.startsWith('assets/')
                                ? Image.asset(m.imageUrl, width: 70, height: 90, fit: BoxFit.cover)
                                : Image.network(m.imageUrl, width: 70, height: 90, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  m.name,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryEmerald,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${m.locationName} • ${m.orderSect}',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppTheme.tertiarySage.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        m.altitude,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.tertiarySage,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        if (m.panoramaUrls.isNotEmpty) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => PanoramaViewerScreen(
                                                monasteryName: m.name,
                                                panoramaUrl: m.panoramaUrls.first,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: AppTheme.secondaryTerracotta,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.threed_rotation,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMonasteryBottomSheet(BuildContext context, MonasteryModel m) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: m.imageUrl.startsWith('assets/')
                        ? Image.asset(m.imageUrl, width: 85, height: 85, fit: BoxFit.cover)
                        : Image.network(m.imageUrl, width: 85, height: 85, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.name,
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryEmerald,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${m.era} • ${m.orderSect}',
                          style: GoogleFonts.plusJakartaSans(color: Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.height, size: 16, color: AppTheme.secondaryTerracotta),
                            const SizedBox(width: 4),
                            Text(
                              'Altitude: ${m.altitude}',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppTheme.secondaryTerracotta,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Health Advisory Warning Banner
              Builder(
                builder: (context) {
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  final user = authProvider.user;
                  if ((user?.hasHealthRisk ?? false) && m.isHighAltitude) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.monasteryCrimson),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: AppTheme.monasteryCrimson, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '⚠️ High Altitude Advisory (${m.altitude}): Medical profile flags risk. Acclimatize before ascending.',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.monasteryCrimson,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              Text(
                m.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(color: Colors.grey[800], fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('📍 Navigating from Gangtok to ${m.name} (Estimated drive: 2.5 hrs)'),
                            backgroundColor: AppTheme.primaryEmerald,
                          ),
                        );
                      },
                      icon: const Icon(Icons.directions, color: AppTheme.primaryEmerald),
                      label: Text('Directions', style: GoogleFonts.plusJakartaSans(color: AppTheme.primaryEmerald)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.primaryEmerald),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        if (m.panoramaUrls.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PanoramaViewerScreen(
                                monasteryName: m.name,
                                panoramaUrl: m.panoramaUrls.first,
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.threed_rotation),
                      label: Text('360° AR Portal', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

