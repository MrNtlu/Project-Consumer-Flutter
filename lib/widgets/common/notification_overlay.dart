import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/providers/common/notification_ui_view_model.dart';
import 'package:watchlistfy/widgets/common/notification_banner.dart';

class NotificationOverlay {
  static final NotificationOverlay _instance = NotificationOverlay._internal();
  factory NotificationOverlay() => _instance;

  NotificationOverlay._internal();

  OverlayEntry? _overlayEntry;
  bool _isShowing = false;

  void show(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    if (_isShowing) {
      hide();
    }

    Provider.of<NotificationUIViewModel>(
      context,
      listen: false,
    ).setNotification(
      title,
      message,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => const Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: NotificationBanner(),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isShowing = true;
  }

  void hide() {
    if (_overlayEntry != null && _isShowing) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _isShowing = false;
    }
  }
}
