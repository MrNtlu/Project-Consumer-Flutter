import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watchlistfy/static/colors.dart';

class ProfileAvatarButton extends StatelessWidget{
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const ProfileAvatarButton(
    this.label,
    this.icon,
    this.onTap,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 110,
      ),
      child: Center(
        child: CupertinoButton(
          onPressed: onTap,
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: AppColors().primaryColor,
                radius: 20,
                child: FaIcon(
                  icon,
                  size: 16,
                  color: CupertinoColors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors().primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}