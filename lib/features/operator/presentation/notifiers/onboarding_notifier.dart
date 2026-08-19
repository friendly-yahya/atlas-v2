import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/onboarding_repository.dart';
import '../../domain/onboarding_state.dart';

final onboardingNotifierProvider =
    AsyncNotifierProvider<OnboardingNotifier, OnboardingState>(
  () => OnboardingNotifier(),
);

class OnboardingNotifier extends AsyncNotifier<OnboardingState> {
  @override
  Future<OnboardingState> build() async {
    final categories = await ref.read(onboardingRepositoryProvider).fetchCategories();
    return OnboardingState(categories: categories);
  }

  void updateSearchQuery(String query) {
    state = AsyncData(state.value!.copyWith(searchQuery: query));
  }

  void toggleChip(String chip) {
    final current = state.value!;
    final updated = Set<String>.from(current.selectedChips);

    if (chip == 'show_all') {
      updated.clear();
    } else {
      if (updated.contains(chip)) {
        updated.remove(chip);
      } else {
        updated.add(chip);
      }
    }

    state = AsyncData(current.copyWith(selectedChips: updated));
  }

  void toggleActivity(String activityId) {
    final current = state.value!;
    final updated = Set<String>.from(current.selectedActivityIds);

    if (updated.contains(activityId)) {
      updated.remove(activityId);
    } else {
      updated.add(activityId);
    }

    state = AsyncData(current.copyWith(selectedActivityIds: updated));
  }

  Future<bool> saveActivities() async {
    final current = state.value!;
    if (current.selectedActivityIds.isEmpty) return false;

    state = AsyncData(current.copyWith(isSubmitting: true, errorMessage: null));

    state = await AsyncValue.guard(() async {
      await ref.read(onboardingRepositoryProvider).saveActivities(
            current.selectedActivityIds.toList(),
          );
      return current.copyWith(isSubmitting: false);
    });

    return state.hasValue;
  }

  void clearError() {
    final current = state.value!;
    state = AsyncData(current.copyWith(errorMessage: null));
  }
}