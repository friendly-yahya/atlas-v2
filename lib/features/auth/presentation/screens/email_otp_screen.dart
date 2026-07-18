import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atlas_paragliding_v2/features/auth/presentation/notifiers/auth_controller.dart';


class EmailOtpScreen extends ConsumerStatefulWidget  {
  const EmailOtpScreen({super.key});

  @override
  ConsumerState<EmailOtpScreen> createState() => _EmailOtpScreenState();
}

class _EmailOtpScreenState extends ConsumerState<EmailOtpScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  bool _codeSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    return Scaffold(
      appBar: AppBar(title: const Text('Log in with a code')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_codeSent) ...[
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 24),
                if (authState.hasError)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      authState.error.toString(),
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                FilledButton(
                  onPressed: isLoading
                    ? null
                    : () async {
                      await ref
                        .read(authNotifierProvider.notifier).requestEmailOtp(_emailController.text.trim());
                      final stillHasError = ref.read(authNotifierProvider).hasError;
                      if (!stillHasError && mounted) {
                        setState(()=> _codeSent = true);
                      }
                    }, 
                  child: isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2,),
                    )
                    : const Text('Send code'),
                ),
              ] else ...[
                Text('Enter the code sent to ${_codeController.text.trim()}'),
                const SizedBox(height: 12,),
                TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Code'),
                ),
                const SizedBox(height: 24),
                if (authState.hasError)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      authState.error.toString(),
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                FilledButton(
                  onPressed: isLoading
                      ? null
                      : () => ref.read(authNotifierProvider.notifier).completeEmailOtpVerification(
                            _emailController.text.trim(),
                            _codeController.text.trim(),
                          ), 
                  child: isLoading
                    ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Verify'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: isLoading ? null : () => setState(() => _codeSent = false),
                  child: const Text('Use a different email'),
                ),
              ]
            ],
          ),
          ),
      ),
    );
  }
}