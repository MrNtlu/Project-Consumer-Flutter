import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watchlistfy/widgets/main/settings/offers_sheet.dart';

class ErrorView extends StatefulWidget {
  final String _text;
  final VoidCallback _onPressed;
  final bool isPremiumError;

  const ErrorView(
    this._text,
    this._onPressed, {
    this.isPremiumError = false,
    super.key,
  });

  @override
  State<ErrorView> createState() => _ErrorViewState();
}

class _ErrorViewState extends State<ErrorView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;

  // Cache expensive objects for performance
  late TextStyle _textStyle;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cacheStyles();
  }

  void _cacheStyles() {
    _textStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      height: 1.4,
      color: CupertinoTheme.of(context).textTheme.textStyle.color,
      shadows: [
        Shadow(
          color: Colors.black.withValues(alpha: 0.1),
          offset: const Offset(0, 1),
          blurRadius: 1,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Column(
            children: [
              if (!widget.isPremiumError)
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(right: 8, top: 8),
                  child: ScaleTransition(
                    scale: _bounceAnimation,
                    child: _EnhancedRefreshButton(
                      onPressed: widget._onPressed,
                    ),
                  ),
                ),
              Container(
                margin: const EdgeInsets.only(top: 36),
                child: ScaleTransition(
                  scale: _bounceAnimation,
                  child: RepaintBoundary(
                    child: _CustomErrorIcon(
                      isPremium: widget.isPremiumError,
                      size: 125,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    widget._text,
                    textAlign: TextAlign.center,
                    style: _textStyle,
                  ),
                ),
              ),
              if (widget.isPremiumError) const SizedBox(height: 16),
              if (widget.isPremiumError)
                ScaleTransition(
                  scale: _bounceAnimation,
                  child: CupertinoButton.filled(
                    child: const Text(
                      "Upgrade Account",
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(
                          builder: (_) => const OffersSheet(),
                        ),
                      );
                    },
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}

class _CustomErrorIcon extends StatefulWidget {
  final bool isPremium;
  final double size;

  const _CustomErrorIcon({
    required this.isPremium,
    required this.size,
  });

  @override
  State<_CustomErrorIcon> createState() => _CustomErrorIconState();
}

class _CustomErrorIconState extends State<_CustomErrorIcon> {
  // Cache decorations and colors for performance
  late BoxDecoration _decoration;
  late IconData _iconData;
  late Color _iconColor;
  late double _iconSize;

  @override
  void initState() {
    super.initState();
    _cacheIconProperties();
  }

  void _cacheIconProperties() {
    _iconSize = widget.size * 0.4;

    if (widget.isPremium) {
      _decoration = BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFD700).withValues(alpha: 0.1),
        border: Border.all(
          color: const Color(0xFFFFD700).withValues(alpha: 0.3),
          width: 2,
        ),
      );
      _iconData = FontAwesomeIcons.crown;
      _iconColor = const Color(0xFFFFD700);
    } else {
      _decoration = BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFF6B6B).withValues(alpha: 0.1),
        border: Border.all(
          color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
          width: 2,
        ),
      );
      _iconData = FontAwesomeIcons.triangleExclamation;
      _iconColor = const Color(0xFFFF6B6B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: _decoration,
      child: Center(
        child: Icon(
          _iconData,
          size: _iconSize,
          color: _iconColor,
        ),
      ),
    );
  }
}

class _EnhancedRefreshButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _EnhancedRefreshButton({required this.onPressed});

  @override
  State<_EnhancedRefreshButton> createState() => _EnhancedRefreshButtonState();
}

class _EnhancedRefreshButtonState extends State<_EnhancedRefreshButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _rotationController.forward().then((_) {
      _rotationController.reset();
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isPressed
              ? CupertinoColors.systemBlue.withValues(alpha: 0.2)
              : CupertinoColors.systemBlue.withValues(alpha: 0.1),
          border: Border.all(
            color: CupertinoColors.systemBlue.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: CupertinoColors.systemBlue.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.14159,
              child: Icon(
                Icons.refresh_rounded,
                size: 24,
                color: CupertinoColors.systemBlue,
              ),
            );
          },
        ),
      ),
    );
  }
}
