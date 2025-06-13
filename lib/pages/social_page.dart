import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/pages/main/profile/custom_list_social_list_page.dart';
import 'package:watchlistfy/pages/main/profile/profile_display_page.dart';
import 'package:watchlistfy/pages/main/recommendation/recommendation_social_list_page.dart';
import 'package:watchlistfy/pages/main/review/review_social_list_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/social/social_provider.dart';
import 'package:watchlistfy/providers/main/social/social_tab_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/refresh_rate_helper.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';
import 'package:watchlistfy/widgets/main/common/author_image.dart';
import 'package:watchlistfy/widgets/main/social/social_custom_list_cell.dart';
import 'package:watchlistfy/widgets/main/social/social_custom_lists_loading.dart';
import 'package:watchlistfy/widgets/main/social/social_leaderboard_loading.dart';
import 'package:watchlistfy/widgets/main/social/social_recommendation_cell.dart';
import 'package:watchlistfy/widgets/main/social/social_recommendation_loading.dart';
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
  late final CupertinoThemeData cupertinoTheme;

  final List<String> socialTabs = [
    "💬 Reviews",
    "🗂️ Lists",
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
      cupertinoTheme = CupertinoTheme.of(context);
      _provider.getSocial();

      isInit = true;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => _provider),
        ChangeNotifierProvider(create: (_) => _tabProvider),
      ],
      child: Consumer2<SocialProvider, SocialTabProvider>(
        builder: (context, provider, tabProvider, _) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text("Socials"),
              backgroundColor: cupertinoTheme.barBackgroundColor,
              brightness: cupertinoTheme.brightness,
              trailing: tabProvider.selectedIndex != socialTabs.length - 1
                  ? CupertinoButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .push(CupertinoPageRoute(builder: (_) {
                          switch (tabProvider.selectedIndex) {
                            case 1:
                              return const CustomListSocialListPage();
                            case 0:
                              return const ReviewSocialListPage();
                            case 2:
                              return const RecommendationSocialListPage();
                            default:
                              return const CustomListSocialListPage();
                          }
                        }));
                      },
                      minSize: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 1),
                      child: const Text(
                        "See All",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    )
                  : null,
            ),
            child: RefreshIndicator(
              backgroundColor: cupertinoTheme.bgTextColor,
              color: cupertinoTheme.bgColor,
              onRefresh: () async {
                if (_provider.networkState == NetworkState.success ||
                    _provider.networkState == NetworkState.error) {
                  await _provider.getSocial();
                }
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      child: SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          children: List.generate(socialTabs.length, (index) {
                            return CupertinoChip(
                              key: socialTabKeys[index],
                              isSelected: index == tabProvider.selectedIndex,
                              size: 16,
                              onSelected: (_) {
                                tabProvider.setNewIndex(index);
                                if (_scrollController.hasClients &&
                                    socialTabKeys[index].currentContext !=
                                        null) {
                                  Scrollable.ensureVisible(
                                      socialTabKeys[index].currentContext!);
                                }
                              },
                              label: socialTabs[index],
                            );
                          }),
                        ),
                      ),
                    ),
                    Expanded(child: _body(provider, tabProvider)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _body(SocialProvider provider, SocialTabProvider tabProvider) {
    switch (tabProvider.selectedIndex) {
      case 1: // Custom Lists
        return provider.networkState == NetworkState.success
            ? ListView.builder(
                itemCount: provider.item?.customList.isNotEmpty == true
                    ? provider.item?.customList.length
                    : 1,
                itemBuilder: (context, index) {
                  if (provider.item?.customList.isEmpty == true) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("Nothing here."),
                      ),
                    );
                  }
                  return SizedBox(
                      height: 175,
                      child: SocialCustomListCell(
                          index, provider.item!.customList[index]));
                })
            : const SocialCustomListsLoading();
      case 0: // Reviews
        return provider.networkState == NetworkState.success
            ? ListView.builder(
                itemCount: provider.item?.reviews.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                      height: 205,
                      child: SocialReviewCell(index,
                          provider.item!.reviews[index], _provider.likeReview));
                })
            : const SocialReviewLoading();
      case 2: // Recommendations

        return provider.networkState == NetworkState.success
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: provider.item?.recommendations.length,
                itemBuilder: (context, index) {
                  final item = provider.item!.recommendations[index];

                  return SocialRecommendationCell(item);
                })
            : const SocialRecommendationLoading();
      default: // Leaderboard
        return provider.networkState == NetworkState.success
            ? ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: provider.item?.leaderboard.length,
                itemBuilder: (context, index) {
                  final userInfo = provider.item!.leaderboard[index];

                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(CupertinoPageRoute(builder: (_) {
                        return ProfileDisplayPage(userInfo.username);
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
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
                              style: TextStyle(
                                  fontSize: 20, color: Colors.grey.shade600),
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
                                    frameRate: FrameRate(
                                      RefreshRateHelper().getRefreshRate(),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: AutoSizeText(
                              userInfo.username.split("@")[0],
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
                                  color: AppColors().primaryColor),
                            ),
                          ),
                          const SizedBox(width: 3)
                        ],
                      ),
                    ),
                  );
                })
            : const SocialLeaderboardLoading();
    }
  }
}
