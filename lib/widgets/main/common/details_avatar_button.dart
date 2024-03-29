import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watchlistfy/static/colors.dart';

class DetailsAvatarButton extends StatelessWidget{
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const DetailsAvatarButton(
    this.label,
    this.icon,
    this.iconColor,
    this.onTap,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 100,
      ),
      child: Center(
        child: CupertinoButton(
          onPressed: onTap,
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: iconColor,
                radius: 20,
                child: FaIcon(
                  icon,
                  size: 16,
                  color: CupertinoColors.white,
                ),
              ),
              const SizedBox(height: 8),
              AutoSizeText(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                minFontSize: 11,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: CupertinoTheme.of(context).bgTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}