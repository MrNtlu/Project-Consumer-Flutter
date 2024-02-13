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

    return CupertinoContextMenu(
      enableHapticFeedback: true,
      actions: [
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(builder: (_) {
                return const ProfilePage();
              })
            );
          },
          trailingIcon: CupertinoIcons.profile_circled,
          child: const Text('Profile'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(builder: (_) {
                return const CustomListPage();
              })
            );
          },
          trailingIcon: CupertinoIcons.folder_fill,
          child: const Text('Custom Lists'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(builder: (_) {
                return const UserListPage();
              })
            );
          },
          trailingIcon: CupertinoIcons.list_bullet_below_rectangle,
          child: const Text('User List'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(builder: (_) {
                return const ConsumeLaterPage();
              })
            );
          },
          trailingIcon: CupertinoIcons.time,
          child: const Text('Watch Later'),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(builder: (_) {
              return const ProfilePage();
            })
          );
        },
        child: ColoredBox(
          color: CupertinoTheme.of(context).bgColor,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
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
                const SizedBox(width: 8),
                Text(
                  authenticationProvider.basicUserInfo?.username ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
