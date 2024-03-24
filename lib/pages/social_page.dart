import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/pages/main/profile/custom_list_social_list_page.dart';
import 'package:watchlistfy/pages/main/profile/profile_display_page.dart';
import 'package:watchlistfy/pages/main/review/review_social_list_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/social/social_provider.dart';
import 'package:watchlistfy/providers/main/social/social_tab_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';
import 'package:watchlistfy/widgets/common/see_all_title.dart';
import 'package:watchlistfy/widgets/main/common/author_image.dart';
import 'package:watchlistfy/widgets/main/social/social_custom_list_cell.dart';
import 'package:watchlistfy/widgets/main/social/social_custom_lists_loading.dart';
import 'package:watchlistfy/widgets/main/social/social_leaderboard_loading.dart';
import 'package:watchlistfy/widgets/main/social/social_review_cell.dart';
import 'package:watchlistfy/widgets/main/social/social_review_loading.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  bool isInit = false;

  late final AuthenticationProvider authenticationProvider;
  late final SocialProvider _provider;
  late final SocialTabProvider _tabProvider;
  late final ScrollController _scrollController;

  final List<String> socialTabs = [
    "🗂️ Lists",
    "💬 Reviews",
    "💡 Recommendations",
    "🏆 Leaderboard",
  ];

  final List<GlobalKey> socialTabKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  @override
  void initState() {
    super.initState();
    _provider = SocialProvider();
    _tabProvider = SocialTabProvider();
  }

  @override
  void didChangeDependencies() {
    if (!isInit) {
      authenticationProvider = Provider.of<AuthenticationProvider>(context);
      _scrollController = ScrollController();
      _provider.getSocial();

      isInit = true;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Socials"),
        backgroundColor: CupertinoTheme.of(context).bgColor,
        brightness: CupertinoTheme.of(context).brightness,
      ),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => _provider),
          ChangeNotifierProvider(create: (_) => _tabProvider),
        ],
        child: Consumer2<SocialProvider, SocialTabProvider>(
          builder: (context, provider, tabProvider, _) {
            return RefreshIndicator(
              backgroundColor: CupertinoTheme.of(context).bgTextColor,
              color: CupertinoTheme.of(context).bgColor,
              onRefresh: () async {
                if (_provider.networkState == NetworkState.success || _provider.networkState == NetworkState.error) {
                  await _provider.getSocial();
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          children: List.generate(
                            socialTabs.length, (index) {
                              return CupertinoChip(
                                key: socialTabKeys[index],
                                isSelected: index == tabProvider.selectedIndex,
                                onSelected: (_) {
                                  tabProvider.setNewIndex(index);
                                  if (_scrollController.hasClients && socialTabKeys[index].currentContext != null) {
                                    Scrollable.ensureVisible(socialTabKeys[index].currentContext!);
                                  }
                                },
                                label: socialTabs[index],
                              );
                            }
                          ),
                        ),
                      ),
                    ),
                    SeeAllTitle("🗂️ Popular Lists", () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(builder: (_) {
                          return const CustomListSocialListPage();
                        })
                      );
                    }),
                    SizedBox(
                      height: 175,
                      child: provider.networkState == NetworkState.success
                      ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.item?.customList.isNotEmpty == true ? provider.item?.customList.length : 1,
                        itemExtent: 300,
                        itemBuilder: (context, index) {
                          if (provider.item?.customList.isEmpty == true) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Text("Nothing here."),
                              ),
                            );
                          }
                          return SocialCustomListCell(index, provider.item!.customList[index]);
                        }
                      )
                      : const SocialCustomListsLoading(),
                    ),
                    const SizedBox(height: 16),
                    SeeAllTitle("💬 Popular Reviews", () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(builder: (_) {
                          return const ReviewSocialListPage();
                        })
                      );
                    }),
                    SizedBox(
                      height: 200,
                      child: provider.networkState == NetworkState.success
                      ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.item?.reviews.length,
                        itemExtent: 300,
                        itemBuilder: (context, index) {
                          return SocialReviewCell(index, provider.item!.reviews[index], _provider.likeReview);
                        }
                      )
                      : const SocialReviewLoading(),
                    ),
                    const SizedBox(height: 16),
                    SeeAllTitle("🏆 Leaderboard", () {}, shouldHideSeeAllButton: true),
                    provider.networkState == NetworkState.success
                    ? ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: provider.item?.leaderboard.length,
                      itemBuilder: (context, index) {
                        final userInfo = provider.item!.leaderboard[index];

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute(builder: (_) {
                                return ProfileDisplayPage(userInfo.username);
                              })
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 25,
                                  child: Text(
                                    index == 0
                                    ? "🥇"
                                    : index == 1
                                      ? "🥈"
                                      : index == 2
                                        ? "🥉"
                                        : "${index + 1}",
                                    style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Stack(
                                  children: [
                                    AuthorImage(userInfo.image ?? '', size: 40),
                                    if (userInfo.isPremium)
                                    Positioned(
                                      bottom: -6,
                                      right: -6,
                                      child: Lottie.asset(
                                        "assets/lottie/premium.json",
                                        height: 30,
                                        width: 30,
                                        frameRate: FrameRate(60)
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AutoSizeText(
                                    userInfo.username.split("@")[0], //TODO Remove later?
                                    minFontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "${userInfo.level} Lvl",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors().primaryColor
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 3)
                              ],
                            ),
                          ),
                        );
                      }
                    )
                    : const SocialLeaderboardLoading(),
                    const SizedBox(height: 16)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
