import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/constants.dart';

// ignore: must_be_immutable
class ProfileImageList extends StatefulWidget {
  int selectedIndex = 0;

  ProfileImageList({selectedIndex, super.key});

  @override
  State<ProfileImageList> createState() => _ProfileImageListState();
}

class _ProfileImageListState extends State<ProfileImageList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Constants.ProfileImageList.length,
        itemBuilder: (context, index) {
          final image = Constants.ProfileImageList[index];
          final isSelected = widget.selectedIndex == index;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: GestureDetector(
              onTap: () {
                if (widget.selectedIndex != index) {
                  setState(() {
                    widget.selectedIndex = index;
                  });
                }
              },
              child: CircleAvatar(
                backgroundColor: CupertinoColors.systemBlue,
                radius: isSelected ? 35 : 26,
                child: Padding(
                  padding: EdgeInsets.all(isSelected ? 3 : 0),
                  child: CircleAvatar(
                    radius: isSelected ? 35 : 26,
                    backgroundImage: NetworkImage(image),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
