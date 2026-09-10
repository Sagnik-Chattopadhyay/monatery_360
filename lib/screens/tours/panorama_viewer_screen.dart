import 'package:flutter/material.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import '../../config/app_theme.dart';

import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class PanoramaViewerScreen extends StatelessWidget {
  final String monasteryName;
  final String panoramaUrl;

  const PanoramaViewerScreen({
    super.key,
    required this.monasteryName,
    required this.panoramaUrl,
  });

  String _resolvePanoramaAsset() {
    if (panoramaUrl.startsWith('assets/')) {
      return panoramaUrl;
    }
    final nameLower = monasteryName.toLowerCase();
    if (nameLower.contains('pemayangtse')) {
      return 'assets/panoramas/pemayangtse_360.jpg';
    } else if (nameLower.contains('enchey')) {
      return 'assets/panoramas/enchey_360.jpg';
    } else if (nameLower.contains('tashiding')) {
      return 'assets/panoramas/tashiding_360.jpg';
    } else if (nameLower.contains('rumtek')) {
      return 'assets/panoramas/rumtek_360.jpg';
    }
    return 'assets/panoramas/rumtek_360.jpg';
  }

  @override
  Widget build(BuildContext context) {
    final assetPath = _resolvePanoramaAsset();
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('360° Virtual Tour - $monasteryName'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(monasteryName),
                  content: const Text(
                    'Drag left, right, up, or down to explore the 360° interior shrine hall and surroundings. Pinch or scroll to zoom in and out.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Interactive 360° Panorama Viewer with AR Device Sensor Look-Around
          PanoramaViewer(
            sensorControl: SensorControl.orientation,
            child: Image.asset(
              assetPath,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/panoramas/rumtek_360.jpg');
              },
            ),
          ),

          // High Altitude Health Warning Banner (Top-Center)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: (user?.hasHealthRisk ?? false) ? Colors.orangeAccent : AppTheme.accentAmber,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    (user?.hasHealthRisk ?? false) ? Icons.warning_amber_rounded : Icons.terrain_outlined,
                    color: (user?.hasHealthRisk ?? false) ? Colors.orangeAccent : AppTheme.accentAmber,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      (user?.hasHealthRisk ?? false)
                          ? '⚠️ High Altitude Advisory: Take altitude breaks, stay hydrated, and carry oxygen if visiting in person.'
                          : '⛰️ High Altitude Heritage Zone: Altitude ranges up to 2,085m.',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Control Overlay Card
          Positioned(
            bottom: 24,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentAmber.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.threed_rotation, color: AppTheme.accentAmber, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          monasteryName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          '360° Interactive Panoramic Room View',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryOrange,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Exit 360°'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
