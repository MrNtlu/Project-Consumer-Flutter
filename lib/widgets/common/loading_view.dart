import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoadingView extends StatefulWidget {
  final String _text;
  final Color textColor;

  const LoadingView(this._text, {this.textColor = Colors.black, super.key});

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Cache TextSpan objects for performance
  late TextSpan _baseTextSpan;
  late List<TextSpan> _dotSpans;
  late Color _effectiveTextColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeTextSpans();
  }

  void _initializeTextSpans() {
    _effectiveTextColor = widget.textColor == Colors.black
        ? CupertinoTheme.of(context).bgTextColor
        : widget.textColor;

    final baseStyle = TextStyle(
      color: _effectiveTextColor,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      height: 1.3,
      shadows: [
        Shadow(
          color: Colors.black.withValues(alpha: 0.15),
          offset: const Offset(0, 1),
          blurRadius: 2,
        ),
      ],
    );

    _baseTextSpan = TextSpan(text: widget._text, style: baseStyle);

    // Pre-create dot spans for performance
    _dotSpans = List.generate(4, (index) {
      return TextSpan(
        text: '.' * index,
        style: baseStyle.copyWith(letterSpacing: 2.0),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isPortrait = constraints.maxHeight > constraints.maxWidth ||
              Platform.isMacOS ||
              Platform.isWindows;

          return isPortrait
              ? _body(context)
              : SizedBox(
                  height: constraints.maxHeight,
                  child: _body(context),
                );
        },
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundary(
            child: SizedBox(
              width: 240,
              height: 240,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _WatchlistfyLoadingPainter(_controller.value),
                    size: const Size(240, 240),
                    child: child,
                  );
                },
                child: Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF64B5F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                'W',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Optimized dot calculation
                final dotIndex = ((_controller.value * 4) % 4).floor();

                return RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      _baseTextSpan,
                      _dotSpans[dotIndex],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WatchlistfyLoadingPainter extends CustomPainter {
  final double animationValue;

  // Cache paints for better performance
  static final _outerCirclePaint = Paint()
    ..color = const Color(0xFF2A3441)
    ..style = PaintingStyle.fill;

  static final _innerCirclePaint = Paint()
    ..color = const Color(0xFF1A2332)
    ..style = PaintingStyle.fill;

  // Pre-computed FontAwesome icon data for performance
  static const _iconData = [
    {
      'icon': FontAwesomeIcons.film,
      'angle': 0.0,
      'color': Color(0xFF64B5F6)
    }, // movie
    {
      'icon': FontAwesomeIcons.masksTheater,
      'angle': 1.5708,
      'color': Color(0xFF81C784)
    }, // tv
    {
      'icon': FontAwesomeIcons.userNinja,
      'angle': 3.1416,
      'color': Color(0xFFBA68C8)
    }, // anime
    {
      'icon': FontAwesomeIcons.gamepad,
      'angle': 4.7124,
      'color': Color(0xFFFFB74D)
    }, // games
  ];

  _WatchlistfyLoadingPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    // Draw outer circle background
    canvas.drawCircle(center, radius, _outerCirclePaint);

    // Draw inner circle
    canvas.drawCircle(center, radius * 0.7, _innerCirclePaint);

    // Draw rotating icons with optimized approach
    final rotationAngle = animationValue * 2 * math.pi;

    for (final iconInfo in _iconData) {
      final angle = (iconInfo['angle'] as double) + rotationAngle;
      final iconCenter = Offset(
        center.dx + radius * 0.85 * math.cos(angle),
        center.dy + radius * 0.85 * math.sin(angle),
      );

      final color = iconInfo['color'] as Color;

      // Draw icon background circle
      final iconBgPaint = Paint()
        ..color = color.withOpacity(0.2)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(iconCenter, 20, iconBgPaint);

      // Draw FontAwesome icon using optimized TextPainter
      final iconData = iconInfo['icon'] as IconData;
      final iconPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(iconData.codePoint),
          style: TextStyle(
            fontSize: 22,
            fontFamily: iconData.fontFamily,
            package: iconData.fontPackage,
            color: color,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      iconPainter.layout();
      iconPainter.paint(
        canvas,
        Offset(
          iconCenter.dx - iconPainter.width / 2,
          iconCenter.dy - iconPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WatchlistfyLoadingPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
