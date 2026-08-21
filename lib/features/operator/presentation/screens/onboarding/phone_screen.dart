// Screen 3/5: "Secure your account" — REAL PHONE INPUT
// Collects phone number, sends OTP via Supabase Auth

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:atlas_paragliding_v2/app/router/app_routes.dart';
import 'package:atlas_paragliding_v2/core/network/supabase_provider.dart';
import '../../widgets/onboarding/onboarding_progress_bar.dart';

class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  final _phoneController = TextEditingController();
  String _countryCode = '+212';
  bool _isSubmitting = false;

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final fullPhone = '$_countryCode $phone';
      await ref.read(supabaseClientProvider).auth.signInWithOtp(
            phone: fullPhone,
          );

      if (mounted) {
        context.go(AppRoutes.onboardingOtp, extra: fullPhone);
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const OnboardingProgressBar(currentStep: 3, totalSteps: 5),
              const SizedBox(height: 24),
              Text(
                'Secure your account',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'We send a quick code to keep your account safe. You\'ll also get booking alerts here.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // Phone input
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(10),
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🇲🇦', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Text(_countryCode, style: theme.textTheme.bodyLarge),
                        const Icon(Icons.keyboard_arrow_down, size: 18),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '6 66 77 89 90',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'We never share your number with travelers.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),

              // Continue
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSubmitting ? null : _sendOtp,
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
              const SizedBox(height: 8),

              // Skip
              Center(
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.operatorHome),
                  child: Text(
                    "I'll verify later",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}