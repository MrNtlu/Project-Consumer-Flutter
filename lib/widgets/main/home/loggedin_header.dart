import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/pages/main/profile/consume_later_page.dart';
import 'package:watchlistfy/pages/main/profile/custom_list_page.dart';
import 'package:watchlistfy/pages/main/profile/profile_page.dart';
import 'package:watchlistfy/pages/main/profile/user_list_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/static/colors.dart';

class LoggedinHeader extends StatelessWidget {
  const LoggedinHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthenticationProvider>(context);
    final image = authenticationProvider.basicUserInfo?.image;
    final isUrlValid = image != null && Uri.tryParse(image) != null;

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute(builder: (_) {
            return const ProfilePage();
          })
        );
      },
      child: Row(
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
                      return const ProfilePage();
                    })
                  );
                },
                child: Row(
                  children: [
                    Text("Profile", style: TextStyle(color: CupertinoTheme.of(context).bgTextColor)),
                    const Spacer(),
                    Icon(CupertinoIcons.profile_circled, color: CupertinoTheme.of(context).bgTextColor, size: 18),
                  ],
                )
              ),
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
            ]
          ),
          SizedBox(
            height: 32,
            width: 32,
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
        ],
      ),
    );
  }
}
