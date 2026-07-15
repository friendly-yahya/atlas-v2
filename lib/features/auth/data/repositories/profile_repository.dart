import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:atlas_paragliding_v2/core/network/supabase_provider.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(supabase: ref.watch(supabaseClientProvider));
},);

class ProfileRepository {
  final SupabaseClient _supabase;
  ProfileRepository({required SupabaseClient supabase}) : _supabase = supabase;

  Future<String?> getRole(String userId) async {
    final row = await _supabase
      .from('profiles')
      .select('role')
      .eq('id', userId)
      .maybeSingle();
    return row?['role'] as String?;
  }
}