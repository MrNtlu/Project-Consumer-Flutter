import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class DetailsCharacterList extends StatelessWidget {
  final int listCount;
  final String? Function(int) getImage;
  final String Function(int) getName;
  final String Function(int)? getCharacter;

  const DetailsCharacterList(this.listCount, this.getImage, this.getName, this.getCharacter, {super.key});

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
                ? CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(getImage(index)!),
                )
                : const Icon(Icons.person, size: 32,),
                const SizedBox(height: 6),
                AutoSizeText(
                  getName(index),
                  maxLines: 1,
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