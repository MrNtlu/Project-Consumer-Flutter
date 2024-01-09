import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';

class ProfileUserImage extends StatelessWidget {
  final String? image;

  const ProfileUserImage(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    final isUrlValid = image != null && Uri.tryParse(image!) != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(37.5),
        child: isUrlValid
        ? Image.network(
          image!,
          height: 75,
          width: 75,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Padding(padding: const EdgeInsets.all(3), child: CircularProgressIndicator(color: AppColors().primaryColor));
          },
        )
        : const Icon(
          Icons.person,
          size: 50,
          color: CupertinoColors.activeBlue,
        ),
      ),
    );
  }
}