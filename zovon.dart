import 'package:flutter/material.dart';

class Zovon extends StatefulWidget {
  const Zovon({
    super.key,
    required this.value,
    this.label,
    this.height = 96,
    this.backgroundColor,
    this.progressColor,
    this.duration = const Duration(milliseconds: 450),
  });

  final double value;
  final String? label;
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final Duration duration;

  @override
  State<Zovon> createState() => _ZovonState();
}

class _ZovonState extends State<Zovon> with SingleTickerProviderStateMixin {
  late final AnimationController _swipeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );

  @override
  void didUpdateWidget(covariant Zovon oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldValue = oldWidget.value.clamp(0.0, 1.0);
    final newValue = widget.value.clamp(0.0, 1.0);
    if ((newValue * 20).floor() > (oldValue * 20).floor()) {
      _swipeController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clampedValue = widget.value.clamp(0.0, 1.0);
    final trackColor =
        widget.backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final fillColor = widget.progressColor ?? theme.colorScheme.primary;
    final textStyle = theme.textTheme.displaySmall?.copyWith(
      fontFamily: 'Hubballi',
      fontSize: widget.height * 0.45,
      fontWeight: FontWeight.w900,
      letterSpacing: 42.12,
      height: 1,
    );

    return Semantics(
      label: widget.label,
      value: '${(clampedValue * 100).round()}%',
      child: ExcludeSemantics(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: clampedValue),
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          builder: (context, animatedValue, child) {
            return AnimatedBuilder(
              animation: _swipeController,
              builder: (context, child) {
                final swipePosition = -1.5 + (_swipeController.value * 3);
                return Container(
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: trackColor,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: fillColor, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: animatedValue,
                          child: ColoredBox(color: fillColor),
                        ),
                        Center(
                          child: Stack(
                            children: [
                              Text(
                                'ZOVON',
                                style: textStyle?.copyWith(
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 3
                                    ..color = Colors.black,
                                ),
                              ),
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                    begin: Alignment(swipePosition - 0.6, 0),
                                    end: Alignment(swipePosition + 0.6, 0),
                                    colors: const [
                                      Color(0xFF0A0A0C),
                                      Color(0xFFC99A35),
                                      Color(0xFF0A0A0C),
                                    ],
                                  ).createShader(bounds);
                                },
                                child: Text(
                                  'ZOVON',
                                  style: textStyle?.copyWith(
                                    color: const Color(0xFF0A0A0C),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
