import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';

class DetailsTitle extends StatelessWidget {
  final String title;

  const DetailsTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors().primaryColor,
        )
      ),
    );
  }
}