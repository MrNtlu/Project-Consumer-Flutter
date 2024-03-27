import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:watchlistfy/widgets/common/custom_divider.dart';

class ProfileSubMenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ProfileSubMenuButton(
    this.label,
    this.icon,
    this.color,
    this.onTap,
    {super.key}
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 15,
                child: FaIcon(
                  icon,
                  size: 13,
                  color: CupertinoColors.white,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Icon(CupertinoIcons.chevron_right)
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 42, bottom: 6),
            child: CustomDivider(height: 0.5, opacity: 0.5),
          )
        ],
      ),
    );
  }
}