import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:atlas_paragliding_v2/features/auth/presentation/notifiers/auth_controller.dart';

class AuthEntryScreen extends ConsumerStatefulWidget {
  const AuthEntryScreen({super.key});

  @override
  ConsumerState<AuthEntryScreen> createState() => _AuthEntryScreenState();
}

class _AuthEntryScreenState extends ConsumerState<AuthEntryScreen> {
  final _identifierController = TextEditingController();
  final _codeController = TextEditingController();
  bool _codeSent = false;
  bool _isEmail = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final identifier = _identifierController.text.trim();
    _isEmail = identifier.contains('@');

    final notifier = ref.read(authNotifierProvider.notifier);
    if (_isEmail) {
      await notifier.requestEmailOtp(identifier);
    } else {
      await notifier.requestPhoneOtp(identifier);
    }

    final stillHasError = ref.read(authNotifierProvider).hasError;
    if (!stillHasError && mounted) {
      setState(() => _codeSent = true);
    }
  }

  Future<void> _verifyCode() async {
    final identifier = _identifierController.text.trim();
    final code = _codeController.text.trim();
    final notifier = ref.read(authNotifierProvider.notifier);

    if (_isEmail) {
      await notifier.completeEmailOtpVerification(identifier, code);
    } else {
      await notifier.completePhoneOtpVerification(identifier, code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Log in or sign up',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                if (!_codeSent) ...[
                  TextField(
                    controller: _identifierController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Phone number or email',
                      helperText: 'Phone must include country code, e.g. +212...',
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (authState.hasError)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        authState.error.toString(),
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isLoading ? null : _sendCode,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Continue'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('or'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : () => ref
                              .read(authNotifierProvider.notifier)
                              .loginWithOAuth(OAuthProvider.google),
                      child: const Text('Continue with Google'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : () => ref
                              .read(authNotifierProvider.notifier)
                              .loginWithOAuth(OAuthProvider.apple),
                      child: const Text('Continue with Apple'),
                    ),
                  ),
                ] else ...[
                  Text('Enter the code sent to ${_identifierController.text.trim()}'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Code'),
                  ),
                  const SizedBox(height: 16),
                  if (authState.hasError)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        authState.error.toString(),
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isLoading ? null : _verifyCode,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Verify'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: isLoading ? null : () => setState(() => _codeSent = false),
                    child: const Text('Use a different phone or email'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}