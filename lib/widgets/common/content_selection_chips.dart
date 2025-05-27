import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';

class ContentSelectionChips extends StatelessWidget {
  const ContentSelectionChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ContentProvider>(builder: (context, contentProvider, _) {
      return SizedBox(
        height: 45,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(ContentType.values.length, (index) {
            return Padding(
              padding: EdgeInsets.only(left: index == 0 ? 9 : 3, right: 3),
              child: SizedBox(
                width: 100,
                child: CupertinoChip(
                  isSelected: ContentType.values[index] ==
                      contentProvider.selectedContent,
                  size: 14,
                  cornerRadius: 8,
                  selectedBGColor: CupertinoTheme.of(context).profileButton,
                  selectedTextColor: AppColors().primaryColor,
                  onSelected: (_) {
                    contentProvider.setContentType(
                      ContentType.values[index],
                    );
                  },
                  label: ContentType.values[index].value,
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
