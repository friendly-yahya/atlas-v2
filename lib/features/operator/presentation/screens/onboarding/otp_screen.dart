// Screen 4/5: "Verify your number" — REAL OTP
// 6-digit boxes, auto-focus, paste support, resend timer

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:atlas_paragliding_v2/app/router/app_routes.dart';
import 'package:atlas_paragliding_v2/core/network/supabase_provider.dart';
import '../../widgets/onboarding/onboarding_progress_bar.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String? phone;
  const OtpScreen({super.key, this.phone});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isVerifying = false;
  int _resendSeconds = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendSeconds = 30;
    });
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _resendSeconds--);
      if (_resendSeconds <= 0) {
        setState(() => _canResend = true);
        return false;
      }
      return true;
    });
  }

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (index == 5 && value.isNotEmpty) {
      _verify();
    }
  }

  Future<void> _onPaste(String value) async {
    final clean = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.length == 6) {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = clean[i];
      }
      _focusNodes[5].requestFocus();
      _verify();
    }
  }

  Future<void> _verify() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length != 6) return;

    setState(() => _isVerifying = true);

    try {
      await ref.read(supabaseClientProvider).auth.verifyOTP(
            phone: widget.phone,
            token: code,
            type: OtpType.sms,
          );

      // Mark phone as verified in profile
      final user = ref.read(supabaseClientProvider).auth.currentUser;
      if (user != null) {
        await ref.read(supabaseClientProvider)
            .from('operator_profile')
            .update({'phone_verified': true})
            .eq('user_id', user.id);
      }

      if (mounted) context.go(AppRoutes.operatorHome);
    } on AuthException catch (e) {
      if (mounted) {
        _shakeBoxes();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  void _shakeBoxes() {
    // Simple visual feedback — boxes shake via a brief animation
    // In production, wrap in AnimatedBuilder for proper shake
    for (final node in _focusNodes) {
      node.unfocus();
    }
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _focusNodes[0].requestFocus();
    });
  }

  Future<void> _resend() async {
    if (!_canResend || widget.phone == null) return;
    try {
      await ref.read(supabaseClientProvider).auth.signInWithOtp(phone: widget.phone!);
      _startResendTimer();
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
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
              const OnboardingProgressBar(currentStep: 4, totalSteps: 5),
              const SizedBox(height: 24),
              Text(
                'Verify your number',
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the 6-digit code we sent to your phone.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // Sent-to info
              Text(
                'Code sent to ${widget.phone ?? 'your phone'}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    width: 44,
                    height: 52,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (v) => _onDigitChanged(index, v),
                      onTap: () {
                        // Select all on tap for easy replacement
                        _controllers[index].selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: _controllers[index].text.length,
                        );
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Resend
              Center(
                child: TextButton(
                  onPressed: _canResend ? _resend : null,
                  child: Text(
                    _canResend
                        ? 'Resend code'
                        : 'Resend in ${_resendSeconds}s',
                  ),
                ),
              ),
              const Spacer(),

              // Verify button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isVerifying ? null : _verify,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _isVerifying
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Verify'),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.onboardingPhone),
                  child: const Text('Use a different number'),
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