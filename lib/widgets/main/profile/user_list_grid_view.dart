import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/userlist/user_list_content.dart';
import 'package:watchlistfy/pages/details_page.dart';
import 'package:watchlistfy/providers/main/profile/user_list_content_selection_provider.dart';
import 'package:watchlistfy/static/refresh_rate_helper.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';

class UserListGridView extends StatelessWidget {
  final bool isEmpty;
  final int? length;
  final List<UserListContent> dataList;
  final UserListContentSelectionProvider provider;

  const UserListGridView(
      this.isEmpty, this.length, this.dataList, this.provider,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: GridView.builder(
        itemCount: provider.isSearching
            ? (isEmpty ? 1 : provider.searchList.length)
            : (isEmpty ? 1 : length),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 350,
            childAspectRatio:
                provider.selectedContent != ContentType.game ? 2 / 3 : 16 / 9,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6),
        itemBuilder: (context, index) {
          if (isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      "assets/lottie/empty.json",
                      height: height * 0.5,
                      frameRate: FrameRate(
                        RefreshRateHelper().getRefreshRate(),
                      ),
                    ),
                    const Text(
                      "Nothing here.",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final content = dataList[index];

          return GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .push(CupertinoPageRoute(
                builder: (_) {
                  final contentType = ContentType.values
                      .where((element) =>
                          element.request == provider.selectedContent.request)
                      .first;
                  return DetailsPage(
                    id: content.contentID,
                    contentType: contentType,
                  );
                },
              ));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
              child: ContentCell(
                content.imageUrl?.replaceFirst("original", "w300") ?? '',
                content.title.isEmpty ? content.titleOriginal : content.title,
                cacheWidth: 500,
                cacheHeight: 700,
              ),
            ),
          );
        },
      ),
    );
  }
}
