import 'package:flutter/material.dart';

import '../../constants/sizes_config.dart';

/// An entry for [showSelectionDialog].
class SelectionItem<T> {
  final T value;
  final String label;

  const SelectionItem({required this.value, required this.label});
}

/// Shows a reusable modal bottom-sheet dialog for selecting one item
/// from a list of [SelectionItem]s.
///
/// Returns the selected value or `null` if dismissed.
Future<T?> showSelectionDialog<T>({
  required BuildContext context,
  required String title,
  required List<SelectionItem<T>> items,
  T? selectedValue,
}) {
  final colors = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: colors.surfaceContainerHigh,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(BorderRadiusSize.lg)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: SpacingSize.sm),
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: colors.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingSize.md,
                vertical: SpacingSize.sm,
              ),
              child: Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(height: 1),
            // Items
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (ctx, index) {
                  final item = items[index];
                  final isSelected = item.value == selectedValue;
                  return ListTile(
                    dense: true,
                    title: Text(
                      item.label,
                      style: textTheme.bodyMedium?.copyWith(
                        color: isSelected ? colors.primary : colors.onSurface,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check, color: colors.primary, size: IconSize.smaller)
                        : null,
                    onTap: () => Navigator.of(ctx).pop(item.value),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
