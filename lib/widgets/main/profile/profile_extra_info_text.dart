import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';

class ProfileExtraInfoText extends StatelessWidget {
  final String value;
  final String extraValue;
  final String label;

  const ProfileExtraInfoText(this.value, this.extraValue, this.label,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final size = (mediaQuery.size.width * 0.85) / 4;

    return SizedBox(
      width: size,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: AutoSizeText(
                  value,
                  maxLines: 1,
                  minFontSize: 10,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: cupertinoTheme.bgTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 3),
              extraValue == "⭐"
                  ? Icon(Icons.star_rounded,
                      color: AppColors().primaryColor, size: 12)
                  : Text(
                      extraValue,
                      maxLines: 1,
                      style: TextStyle(
                        color: cupertinoTheme.bgTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            style: TextStyle(
              color: AppColors().primaryColor,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
