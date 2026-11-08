import 'dart:math' as math;

import 'package:flutter/material.dart';

class ZovonLoader extends StatefulWidget {
  const ZovonLoader({
    super.key,
    this.size = 96,
    this.color,
    this.duration = const Duration(milliseconds: 1100),
  });

  final double size;
  final Color? color;
  final Duration duration;

  @override
  State<ZovonLoader> createState() => _ZovonLoaderState();
}

class _ZovonLoaderState extends State<ZovonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  @override
  void didUpdateWidget(covariant ZovonLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller
        ..duration = widget.duration
        ..repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loaderColor = widget.color ?? Theme.of(context).colorScheme.primary;

    return Semantics(
      label: 'Loading',
      child: ExcludeSemantics(
        child: SizedBox.square(
          dimension: widget.size,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _ZovonLoaderPainter(
                  progress: _controller.value,
                  color: loaderColor,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ZovonLoaderPainter extends CustomPainter {
  const _ZovonLoaderPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final scale = 1 + (0.28 * (0.5 - (progress - 0.5).abs()) * 2);
    final colorProgress = (progress * 2) % 1;
    final markColor = progress < 0.5
        ? Color.lerp(color, const Color(0xFFC99A35), colorProgress * 2)!
        : Color.lerp(
            const Color(0xFFC99A35),
            const Color(0xFF2F7154),
            (colorProgress - 0.5) * 2,
          )!;

    final circlePaint = Paint()
      ..color = markColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.035;
    final circleRadius = size.width * 0.42 * scale;
    canvas.drawCircle(center, circleRadius, circlePaint);

    final dotRadius = size.width * 0.035;
    final dotOrbitRadius = circleRadius + (size.width * 0.08);
    final dotPaint = Paint()..style = PaintingStyle.fill;
    const dotCount = 5;
    for (var index = 0; index < dotCount; index++) {
      final dotPhase = (progress + (index / dotCount)) % 1;
      final angle = dotPhase * 2 * math.pi;
      final emphasis = (math.sin(dotPhase * 2 * math.pi) + 1) / 2;
      dotPaint.color = markColor.withValues(alpha: 0.3 + (emphasis * 0.7));
      canvas.drawCircle(
        center +
            Offset(
              math.cos(angle) * dotOrbitRadius,
              math.sin(angle) * dotOrbitRadius,
            ),
        dotRadius * (0.65 + (emphasis * 0.35)),
        dotPaint,
      );
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'z',
        style: TextStyle(
          color: markColor,
          fontFamily: 'Hubballi',
          fontSize: size.width * 0.78 * scale,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final glyphBounds = textPainter
        .getBoxesForSelection(
          const TextSelection(baseOffset: 0, extentOffset: 1),
        )
        .fold<Rect?>(
          null,
          (bounds, box) =>
              bounds?.expandToInclude(box.toRect()) ?? box.toRect(),
        );
    final visualCenter =
        glyphBounds?.center ??
        Offset(textPainter.width / 2, textPainter.height / 2);
    final textOffset = Offset(
      center.dx - visualCenter.dx,
      center.dy - visualCenter.dy + (size.height * 0.06),
    );

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.translate(-center.dx, -center.dy);
    textPainter.paint(canvas, textOffset);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ZovonLoaderPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
