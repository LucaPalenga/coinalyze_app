import 'package:flutter/material.dart';

import '../../constants/sizes_config.dart';
import '../../extensions/build_context.dart';

/// A compact chip displaying a [label] and a [value] side by side.
///
/// Used in chart headers to show OHLC values in a clean, uniform style.
class ValueChip extends StatelessWidget {
  final String label;
  final String? value;
  final Color valueColor;

  const ValueChip({
    super.key,
    required this.label,
    this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Container(
      margin: const EdgeInsets.only(right: SpacingSize.xs),
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingSize.sm,
        vertical: SpacingSize.xxs,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(BorderRadiusSize.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: SpacingSize.xs),
          Text(
            value ?? '-',
            style: context.textTheme.labelSmall?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
