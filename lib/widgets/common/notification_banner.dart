import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/providers/common/notification_ui_view_model.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/notification_overlay.dart';

class NotificationBanner extends StatefulWidget {
  const NotificationBanner({super.key});

  @override
  State<NotificationBanner> createState() => _NotificationBannerState();
}

class _NotificationBannerState extends State<NotificationBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  bool _isClosing = false;
  static const int durationSeconds = 5;
  static const animationDurationMilliseconds = 300;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: animationDurationMilliseconds),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.5),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showBanner() {
    _controller.forward();
    _startCountdown();
  }

  void _hideBanner() {
    if (_isClosing) return;
    _isClosing = true;

    _controller.reverse().then((_) {
      if (mounted) {
        final notificationUIVM = Provider.of<NotificationUIViewModel>(
          context,
          listen: false,
        );

        notificationUIVM.clearNotification();

        Future.delayed(const Duration(milliseconds: 100), () {
          NotificationOverlay().hide();
        });

        _isClosing = false;
      }
    });
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: durationSeconds), () {
      if (mounted && !_isClosing) {
        _hideBanner();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationUIVM = Provider.of<NotificationUIViewModel>(context);

    if (notificationUIVM.shouldShowNotification()) {
      _showBanner();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: notificationUIVM.shouldShowNotification()
              ? SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 3,
                    ),
                    child: SizedBox(
                      height: 80,
                      width: MediaQuery.sizeOf(context).width - 18,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        color: AppColors().primaryColor.withValues(
                              alpha: 0.95,
                            ),
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            children: [
                              const SizedBox(width: 6),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        notificationUIVM.title ??
                                            'Unknown Title',
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        notificationUIVM.description ??
                                            'Unknown description',
                                        textAlign: TextAlign.start,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 36,
                                height: 36,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0.0, end: 1.0),
                                        duration: const Duration(
                                          seconds: durationSeconds,
                                        ),
                                        builder: (context, value, child) {
                                          return CircularProgressIndicator(
                                            value: value,
                                            strokeWidth: 2,
                                            backgroundColor: Colors.grey[300],
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(
                                              Colors.redAccent,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Center(
                                      child: IconButton(
                                        onPressed: _hideBanner,
                                        icon: const Icon(
                                          Icons.close_rounded,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
