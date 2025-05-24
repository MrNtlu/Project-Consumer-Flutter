import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';
import 'package:watchlistfy/static/constants.dart';

// ignore: must_be_immutable
class ProfileImageList extends StatelessWidget {
  int selectedIndex;

  ProfileImageList({
    this.selectedIndex = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> selectedIndexNotifier = ValueNotifier(selectedIndex);

    return SizedBox(
      height: 65,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Constants.ProfileImageList.length,
        itemBuilder: (context, index) {
          final image = Constants.ProfileImageList[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: GestureDetector(
              onTap: () {
                if (selectedIndexNotifier.value != index) {
                  selectedIndexNotifier.value = index;
                }
              },
              child: ValueListenableBuilder<int>(
                  valueListenable: selectedIndexNotifier,
                  builder: (context, value, child) {
                    final isSelected = value == index;

                    return CircleAvatar(
                      backgroundColor: CupertinoColors.systemBlue,
                      radius: isSelected ? 35 : 26,
                      child: Padding(
                        padding: EdgeInsets.all(isSelected ? 3 : 0),
                        child: CircleAvatar(
                          radius: isSelected ? 35 : 26,
                          backgroundImage: CachedNetworkImageProvider(
                            image,
                            cacheKey: image,
                            cacheManager: CustomCacheManager(),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          );
        },
      ),
    );
  }
}
