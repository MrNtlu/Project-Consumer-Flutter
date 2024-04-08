import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:watchlistfy/models/auth/basic_user_info.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/main/common/author_image.dart';
import 'package:watchlistfy/widgets/main/settings/change_image_sheet.dart';

class SettingsProfile extends StatelessWidget {
  final BasicUserInfo _userInfo;
  final Function(String) _changeImage;
  const SettingsProfile(this._userInfo, this._changeImage, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AuthorImage(_userInfo.image ?? '', size: 55),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CupertinoButton(
                      minSize: 0,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        showCupertinoModalBottomSheet(
                          context: context,
                          barrierColor: CupertinoColors.black.withOpacity(0.75),
                          builder: (_) {

                            return ChangeImageSheet(
                              currentImage: _userInfo.image,
                              _changeImage,
                            );
                          }
                        );
                      },
                      child: CircleAvatar(
                        radius: 11,
                        backgroundColor: AppColors().primaryColor,
                        child: const Icon(Icons.edit, size: 14, color: CupertinoColors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: AutoSizeText(
                        _userInfo.username,
                        minFontSize: 14,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        _userInfo.email,
                        style: TextStyle(
                          color: CupertinoTheme.brightnessOf(context) == Brightness.dark
                          ? CupertinoColors.systemGrey2
                          : CupertinoColors.systemGrey
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_userInfo.isPremium)
              Lottie.asset(
                "assets/lottie/premium.json",
                height: 36,
                width: 36,
                frameRate: FrameRate(60)
              ),
            ],
          ),
        ),
      ),
    );
  }
}