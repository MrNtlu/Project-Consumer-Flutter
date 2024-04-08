import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watchlistfy/pages/main/profile/profile_stats_page.dart';
import 'package:watchlistfy/static/colors.dart';

class ProfileFullWidthButton extends StatelessWidget {
  const ProfileFullWidthButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: CupertinoButton(
        color: CupertinoTheme.of(context).profileButton,
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(builder: (_) {
              return const ProfileStatsPage();
            })
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: FaIcon(FontAwesomeIcons.chartLine, color: AppColors().primaryColor, size: 20),
                )
              ),
              Text(
                "Detailed Statistics",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors().primaryColor,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}