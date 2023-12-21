import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';

class DetailsCommonList extends StatelessWidget {
  final bool isAvatar;
  final int listCount;
  final IconData placeHolderIcon;
  final String? Function(int) getImage;
  final String Function(int) getName;
  final String Function(int)? getCharacter;

  const DetailsCommonList(
    this.isAvatar, this.listCount, this.getImage,
    this.getName, this.getCharacter, {this.placeHolderIcon = Icons.person, super.key}
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listCount,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {    
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 100,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                getImage(index) != null
                ? (isAvatar
                  ? CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(
                      getImage(index)!,
                    ),
                  )
                  : Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Image.network(
                      getImage(index)!,
                      height: 64,
                    ),
                  )
                )
                : Container(
                  decoration: BoxDecoration(
                    color: CupertinoTheme.of(context).onBgColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    placeHolderIcon, 
                    size: 64, 
                    color: CupertinoTheme.of(context).bgTextColor
                  ),
                ),
                const SizedBox(height: 6),
                AutoSizeText(
                  getName(index),
                  maxLines: isAvatar ? 1 : 2,
                  maxFontSize: 16,
                  minFontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                if (getCharacter != null)
                  AutoSizeText(
                    getCharacter!(index),
                    maxLines: 1,
                    maxFontSize: 14,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  )
              ],
            ),
          ),
        );
      }
    );
  }
}