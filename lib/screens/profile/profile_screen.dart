import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../config/app_theme.dart';
import '../../services/firestore_service.dart';
import '../auth/sign_up_modal.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showHealthVitalsModal(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.user;
    bool asthma = user?.hasAsthma ?? false;
    bool heart = user?.hasHeartCondition ?? false;
    bool altitudeSensitivity = user?.hasAltitudeSensitivity ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.health_and_safety, color: AppTheme.secondaryTerracotta),
                          const SizedBox(width: 8),
                          Text(
                            'Update Health Vitals Profile',
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
                  const SizedBox(height: 8),
                  Text(
                    'Your health profile is shared with Monk AI for personalized high-altitude travel advisories.',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    activeColor: AppTheme.secondaryTerracotta,
                    title: Text('Respiratory / Asthma Condition', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                    subtitle: Text('Triggers high-altitude inhaler reminders at Pemayangtse (2085m)', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                    value: asthma,
                    onChanged: (val) => setModalState(() => asthma = val),
                  ),
                  SwitchListTile(
                    activeColor: AppTheme.secondaryTerracotta,
                    title: Text('Cardiac Rhythm Risk / History', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                    subtitle: Text('Recommends low-strain sanctuary trails', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                    value: heart,
                    onChanged: (val) => setModalState(() => heart = val),
                  ),
                  SwitchListTile(
                    activeColor: AppTheme.secondaryTerracotta,
                    title: Text('AMS (Acute Mountain Sickness) Sensitivity', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                    subtitle: Text('Alerts when ascending > 1800m', style: GoogleFonts.plusJakartaSans(fontSize: 11)),
                    value: altitudeSensitivity,
                    onChanged: (val) => setModalState(() => altitudeSensitivity = val),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await authProvider.updateHealthProfile(
                          hasAsthma: asthma,
                          hasHeartCondition: heart,
                          hasAltitudeSensitivity: altitudeSensitivity,
                        );
                        if (context.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('✅ Health Profile updated & synced with Monk AI!'),
                              backgroundColor: AppTheme.primaryEmerald,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: Text('Save Health Profile to Cloud', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: AppTheme.surfaceCanvas,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Sanctuary Header Banner in Alpine Emerald
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 32, left: 24, right: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.primaryEmerald,
                    Color(0xFF1E3F33),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Traveler Profile',
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryTerracotta,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'Sikkim Explorer',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Avatar & Identity Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppTheme.secondaryTerracotta,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: AppTheme.surfaceCanvas,
                            child: Text(
                              user?.displayName.isNotEmpty ?? false
                                  ? user!.displayName[0].toUpperCase()
                                  : 'G',
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryEmerald,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.displayName ?? 'Guest Traveler',
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryEmerald,
                                ),
                              ),
                              Text(
                                user?.email ?? 'No active session (Logged Out)',
                                style: GoogleFonts.plusJakartaSans(color: Colors.grey[600], fontSize: 12),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: authProvider.isLocal
                                      ? AppTheme.secondaryTerracotta
                                      : AppTheme.tertiarySage,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  authProvider.isLocal ? 'ROLE: LOCAL HOST' : 'ROLE: TOURIST',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.tune, color: AppTheme.secondaryTerracotta),
                          onPressed: () => _showHealthVitalsModal(context, authProvider),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Statistics Row (Visited, Tours, Badges)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard(
                    icon: Icons.temple_buddhist,
                    count: '${user?.visitedCount ?? 4}',
                    label: 'Sanctuaries',
                  ),
                  _buildStatCard(
                    icon: Icons.view_in_ar,
                    count: '${user?.toursCompleted ?? 2}',
                    label: '360° Tours',
                  ),
                  _buildStatCard(
                    icon: Icons.stars,
                    count: '${user?.badgesCount ?? 3}',
                    label: 'Pilgrim Badges',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // High Altitude Health Profile Status Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (user?.hasHealthRisk ?? false)
                      ? AppTheme.secondaryTerracotta
                      : AppTheme.tertiarySage.withOpacity(0.5),
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            (user?.hasHealthRisk ?? false)
                                ? Icons.warning_amber_rounded
                                : Icons.verified_user_outlined,
                            color: (user?.hasHealthRisk ?? false)
                                ? AppTheme.secondaryTerracotta
                                : AppTheme.tertiarySage,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            (user?.hasHealthRisk ?? false)
                                ? 'High Altitude Vitals (Risk Flagged)'
                                : 'High Altitude Vitals (Cleared)',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: (user?.hasHealthRisk ?? false)
                                  ? AppTheme.monasteryCrimson
                                  : AppTheme.primaryEmerald,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _showHealthVitalsModal(context, authProvider),
                        child: Text(
                          'Edit',
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppTheme.secondaryTerracotta,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      Chip(
                        avatar: Icon(
                          Icons.air,
                          size: 14,
                          color: (user?.hasAsthma ?? false) ? AppTheme.monasteryCrimson : AppTheme.tertiarySage,
                        ),
                        label: Text(
                          'Asthma: ${(user?.hasAsthma ?? false) ? 'Active' : 'None'}',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11),
                        ),
                        backgroundColor: AppTheme.surfaceCanvas,
                      ),
                      Chip(
                        avatar: Icon(
                          Icons.favorite,
                          size: 14,
                          color: (user?.hasHeartCondition ?? false) ? AppTheme.monasteryCrimson : AppTheme.tertiarySage,
                        ),
                        label: Text(
                          'Heart Risk: ${(user?.hasHeartCondition ?? false) ? 'Yes' : 'Normal'}',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11),
                        ),
                        backgroundColor: AppTheme.surfaceCanvas,
                      ),
                      Chip(
                        avatar: Icon(
                          Icons.terrain,
                          size: 14,
                          color: (user?.hasAltitudeSensitivity ?? false) ? AppTheme.monasteryCrimson : AppTheme.tertiarySage,
                        ),
                        label: Text(
                          'AMS History: ${(user?.hasAltitudeSensitivity ?? false) ? 'Yes' : 'No'}',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11),
                        ),
                        backgroundColor: AppTheme.surfaceCanvas,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Permanent Account Role Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryEmerald.withOpacity(0.06),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primaryEmerald.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppTheme.primaryEmerald, size: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PERMANENT ROLE: ${user?.role.name.toUpperCase() ?? 'TOURIST'}',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppTheme.primaryEmerald,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.isLocal ?? false
                              ? 'Registered as Local Host & Monastery Event Organizer.'
                              : 'Registered as Heritage Tourist & Sacred Circuit Traveler.',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Account & System Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sanctuary Settings & Data',
                    style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryEmerald),
                  ),
                  const SizedBox(height: 12),
                  _buildSettingTile(
                    icon: Icons.person_add_alt_1_outlined,
                    title: 'Register New Permanent Account',
                    subtitle: 'Create dual tourist / local host credentials',
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const SignUpModal(),
                      );
                    },
                  ),
                  _buildSettingTile(
                    icon: Icons.cloud_upload_outlined,
                    title: 'Sync & Seed Cloud Firestore',
                    subtitle: 'Populate monasteries, events & manuscripts',
                    onTap: () async {
                      final firestoreService = FirestoreService();
                      await firestoreService.seedInitialFirestoreData();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('🎉 Cloud Firestore Populated! Monasteries, Events & Manuscripts synced.', style: GoogleFonts.plusJakartaSans()),
                            backgroundColor: AppTheme.primaryEmerald,
                          ),
                        );
                      }
                    },
                  ),
                  _buildSettingTile(
                    icon: Icons.logout,
                    title: 'Log Out',
                    subtitle: 'Sign out of current active session',
                    onTap: () async {
                      await authProvider.signOut();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('👋 Logged out successfully.', style: GoogleFonts.plusJakartaSans()),
                            backgroundColor: AppTheme.monasteryCrimson,
                          ),
                        );
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const SignUpModal(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String count,
    required String label,
  }) {
    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.secondaryTerracotta, size: 24),
          const SizedBox(height: 6),
          Text(
            count,
            style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryEmerald),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(color: Colors.grey[600], fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryEmerald.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryEmerald, size: 20),
        ),
        title: Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey[600])),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: onTap,
      ),
    );
  }
}

