import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/pages/main/profile/consume_later_page.dart';
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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: isUrlValid
                  ? Image.network(
                    authenticationProvider.basicUserInfo!.image!,
                    height: 30,
                    width: 30,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Padding(padding: const EdgeInsets.all(3), child: CircularProgressIndicator(color: AppColors().primaryColor));
                    },
                  )
                  : const Icon(
                    Icons.person,
                    size: 30,
                    color: CupertinoColors.activeBlue,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  authenticationProvider.basicUserInfo?.username ?? '',
                  style: const TextStyle(
                    fontSize: 14,
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
