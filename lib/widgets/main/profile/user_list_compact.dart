import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/common/request/id_body.dart';
import 'package:watchlistfy/models/main/userlist/request/increment_tv_list_body.dart';
import 'package:watchlistfy/models/main/userlist/user_list_content.dart';
import 'package:watchlistfy/pages/details_page.dart';
import 'package:watchlistfy/providers/main/profile/user_list_content_selection_provider.dart';
import 'package:watchlistfy/providers/main/profile/user_list_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/main/profile/user_list_action_sheet.dart';

class UserListCompact extends StatelessWidget {
  final UserListContent data;
  final UserListProvider userListProvider;
  final UserListContentSelectionProvider provider;
  final int index;
  final Function(UserListContent) _updateData;

  const UserListCompact(this.data, this.provider, this.userListProvider,
      this.index, this._updateData,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 3),
      child: Row(
        children: [
          SizedBox(
            width: 2,
            height: 75,
            child: ColoredBox(
              color: data.status == Constants.UserListStatus[0].request
                  ? Colors.green.shade600
                  : data.status == Constants.UserListStatus[1].request
                      ? CupertinoColors.activeBlue
                      : CupertinoColors.systemRed,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 75,
            child: ContentCell(
              data.imageUrl?.replaceFirst("original", "w300") ?? '',
              data.title.isEmpty ? data.titleOriginal : data.title,
              cornerRadius: 8,
              forceRatio: true,
              cacheHeight: 250,
              cacheWidth: 150,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: AutoSizeText(
                          data.title.isEmpty ? data.titleOriginal : data.title,
                          minFontSize: 14,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          wrapWords: true,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      userListProvider.isLoading
                          ? const CupertinoActivityIndicator()
                          : CupertinoButton(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              minSize: 0,
                              child: const Icon(
                                  CupertinoIcons.ellipsis_vertical,
                                  size: 18),
                              onPressed: () {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) {
                                    return UserListActionSheet(
                                      index,
                                      data.id,
                                      data.title.isEmpty
                                          ? data.titleOriginal
                                          : data.title,
                                      provider.selectedContent,
                                      data,
                                      userListProvider,
                                      () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .push(
                                          CupertinoPageRoute(
                                            builder: (_) {
                                              final contentType =
                                                  ContentType.values
                                                      .where(
                                                        (element) =>
                                                            element.request ==
                                                            provider
                                                                .selectedContent
                                                                .request,
                                                      )
                                                      .first;
                                              return DetailsPage(
                                                id: data.contentID,
                                                contentType: contentType,
                                              );
                                            },
                                          ),
                                        ).then(
                                          (value) => _updateData(data),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.star_fill,
                        color: CupertinoColors.systemYellow,
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        data.score?.toString() ?? "*",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        Constants.UserListStatus.where(
                                (element) => data.status == element.request)
                            .first
                            .name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (data.status == Constants.UserListStatus[0].request &&
                          provider.selectedContent == ContentType.tv &&
                          !userListProvider.isLoading)
                        CupertinoButton(
                          onPressed: () {
                            userListProvider.incrementUserList(
                              index,
                              IncrementTVListBody(data.id, false),
                              ContentType.tv,
                            );
                          },
                          padding: EdgeInsets.zero,
                          minSize: 16,
                          child: Icon(
                            CupertinoIcons.add_circled_solid,
                            color: AppColors().primaryColor,
                            size: 16,
                          ),
                        ),
                      if (data.status == Constants.UserListStatus[0].request &&
                          provider.selectedContent == ContentType.tv &&
                          !userListProvider.isLoading)
                        const SizedBox(width: 6),
                      if (provider.selectedContent == ContentType.tv)
                        Text(
                          data.watchedSeasons?.toString() ?? "?",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      if (provider.selectedContent == ContentType.tv)
                        Text("/${data.totalSeasons ?? "?"} seas"),
                      const Spacer(),
                      if (data.status == Constants.UserListStatus[0].request &&
                          provider.selectedContent != ContentType.movie &&
                          !userListProvider.isLoading)
                        CupertinoButton(
                          onPressed: () {
                            switch (provider.selectedContent) {
                              case ContentType.tv:
                                userListProvider.incrementUserList(
                                  index,
                                  IncrementTVListBody(data.id, true),
                                  ContentType.tv,
                                );
                                break;
                              default:
                                userListProvider.incrementUserList(
                                  index,
                                  IDBody(data.id),
                                  provider.selectedContent,
                                );
                            }
                          },
                          padding: EdgeInsets.zero,
                          minSize: 16,
                          child: Icon(
                            CupertinoIcons.add_circled_solid,
                            color: AppColors().primaryColor,
                            size: 16,
                          ),
                        ),
                      if (data.status == Constants.UserListStatus[0].request &&
                          provider.selectedContent != ContentType.movie &&
                          !userListProvider.isLoading)
                        const SizedBox(width: 6),
                      if (provider.selectedContent != ContentType.movie)
                        Text(
                          data.watchedEpisodes?.toString() ?? "?",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      if (provider.selectedContent != ContentType.movie &&
                          provider.selectedContent != ContentType.game)
                        Text("/${data.totalEpisodes ?? "?"} eps"),
                      if (provider.selectedContent == ContentType.game)
                        const Text(' hrs')
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
