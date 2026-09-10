import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../config/app_theme.dart';

class SignUpModal extends StatefulWidget {
  const SignUpModal({super.key});

  @override
  State<SignUpModal> createState() => _SignUpModalState();
}

class _SignUpModalState extends State<SignUpModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _monasteryController = TextEditingController(text: 'Rumtek Monastery');

  UserRole _selectedRole = UserRole.tourist;
  bool _hasAsthma = false;
  bool _hasHeartCondition = false;
  bool _hasAltitudeSensitivity = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Create Permanent Account',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Account Basics
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person, color: AppTheme.primaryOrange),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 12),

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
              const SizedBox(height: 12),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: AppTheme.primaryOrange),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.length < 6 ? 'Password must be 6+ chars' : null,
              ),

              const SizedBox(height: 20),

              // Permanent Role Selector Section
              const Text(
                'Account Role (Permanent - Cannot change later)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.monasteryCrimson),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    RadioListTile<UserRole>(
                      title: const Text('Tourist / Pilgrim', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Explore 360° virtual tours, book events, receive altitude safety alerts.'),
                      value: UserRole.tourist,
                      groupValue: _selectedRole,
                      activeColor: AppTheme.primaryOrange,
                      onChanged: (val) => setState(() => _selectedRole = val!),
                    ),
                    const Divider(),
                    RadioListTile<UserRole>(
                      title: const Text('Local Host / Monk Representative', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text('Publish monastery events, guide visitors, host cultural experiences.'),
                      value: UserRole.local,
                      groupValue: _selectedRole,
                      activeColor: AppTheme.monasteryCrimson,
                      onChanged: (val) => setState(() => _selectedRole = val!),
                    ),
                  ],
                ),
              ),

              if (_selectedRole == UserRole.local) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _monasteryController,
                  decoration: const InputDecoration(
                    labelText: 'Monastery Affiliation Name',
                    hintText: 'e.g., Rumtek Monastery',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // High-Altitude Health Profile Questionnaire
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
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Sikkim monasteries range up to 2,085m+ in altitude. Help us tailor health warnings for your safety.',
                      style: TextStyle(fontSize: 11, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Asthma / Respiratory Sensitivity', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      value: _hasAsthma,
                      activeColor: AppTheme.primaryOrange,
                      onChanged: (val) => setState(() => _hasAsthma = val ?? false),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Heart / Cardiovascular Condition', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      value: _hasHeartCondition,
                      activeColor: AppTheme.primaryOrange,
                      onChanged: (val) => setState(() => _hasHeartCondition = val ?? false),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('History of High-Altitude Sickness (AMS)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      value: _hasAltitudeSensitivity,
                      activeColor: AppTheme.primaryOrange,
                      onChanged: (val) => setState(() => _hasAltitudeSensitivity = val ?? false),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppTheme.primaryOrange,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
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
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '🎉 Welcome ${_nameController.text}! Account created as ${_selectedRole.name.toUpperCase()} (Role is permanent).',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Complete Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
