import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/auth/basic_user_info.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/main/settings/offers_sheet.dart';

class UserCountSheet extends StatelessWidget {
  final BasicUserInfo _userInfo;

  const UserCountSheet(this._userInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        padding: const EdgeInsets.all(16),
        color: CupertinoTheme.of(context).bgColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "📋 User List Usage",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  _userInfo.userListCount.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: AppColors().primaryColor,
                  ),
                ),
                SizedBox(
                  width: 35,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      " /${_userInfo.isPremium ? '∞' : '175'}",
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey2,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  "🕒 Watch Later Usage",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  _userInfo.consumeLaterCount.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: AppColors().primaryColor,
                  ),
                ),
                SizedBox(
                  width: 35,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      " /${_userInfo.isPremium ? '∞' : '50'}",
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey2,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
              ],
            ),
            if (!_userInfo.isPremium)
            const SizedBox(height: 32),
            if (!_userInfo.isPremium)
            Center(
              child: CupertinoButton(
                child: const Text(
                  "Join now and get unlimited access!",
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(builder: (_) {
                      return const OffersSheet();
                    })
                  );
                }
              ),
            )
          ],
        ),
      )
    );
  }
}