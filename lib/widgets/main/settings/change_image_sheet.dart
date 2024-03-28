import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/profile_image_list.dart';

class ChangeImageSheet extends StatelessWidget {
  final Function(String) changeImage;
  final String? currentImage;

  const ChangeImageSheet(
    this.changeImage,
    {
      this.currentImage,
      super.key
    }
  );

  @override
  Widget build(BuildContext context) {
    final imageList = ProfileImageList(
      selectedIndex: currentImage != null
      ? Constants.ProfileImageList.indexOf(currentImage!)
      : 0,
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            imageList,
            const SizedBox(height: 16),
            CupertinoButton.filled(
              child: const Text("Update Image", style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                if (imageList.selectedIndex >= 0) {
                  Navigator.pop(context);
                  changeImage(Constants.ProfileImageList[imageList.selectedIndex]);
                }
              }
            )
          ],
        ),
      )
      );
  }
}