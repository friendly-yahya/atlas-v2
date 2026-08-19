import 'package:freezed_annotation/freezed_annotation.dart';

import 'activity_category.dart';

part 'onboarding_state.freezed.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(<ActivityCategory>[]) List<ActivityCategory> categories,
    @Default('') String searchQuery,
    @Default(<String>{}) Set<String> selectedChips,
    @Default(<String>{}) Set<String> selectedActivityIds,
    @Default(false) bool isSubmitting,
    String? errorMessage,
  }) = _OnboardingState;
}

extension OnboardingStateX on OnboardingState {
  List<ActivityCategory> get filteredCategories {
    var result = categories;

    if (selectedChips.isNotEmpty &&
        !selectedChips.contains('show_all')) {
      result = result.where((category) {
        return category.categoryGroup != null &&
            selectedChips.contains(category.categoryGroup);
      }).toList();
    }

    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.toLowerCase();

      result = result.where((category) {
        return category.name.toLowerCase().contains(query) ||
            (category.description?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return result;
  }

  Map<String, List<ActivityCategory>> get groupedCategories {
    final groups = <String, List<ActivityCategory>>{};

    for (final category in filteredCategories) {
      final group = category.categoryGroup ?? 'other';
      groups.putIfAbsent(group, () => []).add(category);
    }

    return groups;
  }

  static String groupLabel(String groupKey) {
    return switch (groupKey) {
      'water' => 'Water Activities',
      'aerial' => 'Aerial Activities',
      'desert' => 'Desert Activities',
      'wheels' => 'Wheels Activities',
      'forest' => 'Forest Activities',
      'mountains' => 'Mountain Activities',
      'cultural' => 'Cultural Activities',
      'land' => 'Land Activities',
      _ => 'Other Activities',
    };
  }

  bool get hasSelection => selectedActivityIds.isNotEmpty;
}