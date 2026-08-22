// Screen 2/5: "Let us know you" — REAL FORM
// Writes to operator_profile (first_name, last_name, dob, country, city, region, postal)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:atlas_paragliding_v2/app/router/app_routes.dart';
import 'package:atlas_paragliding_v2/core/network/supabase_provider.dart';
import '../../widgets/onboarding/onboarding_progress_bar.dart';

class IdentityScreen extends ConsumerStatefulWidget {
  const IdentityScreen({super.key});

  @override
  ConsumerState<IdentityScreen> createState() => _IdentityScreenState();
}

class _IdentityScreenState extends ConsumerState<IdentityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _city = TextEditingController();
  final _region = TextEditingController();
  final _postal = TextEditingController();
  DateTime? _dob;
  String _country = 'Morocco';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _city.dispose();
    _region.dispose();
    _postal.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your date of birth')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = ref.read(supabaseClientProvider).auth.currentUser;
      if (user == null) throw Exception('Not authenticated');

      await ref.read(supabaseClientProvider).from('operator_profile').upsert({
        'user_id': user.id,
        'first_name': _firstName.text.trim(),
        'last_name': _lastName.text.trim(),
        'date_of_birth': _dob!.toIso8601String().split('T')[0],
        'country': _country,
        'city': _city.text.trim(),
        'region': _region.text.trim(),
        'postal_code': _postal.text.trim(),
      }, onConflict: 'user_id');

      if (mounted) context.go(AppRoutes.onboardingPhone);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _dob = picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const OnboardingProgressBar(currentStep: 2, totalSteps: 5),
                const SizedBox(height: 24),
                Text(
                  'Let us know you',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'We need this for identity verification later — it also helps travelers trust you more. Your profile can always show a custom name; this stays private.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: ListView(
                    children: [
                      // Date of birth
                      InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date of birth *',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            _dob == null
                                ? 'Select date'
                                : '${_dob!.year}-${_dob!.month.toString().padLeft(2, '0')}-${_dob!.day.toString().padLeft(2, '0')}',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // First name
                      TextFormField(
                        controller: _firstName,
                        decoration: InputDecoration(
                          labelText: 'First name (on ID) *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),

                      // Last name
                      TextFormField(
                        controller: _lastName,
                        decoration: InputDecoration(
                          labelText: 'Last name (on ID) *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),

                      // Country
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Country *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _country,
                            isDense: true,
                            onChanged: (v) => setState(() => _country = v!),
                            items: const [
                              DropdownMenuItem(value: 'Morocco', child: Text('Morocco')),
                              DropdownMenuItem(value: 'Other', child: Text('Other')),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // City
                      TextFormField(
                        controller: _city,
                        decoration: InputDecoration(
                          labelText: 'City *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),

                      // Region (optional)
                      TextFormField(
                        controller: _region,
                        decoration: InputDecoration(
                          labelText: 'Region / Prefecture',
                          hintText: 'Optional',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Postal (optional)
                      TextFormField(
                        controller: _postal,
                        decoration: InputDecoration(
                          labelText: 'ZIP / Postal code',
                          hintText: 'Optional',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _isSubmitting ? null : _submit,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Continue'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}