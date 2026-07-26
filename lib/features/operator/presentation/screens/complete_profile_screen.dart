import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atlas_paragliding_v2/features/operator/data/repositories/operator_profile_repository.dart';

const _defaultCancellationPolicy =
    'Free cancellation up to 48 hours before the activity. '
    'No refund for cancellations within 48 hours.';
const _defaultRefundPolicy =
    'Full refund for eligible cancellations, processed within 5-7 business days.';

class CompleteProfileScreen extends ConsumerStatefulWidget  {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _yearsController = TextEditingController();
  final _cancellationController = TextEditingController(text: _defaultCancellationPolicy);
  final _refundController = TextEditingController(text: _defaultRefundPolicy);
  bool _loading = true;
  bool _saving = false;
  String _status = 'draft';
  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

Future<void> _loadExisting() async {
  final data = await ref.read(operatorProfileRepositoryProvider).fetchOwnProfile();
  if (!mounted) return;

  if (data != null) {
    _bioController.text = (data['bio'] as String?) ?? '';
    _yearsController.text = data['years_of_experience']?.toString() ?? '';
    _cancellationController.text = (data['cancellation_policy'] as String?) ?? _defaultCancellationPolicy;
    _refundController.text = (data['refund_policy'] as String?) ?? _defaultRefundPolicy;
    _status = (data['verification_status'] as String?) ?? 'draft';
  }
  setState(() => _loading = false);
}
  @override
  void dispose() {
    _bioController.dispose();
    _yearsController.dispose();
    _cancellationController.dispose();
    _refundController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(operatorProfileRepositoryProvider).updateProfile(bio: _bioController.text.trim(), yearsOfExperience: int.parse(_yearsController.text.trim()), cancellationPolicy: _cancellationController.text.trim(), refundPolicy: _refundController.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved')),
      );
    } catch (e) {
      // ignore: avoid_print
      print('PROFILE SAVE ERROR: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong — check terminal')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _submitForReview() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Finish all fields before submitting')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(operatorProfileRepositoryProvider).updateProfile(
            bio: _bioController.text.trim(),
            yearsOfExperience: int.parse(_yearsController.text.trim()),
            cancellationPolicy: _cancellationController.text.trim(),
            refundPolicy: _refundController.text.trim(),
          );
      await ref.read(operatorProfileRepositoryProvider).submitForReview();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Submitted for review')),
      );
    } catch (e) {
      // ignore: avoid_print
      print('SUBMIT FOR REVIEW ERROR: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong — check terminal')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Complete your profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _bioController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    helperText: 'Tell clients about your experience and style',
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Bio is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _yearsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Years of experience'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (int.tryParse(v.trim()) == null) return 'Enter a number';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cancellationController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Cancellation policy'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _refundController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Refund policy'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
                const SizedBox(height: 16),
                if (_status == 'draft')
                  OutlinedButton(
                    onPressed: _saving ? null : _submitForReview,
                    child: const Text('Submit for review'),
                  )
                else if (_status == 'submitted')
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'Under review — you\'ll be notified when approved',
                      style: TextStyle(color: Colors.orange),
                      textAlign: TextAlign.center,
                    ),
                  )
                else if (_status == 'approved')
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'Approved — you can post offers',
                      style: TextStyle(color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            )
          ),
        )
        ),
    );
  }
}