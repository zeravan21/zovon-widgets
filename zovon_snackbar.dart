import 'package:flutter/material.dart';

class ZovonSnackBar extends StatelessWidget {
  const ZovonSnackBar({
    super.key,
    required this.message,
    this.icon = Icons.check_circle_outline_rounded,
    this.onUndo,
  });

  final String message;
  final IconData icon;
  final VoidCallback? onUndo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: theme.colorScheme.surface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: onUndo,
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Undo'),
          ),
        ],
      ),
    );
  }
}

void showZovonSnackBar(
  BuildContext context, {
  required String message,
  IconData icon = Icons.check_circle_outline_rounded,
  VoidCallback? onUndo,
  Duration duration = const Duration(seconds: 4),
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.all(20),
        padding: EdgeInsets.zero,
        duration: duration,
        content: ZovonSnackBar(message: message, icon: icon, onUndo: onUndo),
      ),
    );
}
