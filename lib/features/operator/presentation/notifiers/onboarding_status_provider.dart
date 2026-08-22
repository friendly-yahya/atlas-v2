
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:atlas_paragliding_v2/core/network/supabase_provider.dart';
import 'package:atlas_paragliding_v2/app/router/app_routes.dart';
import 'package:atlas_paragliding_v2/features/auth/presentation/notifiers/auth_controller.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
final onboardingStatusProvider = AsyncNotifierProvider<OnboardingStatusNotifier, OnboardingStatus>(
  () => OnboardingStatusNotifier(),
);

class OnboardingStatus {
  final bool hasActivities;
  final bool hasIdentity;
  final bool hasVerifiedPhone;

  const OnboardingStatus({
    this.hasActivities = false,
    this.hasIdentity = false,
    this.hasVerifiedPhone = false,
  });

  bool get isComplete => hasActivities && hasIdentity && hasVerifiedPhone;

  String? get nextRoute {
    if (!hasActivities) return AppRoutes.onboardingActivity;
    if (!hasIdentity) return AppRoutes.onboardingIdentity;
    if (!hasVerifiedPhone) return AppRoutes.onboardingPhone;
    return null; // All done
  }
}

class OnboardingStatusNotifier extends AsyncNotifier<OnboardingStatus> {
  @override
  Future<OnboardingStatus> build() async {
    // watch (not read) — this makes the provider automatically rebuild
    // every time the logged-in user changes (login, logout, switch account).
    final authUser = ref.watch(authNotifierProvider).value;
    if (authUser == null) return const OnboardingStatus();

    final supabase = ref.read(supabaseClientProvider);

    final profile = await supabase
        .from('operator_profile')
        .select('first_name, phone_verified')
        .eq('id', authUser.id)
        .maybeSingle();

    final activities = await supabase
        .from('operator_activity_categories')
        .select('activity_category_id')
        .eq('operator_id', authUser.id);

    final status = OnboardingStatus(
      hasIdentity: profile != null && profile['first_name'] != null,
      hasVerifiedPhone: profile != null && profile['phone_verified'] == true,
      hasActivities: activities.isNotEmpty,
    );
    debugPrint('onboardingStatus: user=${authUser.id} profile=$profile '
        'activities=$activities isComplete=${status.isComplete} '
        'nextRoute=${status.nextRoute}');
    return status;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}