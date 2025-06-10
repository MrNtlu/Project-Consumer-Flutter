import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/refresh_rate_helper.dart';
import 'package:watchlistfy/widgets/main/settings/offers_sheet.dart';

class SettingsPremiumPromo extends StatelessWidget {
  const SettingsPremiumPromo({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;

    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute(
                builder: (_) {
                  return const OffersSheet();
                },
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: CupertinoTheme.of(context).onBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors().primaryColor,
                width: 1.25,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: Row(
              children: [
                Lottie.asset(
                  "assets/lottie/premium.json",
                  height: 52,
                  width: 52,
                  frameRate: FrameRate(
                    RefreshRateHelper().getRefreshRate(),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Join Premium Now!",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors().primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Become a premium member and unlock the full potential!",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                            color: CupertinoTheme.brightnessOf(context) ==
                                    Brightness.dark
                                ? CupertinoColors.systemGrey2
                                : CupertinoColors.systemGrey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  CupertinoIcons.chevron_right,
                  color: AppColors().primaryColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
