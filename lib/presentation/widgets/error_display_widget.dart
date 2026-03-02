import 'package:flutter/material.dart';

import '../../constants/sizes_config.dart';
import '../../core/error/exceptions.dart';
import '../../extensions/build_context.dart';

/// A reusable widget to display errors with an icon, title, message,
/// and an optional retry button.
///
/// Automatically adapts its content based on the type of [Exception]:
/// - [NetworkException] → connection error with specific messaging
/// - [UnauthorizedException] → authentication error
/// - [RateLimitException] → rate limit error
/// - [ServerException] → server error with status code detail
/// - Other → generic error
class ErrorDisplayWidget extends StatelessWidget {
  /// The error that occurred. Used to determine the icon, title, and message.
  final Object error;

  /// Optional callback invoked when the user taps the retry button.
  /// If null, the retry button is hidden.
  final VoidCallback? onRetry;

  const ErrorDisplayWidget({super.key, required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final errorInfo = _resolveError(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SpacingSize.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(errorInfo.icon, color: errorInfo.iconColor, size: IconSize.xl),
            const SizedBox(height: SpacingSize.lg),
            Text(
              errorInfo.title,
              style: context.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SpacingSize.sm),
            Text(
              errorInfo.message,
              style: context.textTheme.bodySmall?.copyWith(color: Colors.white54),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: SpacingSize.xxl),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: IconSize.smaller),
                label: Text(context.l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _ErrorInfo _resolveError(BuildContext context) {
    final l10n = context.l10n;

    if (error is NetworkException) {
      return _ErrorInfo(
        icon: Icons.wifi_off_rounded,
        iconColor: Colors.orangeAccent,
        title: l10n.error_network_title,
        message: l10n.error_network_message,
      );
    }

    if (error is UnauthorizedException) {
      return _ErrorInfo(
        icon: Icons.lock_outline_rounded,
        iconColor: Colors.redAccent,
        title: l10n.error_unauthorized_title,
        message: l10n.error_unauthorized_message,
      );
    }

    if (error is RateLimitException) {
      return _ErrorInfo(
        icon: Icons.timer_off_rounded,
        iconColor: Colors.amber,
        title: l10n.error_rate_limit_title,
        message: l10n.error_rate_limit_message,
      );
    }

    if (error is ServerException) {
      final se = error as ServerException;
      return _ErrorInfo(
        icon: Icons.cloud_off_rounded,
        iconColor: Colors.redAccent,
        title: l10n.error_server_title,
        message: se.message,
      );
    }

    // Generic / unknown error
    return _ErrorInfo(
      icon: Icons.error_outline_rounded,
      iconColor: Colors.redAccent,
      title: l10n.error_generic_title,
      message: error.toString(),
    );
  }
}

class _ErrorInfo {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;

  const _ErrorInfo({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
  });
}
