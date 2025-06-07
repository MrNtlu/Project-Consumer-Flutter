import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/common/trailer.dart';
import 'package:watchlistfy/pages/main/trailer_page.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';
import 'package:watchlistfy/widgets/common/trailer_sheet.dart';
import 'package:watchlistfy/widgets/main/common/details_avatar_button.dart';

class DetailsButtonRow extends StatelessWidget {
  final String title;
  final bool isAuthenticated;
  final List<Trailer>? trailers;
  final String? trailer;
  final String contentType;
  final String id;
  final VoidCallback onRecommendationsPressed;

  const DetailsButtonRow(
    this.title,
    this.isAuthenticated,
    this.trailers,
    this.contentType,
    this.id,
    this.onRecommendationsPressed, {
    this.trailer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: width - 24,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            DetailsAvatarButton(
                "Share", FontAwesomeIcons.share, CupertinoColors.activeBlue,
                () async {
              final url = '${Constants.BASE_DOMAIN_URL}/$contentType/$id';
              try {
                final box = context.findRenderObject() as RenderBox?;

                if (box != null) {
                  Share.share(url,
                      subject:
                          'Share ${ContentType.values.where((element) => contentType == element.request).first.value}',
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                }
              } catch (_) {
                await Clipboard.setData(ClipboardData(text: url));
                if (context.mounted) {
                  showCupertinoDialog(
                      context: context,
                      builder: (_) =>
                          const MessageDialog("Copied to clipboard."));
                }
              }
            }),
            if ((trailers != null && trailers!.isNotEmpty) ||
                (trailer != null && trailer!.isNotEmpty))
              DetailsAvatarButton(
                "Trailers",
                FontAwesomeIcons.youtube,
                CupertinoColors.systemRed,
                () {
                  HapticFeedback.lightImpact();

                  if (trailers != null && trailers!.isNotEmpty) {
                    showCupertinoModalBottomSheet(
                        context: context,
                        barrierColor: CupertinoColors.black.withValues(
                          alpha: 0.75,
                        ),
                        builder: (_) => TrailerSheet(trailers!));
                  } else {
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(
                        builder: (_) {
                          return TrailerPage(trailerURL: trailer!);
                        },
                      ),
                    );
                  }
                },
              ),
            DetailsAvatarButton(
              "Recommends",
              FontAwesomeIcons.solidLightbulb,
              CupertinoColors.systemYellow,
              onRecommendationsPressed,
            ),
          ],
        ),
      ),
    );
  }
}
