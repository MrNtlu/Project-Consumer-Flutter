import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';

class ProfileButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  const ProfileButton(this.label, this.onPressed, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CupertinoButton(
        color: CupertinoTheme.of(context).profileButton,
        padding: EdgeInsets.zero, 
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: AppColors().primaryColor, size: 20),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors().primaryColor,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}