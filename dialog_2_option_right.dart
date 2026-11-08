import 'dart:ui';

import 'package:flutter/material.dart';

class ZovonDialog extends StatefulWidget {
  const ZovonDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onAccept,
    required this.onReject,
  });

  final String title;
  final String message;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  State<ZovonDialog> createState() => _ZovonDialogState();
}

class _ZovonDialogState extends State<ZovonDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sheenController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat();

  @override
  void dispose() {
    _sheenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: AnimatedBuilder(
            animation: _sheenController,
            builder: (context, child) {
              final sweepProgress = ((_sheenController.value - 0.55) / 0.45)
                  .clamp(0.0, 1.0);
              final position = -1.5 + (sweepProgress * 3);
              return Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.58),
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.72),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(10, 10, 14, 0.07),
                      blurRadius: 24,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 16),
                    Text(
                      widget.message,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _swipeButton(
                          position: position,
                          child: OutlinedButton(
                            onPressed: widget.onReject,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colorScheme.onSurface,
                              side: BorderSide(
                                color: theme.colorScheme.onSurface,
                                width: 1.5,
                              ),
                            ),
                            child: const Text('Reject'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _swipeButton(
                          position: position,
                          child: FilledButton(
                            onPressed: widget.onAccept,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFDCB867),
                              foregroundColor: const Color(0xFF0A0A0C),
                            ),
                            child: const Text('Accept'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _swipeButton({required double position, required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(position - 0.8, -1),
                    end: Alignment(position + 0.8, 1),
                    colors: const [
                      Colors.transparent,
                      Color.fromRGBO(255, 255, 255, 0.28),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool?> showZovonDialog(
  BuildContext context, {
  required String title,
  required String message,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => ZovonDialog(
      title: title,
      message: message,
      onAccept: () => Navigator.of(context).pop(true),
      onReject: () => Navigator.of(context).pop(false),
    ),
  );
}
