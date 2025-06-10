import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/userlist/user_list_content.dart';
import 'package:watchlistfy/pages/details_page.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/providers/main/profile/user_list_content_selection_provider.dart';
import 'package:watchlistfy/providers/main/profile/user_list_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/static/refresh_rate_helper.dart';
import 'package:watchlistfy/widgets/main/profile/user_list_compact.dart';
import 'package:watchlistfy/widgets/main/profile/user_list_expanded.dart';
import 'package:watchlistfy/widgets/main/profile/user_list_shimmer_cell.dart';

class UserListListView extends StatelessWidget {
  final bool isEmpty;
  final int? length;
  final List<UserListContent> dataList;
  final UserListContentSelectionProvider provider;
  final UserListProvider userListProvider;
  final GlobalProvider globalProvider;
  final Function(UserListContent) updateData;

  const UserListListView(
    this.isEmpty,
    this.length,
    this.dataList,
    this.provider,
    this.userListProvider,
    this.globalProvider,
    this.updateData, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height * 0.5;

    return ListView.builder(
      itemCount: provider.isSearching
          ? (isEmpty ? 1 : provider.searchList.length)
          : (isEmpty ? 1 : length),
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
                    height: height,
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

        final UserListContent data = dataList[index];

        return Padding(
          padding:
              globalProvider.userListMode == Constants.UserListUIModes.first
                  ? const EdgeInsets.only(
                      left: 6,
                      right: 3,
                      top: 4,
                      bottom: 4,
                    )
                  : const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 2,
                    ),
          child: data.isLoading
              ? UserListShimmerCell(data.title, provider.selectedContent,
                  data.totalSeasons, data.totalEpisodes)
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(
                        builder: (_) {
                          final contentType = ContentType.values
                              .where(
                                (element) =>
                                    element.request ==
                                    provider.selectedContent.request,
                              )
                              .first;
                          return DetailsPage(
                            id: data.contentID,
                            contentType: contentType,
                          );
                        },
                      ),
                    ).then(
                      (value) => updateData(data),
                    );
                  },
                  child: globalProvider.userListMode ==
                          Constants.UserListUIModes.first
                      ? UserListExpanded(
                          data,
                          provider,
                          userListProvider,
                          index,
                          updateData,
                        )
                      : UserListCompact(
                          data,
                          provider,
                          userListProvider,
                          index,
                          updateData,
                        ),
                ),
        );
      },
    );
  }
}
