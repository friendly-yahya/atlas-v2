import 'package:flutter/material.dart';
import 'package:atlas_paragliding_v2/features/operator/domain/activity_category.dart';
import 'custom_checkbox.dart';

class ActivityListSection extends StatelessWidget {
  final String title;
  final List<ActivityCategory> activities;
  final Set<String> selectedIds;
  final ValueChanged<String> onToggle;

  const ActivityListSection({
    super.key,
    required this.title,
    required this.activities,
    required this.selectedIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        ...activities.map((activity) {
          final isSelected = selectedIds.contains(activity.id);
          return InkWell(
            onTap: () => onToggle(activity.id),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              child: Row(
                children: [
                  CustomCheckbox(
                    isSelected: isSelected,
                    onTap: () => onToggle(activity.id),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      activity.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}