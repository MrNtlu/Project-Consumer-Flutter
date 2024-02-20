import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:watchlistfy/static/purchase_api.dart';

class ProfileUserImage extends StatelessWidget {
  final String? image;
  final bool isProfileDisplay;

  const ProfileUserImage(this.image, {this.isProfileDisplay = false, super.key});

  @override
  Widget build(BuildContext context) {
    final isUrlValid = image != null && Uri.tryParse(image!) != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Stack(
        children: [
          SizedBox(
            height: 75,
            width: 75,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(37.5),
              child: isUrlValid
              ? CachedNetworkImage(
                imageUrl: image!,
                key: ValueKey<String>(image!),
                cacheKey: image,
                height: 75,
                width: 75,
                maxHeightDiskCache: 200,
                maxWidthDiskCache: 200,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (_, __, ___) =>
                  const Padding(padding: EdgeInsets.all(3), child: CupertinoActivityIndicator()),
                errorListener: (_) {},
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
          if (PurchaseApi().userInfo?.isPremium == true && !isProfileDisplay)
          Positioned(
            bottom: -6,
            right: -6,
            child: Lottie.asset(
              "assets/lottie/premium.json",
              height: 36,
              width: 36,
              frameRate: FrameRate(60)
            ),
          ),
        ],
      ),
    );
  }
}