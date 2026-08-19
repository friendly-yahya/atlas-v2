import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import 'package:atlas_paragliding_v2/core/network/supabase_provider.dart';
import 'package:atlas_paragliding_v2/core/error/app_exception.dart' ;
import '../../domain/activity_category.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository(supabase: ref.watch(supabaseClientProvider));
});

class OnboardingRepository {
  final SupabaseClient _supabase;

  OnboardingRepository({required SupabaseClient supabase}) : _supabase = supabase;

  Future<List<ActivityCategory>> fetchCategories() async {
    try {
      final response = await _supabase
          .from('activity_categories')
          .select('id, slug, name, category_group, description')
          .eq('is_active', true)
          .order('name');

      return (response as List<dynamic>)
          .map((json) => ActivityCategory.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw DataException('Failed to load activities: ${e.message}');
    } catch (e) {
      throw const NetworkException();
    }
  }

  Future<void> saveActivities(List<String> activityIds) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw const AuthException('Not authenticated');

    try {
      await _supabase
          .from('operator_activity_categories')
          .delete()
          .eq('operator_id', user.id);

      if (activityIds.isNotEmpty) {
        final rows = activityIds
            .map((id) => {
                  'operator_id': user.id,
                  'activity_category_id': id,
                })
            .toList();

        await _supabase.from('operator_activity_categories').insert(rows);
      }
    } on PostgrestException catch (e) {
      throw DataException('Failed to save activities: ${e.message}');
    } catch (e) {
      throw const NetworkException();
    }
  }
}