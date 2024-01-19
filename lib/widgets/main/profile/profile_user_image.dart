import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileUserImage extends StatelessWidget {
  final String? image;

  const ProfileUserImage(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    final isUrlValid = image != null && Uri.tryParse(image!) != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 75,
        width: 75,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(37.5),
          child: isUrlValid
          ? CachedNetworkImage(
            imageUrl: image!,
            key: ValueKey<String>(image!),
            height: 75,
            width: 75,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (_, __, ___) =>
              const Padding(padding: EdgeInsets.all(3), child: CupertinoActivityIndicator()),
            errorWidget: (context, url, error) => const Icon(
              Icons.person,
              size: 50,
              color: CupertinoColors.activeBlue,
            ),
          )
          : const Icon(
            Icons.person,
            size: 50,
            color: CupertinoColors.activeBlue,
          ),
        ),
      ),
    );
  }
}