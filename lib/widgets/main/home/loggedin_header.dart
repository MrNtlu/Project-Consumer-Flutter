import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/pages/main/ai/ai_recommendation_page.dart';
import 'package:watchlistfy/pages/main/profile/consume_later_page.dart';
import 'package:watchlistfy/pages/main/profile/custom_list_page.dart';
import 'package:watchlistfy/pages/main/profile/profile_page.dart';
import 'package:watchlistfy/pages/main/profile/profile_stats_page.dart';
import 'package:watchlistfy/pages/main/profile/user_list_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/static/colors.dart';

class LoggedinHeader extends StatelessWidget {
  const LoggedinHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthenticationProvider>(context);
    final image = authenticationProvider.basicUserInfo?.image;
    final streak = authenticationProvider.basicUserInfo?.streak;
    final isUrlValid = image != null && Uri.tryParse(image) != null;

    return Row(
      children: [
        PopupMenuButton(
          icon: const Icon(CupertinoIcons.ellipsis_vertical),
          iconSize: 26,
          color: CupertinoTheme.of(context).bgColor,
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(builder: (_) {
                    return const CustomListPage();
                  })
                );
              },
              child: Row(
                children: [
                  Text("Custom Lists", style: TextStyle(color: CupertinoTheme.of(context).bgTextColor)),
                  const Spacer(),
                  Icon(CupertinoIcons.folder_fill, color: CupertinoTheme.of(context).bgTextColor, size: 18),
                ],
              )
            ),
            PopupMenuItem(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(builder: (_) {
                    return const UserListPage();
                  })
                );
              },
              child: Row(
                children: [
                  Text("User List", style: TextStyle(color: CupertinoTheme.of(context).bgTextColor)),
                  const Spacer(),
                  Icon(CupertinoIcons.list_bullet_below_rectangle, color: CupertinoTheme.of(context).bgTextColor, size: 18),
                ],
              )
            ),
            PopupMenuItem(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(builder: (_) {
                    return const ConsumeLaterPage();
                  })
                );
              },
              child: Row(
                children: [
                  Text("Watch Later", style: TextStyle(color: CupertinoTheme.of(context).bgTextColor)),
                  const Spacer(),
                  Icon(CupertinoIcons.time, color: CupertinoTheme.of(context).bgTextColor, size: 18),
                ],
              )
            ),
            PopupMenuItem(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(builder: (_) {
                    return const ProfileStatsPage();
                  }
                ));
              },
              child: Row(
                children: [
                  Text("Statistics", style: TextStyle(color: CupertinoTheme.of(context).bgTextColor)),
                  const Spacer(),
                  Icon(CupertinoIcons.chart_bar_alt_fill, color: CupertinoTheme.of(context).bgTextColor, size: 18),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute(builder: (_) {
                    return const AIRecommendationPage();
                  })
                );
              },
              child: Row(
                children: [
                  Text("AI Recommendations", style: TextStyle(color: CupertinoTheme.of(context).bgTextColor)),
                  const Spacer(),
                  Icon(FontAwesomeIcons.robot, color: CupertinoTheme.of(context).bgTextColor, size: 18),
                ],
              )
            ),
          ]
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(builder: (_) {
                return const ProfilePage();
              })
            );
          },
          child: SizedBox(
            height: 32,
            width: 32,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoTheme.brightnessOf(context) == Brightness.dark ? CupertinoColors.systemGrey.withOpacity(0.35) : CupertinoColors.black.withOpacity(0.35),
                    spreadRadius: 1.35,
                    blurRadius: 3,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: isUrlValid
                ? CachedNetworkImage(
                  imageUrl: authenticationProvider.basicUserInfo!.image!,
                  height: 30,
                  width: 30,
                  cacheKey: authenticationProvider.basicUserInfo!.image!,
                  key: ValueKey<String>(authenticationProvider.basicUserInfo!.image!),
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (_, __, ___) =>
                    const Padding(padding: EdgeInsets.all(3), child: CupertinoActivityIndicator()),
                  errorListener: (_) {},
                  errorWidget: (context, url, error) => const Icon(
                    Icons.person,
                    size: 30,
                    color: CupertinoColors.activeBlue,
                  ),
                )
                : const Icon(
                  Icons.person,
                  size: 30,
                  color: CupertinoColors.activeBlue,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 6),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(builder: (_) {
                  return const ProfilePage();
                })
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(FontAwesomeIcons.fire, size: 14),
                const SizedBox(width: 4),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 65),
                  child: AutoSizeText(
                    streak.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                    minFontSize: 11,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
