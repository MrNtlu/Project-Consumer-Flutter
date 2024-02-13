import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:watchlistfy/models/main/review/author.dart';
import 'package:watchlistfy/widgets/main/common/author_image.dart';

class AuthorInfoRow extends StatelessWidget {
  final Author author;
  final double size;
  const AuthorInfoRow(this.author, {this.size = 35, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            AuthorImage(author.image, size: size),
            if (author.isPremium && size > 30)
            Positioned(
              bottom: -6,
              right: -6,
              child: Lottie.asset(
                "assets/lottie/premium.json",
                height: size * 0.8,
                width: size * 0.8,
                frameRate: FrameRate(60)
              ),
            ),
          ],
        ),
        const SizedBox(width: 6),
        Flexible(
          child: AutoSizeText(
            author.username,
            minFontSize: 13,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(width: 6),
      ],
    );
  }
}