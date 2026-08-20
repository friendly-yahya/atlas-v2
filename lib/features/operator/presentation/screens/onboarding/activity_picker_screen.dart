
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:atlas_paragliding_v2/app/router/app_routes.dart';
import '../../notifiers/onboarding_notifier.dart';
import 'package:atlas_paragliding_v2/features/operator/domain/onboarding_state.dart';
import '../../widgets/onboarding/onboarding_progress_bar.dart';
import '../../widgets/onboarding/activity_category_chip.dart';
import '../../widgets/onboarding/activity_list_section.dart';
//import 'package:atlas_paragliding_v2/features/operator/domain/activity_category.dart';
class ActivityPickerScreen extends ConsumerStatefulWidget {
  const ActivityPickerScreen({super.key});

  @override
  ConsumerState<ActivityPickerScreen> createState() => _ActivityPickerScreenState();
}

class _ActivityPickerScreenState extends ConsumerState<ActivityPickerScreen> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  static const _chipKeys = [
    ('water', 'Water', Icons.water_outlined),
    ('aerial', 'Aerial', Icons.flight_outlined),
    ('desert', 'Desert', Icons.terrain_outlined),
    ('wheels', 'Wheels', Icons.pedal_bike_outlined),
    ('forest', 'Forest', Icons.forest_outlined),
    ('mountains', 'Mountains', Icons.landscape_outlined),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final asyncState = ref.watch(onboardingNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: asyncState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => _ErrorBody(
            message: err.toString(),
            onRetry: () => ref.invalidate(onboardingNotifierProvider),
          ),
          data: (state) => _buildBody(context, theme, state),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme, OnboardingState state) {
    final notifier = ref.read(onboardingNotifierProvider.notifier);
    final grouped = state.groupedCategories;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const OnboardingProgressBar(currentStep: 1, totalSteps: 5),
          const SizedBox(height: 24),
          Text(
            'What do you do?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "We'll match you with travelers already searching for your activity.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),

          // Search bar
          TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            onChanged: notifier.updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search activities...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () {
                  // Future: advanced filters. For now, chips handle filtering.
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),

          // Filter chips
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _chipKeys.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                if (index == _chipKeys.length) {
                  return _ShowAllChip(
                    isSelected: state.selectedChips.isEmpty,
                    onTap: () => notifier.toggleChip('show_all'),
                  );
                }
                final (key, label, icon) = _chipKeys[index];
                return ActivityCategoryChip(
                  label: label,
                  icon: icon,
                  isSelected: state.selectedChips.contains(key),
                  onTap: () => notifier.toggleChip(key),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Activity list
          Expanded(
            child: grouped.isEmpty
                ? Center(
                    child: Text(
                      'No activities found',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: grouped.length,
                    itemBuilder: (context, index) {
                      final groupKey = grouped.keys.elementAt(index);
                      final activities = grouped[groupKey]!;
                      return ActivityListSection(
                        title: state.groupLabel(groupKey),
                        activities: activities,
                        selectedIds: state.selectedActivityIds,
                        onToggle: notifier.toggleActivity,
                      );
                    },
                  ),
          ),

          // Continue button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: state.hasSelection
                  ? () async {
                      final success = await notifier.saveActivities();
                      if (success && mounted) {
                        context.go(AppRoutes.onboardingIdentity);
                      }
                    }
                  : null,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: state.isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Continue'),
            ),
          ),
          const SizedBox(height: 8),

          // Skip link
          Center(
            child: TextButton(
              onPressed: () => context.go(AppRoutes.onboardingIdentity),
              child: Text(
                "I'll decide later",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ShowAllChip extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _ShowAllChip({required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ActionChip(
      onPressed: onTap,
      label: const Text('Show all →'),
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
      ),
      side: BorderSide.none,
      backgroundColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}