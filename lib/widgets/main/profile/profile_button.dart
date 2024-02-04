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
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Icon(icon, color: AppColors().primaryColor, size: 20),
                )
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors().primaryColor,
                  fontWeight: FontWeight.bold
                ),
              ),
              //TODO Remove later after other button implemented
              const SizedBox(width: 20,)
            ],
          ),
        ),
      ),
    );
  }
}