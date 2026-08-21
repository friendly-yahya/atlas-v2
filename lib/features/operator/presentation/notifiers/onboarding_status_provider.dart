// Checks onboarding completion status and routes user to correct step.
// Runs on every app launch / auth state change.
// Long-term: cache result in memory to avoid repeated Supabase calls.

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:atlas_paragliding_v2/core/network/supabase_provider.dart';

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
    if (!hasActivities) return '/onboarding/activity';
    if (!hasIdentity) return '/onboarding/identity';
    if (!hasVerifiedPhone) return '/onboarding/phone';
    return null; // All done
  }
}

class OnboardingStatusNotifier extends AsyncNotifier<OnboardingStatus> {
  @override
  Future<OnboardingStatus> build() async {
    final user = ref.read(supabaseClientProvider).auth.currentUser;
    if (user == null) return const OnboardingStatus();

    final supabase = ref.read(supabaseClientProvider);

    // Check identity (first_name in operator_profile)
    final profile = await supabase
        .from('operator_profile')
        .select('first_name, phone_verified')
        .eq('id', user.id)
        .maybeSingle();

    // Check activities
    final activities = await supabase
        .from('operator_activity_categories')
        .select('activity_category_id')
        .eq('operator_id', user.id);

    return OnboardingStatus(
      hasIdentity: profile != null && profile['first_name'] != null,
      hasVerifiedPhone: profile != null && profile['phone_verified'] == true,
      hasActivities: activities.isNotEmpty,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}