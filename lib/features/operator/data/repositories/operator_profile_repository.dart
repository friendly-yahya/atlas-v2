import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:atlas_paragliding_v2/core/network/supabase_provider.dart';

final operatorProfileRepositoryProvider = Provider<OperatorProfileRepository>((ref) {
  return OperatorProfileRepository(
    supabase: ref.watch(supabaseClientProvider)
  );
});

class OperatorProfileRepository {
  final SupabaseClient _supabase;
  OperatorProfileRepository({required SupabaseClient supabase}) : _supabase = supabase;

  Future<Map<String, dynamic>?> fetchOwnProfile() async {
    final uid = _supabase.auth.currentUser!.id;
    return await _supabase
      .from('operator_profile')
      .select()
      .eq('user_id', uid)
      .maybeSingle();
  }

  Future<void> updateProfile({
    required String bio,
    required int yearsOfExperience,
    required String cancellationPolicy,
    required String refundPolicy,
  }) async {
    final uid = _supabase.auth.currentUser!.id;
    await _supabase.from('operator_profile').update({
      'bio': bio,
      'years_of_experience': yearsOfExperience,
      'cancellation_policy': cancellationPolicy,
      'refund_policy': refundPolicy
    }).eq('user_id', uid);
  }

  Future<void> submitForReview() async {
  await _supabase.rpc('submit_operator_application_for_review');
}
}