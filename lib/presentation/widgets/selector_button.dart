import 'package:flutter/material.dart';

import '../../constants/sizes_config.dart';

/// A reusable tappable button used for selection controls (e.g. time interval,
/// chart type). Displays a label with an outlined/filled style that clearly
/// communicates it is interactive.
class SelectorButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const SelectorButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingSize.sm,
          vertical: SpacingSize.xs,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: colors.outline.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(BorderRadiusSize.sm),
        ),
        child: Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
