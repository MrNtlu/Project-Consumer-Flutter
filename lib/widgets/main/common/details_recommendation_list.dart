import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/navigation_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';

class DetailsRecommendationList extends StatelessWidget {
  final int itemCount;
  final String Function(int) getImage;
  final String Function(int) getTitle;
  final Widget Function(int) onTap;
  final bool isGame;

  const DetailsRecommendationList(
    this.itemCount,
    this.getImage,
    this.getTitle,
    this.onTap, {
    this.isGame = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);
    final appColors = AppColors();

    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemExtent: 140,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 8,
              right: index == itemCount - 1 ? 0 : 8,
            ),
            child: _buildRecommendationCard(
              context,
              index,
              cupertinoTheme,
              appColors,
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    int index,
    CupertinoThemeData theme,
    AppColors appColors,
  ) {
    return GestureDetector(
      onTap: () => _navigateToContent(context, index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: theme.onBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.bgTextColor.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      ContentCell(
                        getImage(index),
                        getTitle(index),
                        cornerRadius: 12,
                        cacheHeight: 425,
                        cacheWidth: 350,
                        forceRatio: isGame,
                      ),
                      // Subtle overlay for better text contrast
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 25,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                CupertinoColors.black.withValues(alpha: 0.2),
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getTitle(index).isNotEmpty ? getTitle(index) : "Unknown",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.bgTextColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToContent(BuildContext context, int index) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder: (_) => onTap(index),
        maintainState: NavigationTracker().shouldMaintainState(),
      ),
    );
  }
}
