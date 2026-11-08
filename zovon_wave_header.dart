import 'package:flutter/material.dart';

class ZovonWaveHeader extends StatelessWidget {
  const ZovonWaveHeader({super.key, this.child, this.height = 260});

  final Widget? child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(color: Theme.of(context).scaffoldBackgroundColor),
          CustomPaint(
            painter: _ZovonWaveLayerPainter(
              color: Color.lerp(
                Theme.of(context).colorScheme.tertiary,
                Colors.white,
                0.12,
              )!,
              top: _upperWave,
              layer: _WaveLayer.top,
            ),
          ),
          CustomPaint(
            painter: _ZovonWaveLayerPainter(
              color: Theme.of(context).colorScheme.primary,
              top: _upperWave,
              bottom: _middleWave,
              layer: _WaveLayer.band,
            ),
          ),
          CustomPaint(
            painter: _ZovonWaveLayerPainter(
              color: Color.lerp(
                Theme.of(context).colorScheme.secondary,
                Colors.black,
                0.2,
              )!,
              top: _middleWave,
              bottom: _lowerWave,
              layer: _WaveLayer.band,
            ),
          ),
          if (child case final child?)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 72),
              child: child,
            ),
        ],
      ),
    );
  }
}

const _upperWave = [
  _BezierPoint(-0.12, 0.63),
  _BezierPoint(0.16, 0.54),
  _BezierPoint(0.38, 0.72),
  _BezierPoint(0.62, 0.58),
  _BezierPoint(0.84, 0.69),
  _BezierPoint(1.12, 0.51),
];

const _middleWave = [
  _BezierPoint(-0.12, 0.72),
  _BezierPoint(0.12, 0.64),
  _BezierPoint(0.35, 0.81),
  _BezierPoint(0.59, 0.67),
  _BezierPoint(0.87, 0.78),
  _BezierPoint(1.12, 0.6),
];

const _lowerWave = [
  _BezierPoint(-0.12, 0.84),
  _BezierPoint(0.2, 0.76),
  _BezierPoint(0.43, 0.91),
  _BezierPoint(0.67, 0.79),
  _BezierPoint(0.91, 0.88),
  _BezierPoint(1.12, 0.72),
];

enum _WaveLayer { top, band }

class _ZovonWaveLayerPainter extends CustomPainter {
  const _ZovonWaveLayerPainter({
    required this.color,
    required this.top,
    required this.layer,
    this.bottom,
  });

  final Color color;
  final List<_BezierPoint> top;
  final List<_BezierPoint>? bottom;
  final _WaveLayer layer;

  @override
  void paint(Canvas canvas, Size size) {
    if (layer == _WaveLayer.top) {
      _drawAreaToTop(canvas, size);
    } else {
      _drawBand(canvas, size);
    }
  }

  void _drawAreaToTop(Canvas canvas, Size size) {
    final path = Path();
    _appendCurve(path, size, top);
    path
      ..lineTo(size.width * top.last.x, 0)
      ..lineTo(size.width * top.first.x, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawBand(Canvas canvas, Size size) {
    final path = Path();
    _appendCurve(path, size, top);
    _appendCurve(path, size, bottom!.reversed.toList());
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _appendCurve(Path path, Size size, List<_BezierPoint> points) {
    final first = _scaledPoint(size, points.first);
    if (path.getBounds().isEmpty) {
      path.moveTo(first.dx, first.dy);
    } else {
      path.lineTo(first.dx, first.dy);
    }
    for (var index = 1; index < points.length; index++) {
      final previous = _scaledPoint(size, points[index - 1]);
      final current = _scaledPoint(size, points[index]);
      final before = _scaledPoint(
        size,
        points[index > 1 ? index - 2 : index - 1],
      );
      final after = _scaledPoint(
        size,
        points[index + 1 < points.length ? index + 1 : index],
      );
      final outgoing = (current - before) / 6;
      final incoming = (after - previous) / 6;
      path.cubicTo(
        previous.dx + outgoing.dx,
        previous.dy + outgoing.dy,
        current.dx - incoming.dx,
        current.dy - incoming.dy,
        current.dx,
        current.dy,
      );
    }
  }

  Offset _scaledPoint(Size size, _BezierPoint point) {
    return Offset(size.width * point.x, size.height * point.y);
  }

  @override
  bool shouldRepaint(_ZovonWaveLayerPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.top != top ||
        oldDelegate.bottom != bottom ||
        oldDelegate.layer != layer;
  }
}

class _BezierPoint {
  const _BezierPoint(this.x, this.y);

  final double x;
  final double y;
}
