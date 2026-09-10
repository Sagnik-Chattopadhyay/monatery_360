import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../config/app_theme.dart';

class AuthOnboardingScreen extends StatefulWidget {
  const AuthOnboardingScreen({super.key});

  @override
  State<AuthOnboardingScreen> createState() => _AuthOnboardingScreenState();
}

class _AuthOnboardingScreenState extends State<AuthOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _monasteryController = TextEditingController(text: 'Rumtek Monastery');

  UserRole _selectedRole = UserRole.tourist;
  bool _hasAsthma = false;
  bool _hasHeartCondition = false;
  bool _hasAltitudeSensitivity = false;
  bool _isLoginMode = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Monastery 360 Branding & Header
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.accentAmber.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.temple_buddhist_rounded,
                        size: 54,
                        color: AppTheme.primaryOrange,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Monastery 360',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Virtual Tours, Cultural Events & Sacred Heritage of Sikkim',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Form Title & Mode Switcher
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isLoginMode ? 'Sign In to Your Account' : 'Sign Up Required to Begin',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => setState(() => _isLoginMode = !_isLoginMode),
                    child: Text(
                      _isLoginMode ? 'Need to Sign Up?' : 'Existing User?',
                      style: const TextStyle(color: AppTheme.primaryOrange, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_isLoginMode) ...[
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person, color: AppTheme.primaryOrange),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Please enter your name' : null,
                      ),
                      const SizedBox(height: 14),
                    ],

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email, color: AppTheme.primaryOrange),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v == null || !v.contains('@') ? 'Please enter a valid email' : null,
                    ),

                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock, color: AppTheme.primaryOrange),
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => v == null || v.length < 4 ? 'Password required' : null,
                    ),

                    if (!_isLoginMode) ...[
                      const SizedBox(height: 20),

                      // Permanent Role Picker Section
                      const Text(
                        'Select Account Role (Locked Permanently Upon Sign Up):',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.monasteryCrimson),
                      ),
                      const SizedBox(height: 8),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            RadioListTile<UserRole>(
                              title: const Text('Tourist / Pilgrim', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              subtitle: const Text('Explore 360° tours, book events, receive altitude health alerts.'),
                              value: UserRole.tourist,
                              groupValue: _selectedRole,
                              activeColor: AppTheme.primaryOrange,
                              onChanged: (val) => setState(() => _selectedRole = val!),
                            ),
                            const Divider(height: 1),
                            RadioListTile<UserRole>(
                              title: const Text('Local Host / Monk Representative', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              subtitle: const Text('Publish cultural events, host tours, represent monastery.'),
                              value: UserRole.local,
                              groupValue: _selectedRole,
                              activeColor: AppTheme.monasteryCrimson,
                              onChanged: (val) => setState(() => _selectedRole = val!),
                            ),
                          ],
                        ),
                      ),

                      if (_selectedRole == UserRole.local) ...[
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _monasteryController,
                          decoration: const InputDecoration(
                            labelText: 'Monastery Affiliation',
                            hintText: 'e.g., Rumtek Monastery',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // High Altitude Health Profile Questionnaire
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.accentAmber),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.health_and_safety, color: AppTheme.primaryOrange),
                                SizedBox(width: 8),
                                Text(
                                  'High-Altitude Health Profile',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Sikkim monasteries reach up to 2,085m altitude. Please declare any health conditions for safety alerts.',
                              style: TextStyle(fontSize: 11, color: Colors.black87),
                            ),
                            const SizedBox(height: 8),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Asthma / Respiratory Conditions', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              value: _hasAsthma,
                              activeColor: AppTheme.primaryOrange,
                              onChanged: (val) => setState(() => _hasAsthma = val ?? false),
                            ),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Heart / Cardiovascular Conditions', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              value: _hasHeartCondition,
                              activeColor: AppTheme.primaryOrange,
                              onChanged: (val) => setState(() => _hasHeartCondition = val ?? false),
                            ),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('History of High-Altitude Sickness (AMS)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              value: _hasAltitudeSensitivity,
                              activeColor: AppTheme.primaryOrange,
                              onChanged: (val) => setState(() => _hasAltitudeSensitivity = val ?? false),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppTheme.primaryOrange,
                        ),
                        onPressed: authProvider.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  if (_isLoginMode) {
                                    final success = await authProvider.login(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                    if (success && mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('🎉 Welcome Back! Session Active.')),
                                      );
                                    } else if (!success && mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(authProvider.errorMessage ?? 'Account not found. Please Sign Up first.'),
                                          backgroundColor: Colors.red.shade700,
                                        ),
                                      );
                                    }
                                  } else {
                                    final success = await authProvider.signUp(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      displayName: _nameController.text,
                                      role: _selectedRole,
                                      monasteryAffiliation: _selectedRole == UserRole.local ? _monasteryController.text : null,
                                      hasAsthma: _hasAsthma,
                                      hasHeartCondition: _hasHeartCondition,
                                      hasAltitudeSensitivity: _hasAltitudeSensitivity,
                                    );
                                    if (success && mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('🎉 Registration Successful as ${_selectedRole.name.toUpperCase()}!'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } else if (!success && mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(authProvider.errorMessage ?? 'Registration failed.'),
                                          backgroundColor: Colors.red.shade700,
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                        icon: authProvider.isLoading
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.arrow_forward_rounded),
                        label: Text(
                          _isLoginMode ? 'Sign In & Launch App' : 'Complete Registration & Enter App',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
