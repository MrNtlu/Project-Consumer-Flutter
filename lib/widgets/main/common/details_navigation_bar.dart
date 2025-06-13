import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watchlistfy/models/main/common/trailer.dart';
import 'package:watchlistfy/pages/main/trailer_page.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/notification_overlay.dart';
import 'package:watchlistfy/widgets/common/trailer_sheet.dart';

class DetailsNavigationBar extends StatelessWidget {
  final String title;
  final String contentType;
  final String id;
  final List<Trailer>? trailers;
  final String? trailer;
  final bool isItemNull;
  final VoidCallback onRecommendationsTap;

  const DetailsNavigationBar(
    this.title,
    this.contentType,
    this.id,
    this.trailers,
    this.trailer,
    this.isItemNull,
    this.onRecommendationsTap, {
    super.key,
  });

  void _handleShareTap(BuildContext context) async {
    final url = '${Constants.BASE_DOMAIN_URL}/$contentType/$id';
    try {
      final box = context.findRenderObject() as RenderBox?;

      if (box != null) {
        Share.share(
          url,
          subject: 'Share Content',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
        );
      }
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: url));
      if (context.mounted) {
        NotificationOverlay().show(
          context,
          title: "Link Copied",
          message: "Share link has been copied to clipboard.",
        );
      }
    }
  }

  void _handleTrailerTap(BuildContext context) {
    HapticFeedback.lightImpact();

    if (trailers != null && trailers!.isNotEmpty) {
      showCupertinoModalBottomSheet(
        context: context,
        barrierColor: CupertinoColors.black.withValues(alpha: 0.75),
        builder: (_) => TrailerSheet(trailers!),
      );
    } else if (trailer != null && trailer!.isNotEmpty) {
      Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute(
          builder: (_) => TrailerPage(
            trailerURL: trailer!,
          ),
        ),
      );
    }
  }

  void _handleRecommendationsTap(BuildContext context) {
    HapticFeedback.lightImpact();
    onRecommendationsTap();
  }

  bool get _hasTrailers =>
      (trailers != null && trailers!.isNotEmpty) ||
      (trailer != null && trailer!.isNotEmpty);

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
    Color? iconColor,
  }) {
    return Tooltip(
      message: tooltip,
      preferBelow: true,
      verticalOffset: 20,
      decoration: BoxDecoration(
        color: CupertinoColors.black.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        color: CupertinoColors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      largeTitle: AutoSizeText(
        title,
        style: const TextStyle(fontSize: 18),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: !isItemNull
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Share Button
                _buildActionButton(
                  icon: FontAwesomeIcons.share,
                  onTap: () => _handleShareTap(context),
                  tooltip: "Share this content",
                ),
                // Trailer Button (only if trailers exist)
                if (_hasTrailers)
                  _buildActionButton(
                    icon: FontAwesomeIcons.youtube,
                    iconColor: CupertinoColors.systemRed,
                    onTap: () => _handleTrailerTap(context),
                    tooltip: "Watch trailers",
                  ),
                // Recommendations Button
                _buildActionButton(
                  icon: FontAwesomeIcons.solidLightbulb,
                  iconColor: CupertinoColors.systemYellow,
                  onTap: () => _handleRecommendationsTap(context),
                  tooltip: "View recommendations",
                ),
              ],
            )
          : null,
    );
  }
}
