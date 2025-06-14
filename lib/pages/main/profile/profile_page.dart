import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/common/request/id_body.dart';
import 'package:watchlistfy/pages/details_page.dart';
import 'package:watchlistfy/pages/main/ai/ai_recommendation_page.dart';
import 'package:watchlistfy/pages/main/profile/consume_later_page.dart';
import 'package:watchlistfy/pages/main/profile/custom_list_interaction_list_page.dart';
import 'package:watchlistfy/pages/main/profile/custom_list_page.dart';
import 'package:watchlistfy/pages/main/recommendation/recommendation_interaction_list_page.dart';
import 'package:watchlistfy/pages/main/recommendation/recommendation_profile_list_page.dart';
import 'package:watchlistfy/pages/main/review/review_interaction_list_page.dart';
import 'package:watchlistfy/pages/main/review/review_profile_list_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/profile/profile_details_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/error_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';
import 'package:watchlistfy/widgets/common/see_all_title.dart';
import 'package:watchlistfy/widgets/common/sure_dialog.dart';
import 'package:watchlistfy/widgets/main/profile/profile_consume_later_cell.dart';
import 'package:watchlistfy/widgets/main/profile/profile_legend_cell.dart';
import 'package:watchlistfy/widgets/main/profile/profile_level_bar.dart';
import 'package:watchlistfy/widgets/main/profile/profile_stats.dart';
import 'package:watchlistfy/widgets/main/profile/profile_sub_menu_button.dart';
import 'package:watchlistfy/widgets/main/profile/profile_user_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DetailState _state = DetailState.init;
  String? _error;

  late final ProfileDetailsProvider _provider;
  late final CupertinoThemeData cupertinoTheme;

  void _fetchData() {
    setState(() {
      _state = DetailState.loading;
    });

    _provider.getProfileDetails().then((response) {
      _error = response.error;

      if (_state != DetailState.disposed) {
        setState(() {
          _state = response.error != null
              ? DetailState.error
              : (response.data != null ? DetailState.view : DetailState.error);
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_state == DetailState.init) {
      cupertinoTheme = CupertinoTheme.of(context);

      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      if (!authProvider.isAuthenticated) {
        Navigator.pop(context);
      }

      _fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _provider = ProfileDetailsProvider();
    if (_state != DetailState.init) {
      _fetchData();
    }
  }

  @override
  void dispose() {
    _state = DetailState.disposed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _provider,
      child: Consumer<ProfileDetailsProvider>(
        builder: (context, provider, child) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: AutoSizeText(
                _provider.item?.username ?? "Profile",
                style: const TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: _provider.item?.username != null
                  ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: const Icon(CupertinoIcons.share),
                      onPressed: () async {
                        final url =
                            '${Constants.BASE_DOMAIN_URL}/profile/${_provider.item!.username}';
                        try {
                          final box = context.findRenderObject() as RenderBox?;

                          if (box != null) {
                            Share.share(url,
                                subject: 'Share Profile',
                                sharePositionOrigin:
                                    box.localToGlobal(Offset.zero) & box.size);
                          }
                        } catch (_) {
                          await Clipboard.setData(ClipboardData(text: url));
                          if (context.mounted) {
                            showCupertinoDialog(
                                context: context,
                                builder: (_) => const MessageDialog(
                                    "Copied to clipboard."));
                          }
                        }
                      })
                  : null,
            ),
            child: CustomScrollView(
              slivers: [_body(provider)],
            ),
          );
        },
      ),
    );
  }

  Widget _body(ProfileDetailsProvider provider) {
    switch (_state) {
      case DetailState.view:
        final item = provider.item!;
        final image = item.image;

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 110,
                width: 115,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: ProfileUserImage(image),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ProfileLevelBar(item.level, streak: item.streak),
              const SizedBox(height: 16),
              ProfileStats(item, onRefresh: _fetchData),
              SeeAllTitle(
                "🕒 Watch Later",
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    CupertinoPageRoute(
                      builder: (_) {
                        return const ConsumeLaterPage();
                      },
                    ),
                  ).then(
                    (value) => _fetchData(),
                  );
                },
              ),
              SizedBox(
                height: 165,
                child: _provider.isLoading
                    ? const CupertinoActivityIndicator()
                    : Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ListView.builder(
                          scrollDirection: item.watchLater.isEmpty
                              ? Axis.vertical
                              : Axis.horizontal,
                          physics: item.watchLater.isEmpty
                              ? const NeverScrollableScrollPhysics()
                              : const BouncingScrollPhysics(),
                          itemCount: item.watchLater.isEmpty
                              ? 1
                              : item.watchLater.length,
                          itemExtent: 165 * 2 / 3,
                          itemBuilder: (context, index) {
                            if (item.watchLater.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text("Nothing here."),
                                ),
                              );
                            } else {
                              final data = item.watchLater[index];

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: GestureDetector(
                                  onTap: () {
                                    if (!_provider.isLoading) {
                                      Navigator.of(context, rootNavigator: true)
                                          .push(
                                        CupertinoPageRoute(
                                          builder: (_) {
                                            final contentType = ContentType
                                                .values
                                                .where((element) =>
                                                    element.request ==
                                                    data.contentType)
                                                .first;

                                            return DetailsPage(
                                              id: data.contentID,
                                              contentType: contentType,
                                            );
                                          },
                                        ),
                                      ).then((value) => _fetchData());
                                    }
                                  },
                                  child: ProfileConsumeLaterCell(
                                    data.content.imageUrl,
                                    data.content.titleEn,
                                    () {
                                      HapticFeedback.lightImpact();

                                      showCupertinoDialog(
                                        context: context,
                                        builder: (_) {
                                          return SureDialog(
                                            "Do you want to remove it?",
                                            () {
                                              _provider.deleteConsumeLater(
                                                  index, IDBody(data.id));
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("🥇️ Legend Content",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                    CupertinoButton(
                        minSize: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 4),
                        onPressed: () {
                          showCupertinoDialog(
                              context: context,
                              builder: (_) => const MessageDialog(
                                  title: "Information",
                                  "Legend content refers to movies, animes, games and tv series that users have watched and enjoyed multiple times."));
                        },
                        child: const Icon(CupertinoIcons.info_circle))
                  ],
                ),
              ),
              SizedBox(
                height: 165,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ListView.builder(
                    scrollDirection: item.legendContent.isEmpty
                        ? Axis.vertical
                        : Axis.horizontal,
                    physics: item.legendContent.isEmpty
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                    itemCount: item.legendContent.isEmpty
                        ? 1
                        : item.legendContent.length,
                    itemExtent: 165 * 2 / 3,
                    itemBuilder: (context, index) {
                      if (item.legendContent.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Text("Nothing here."),
                          ),
                        );
                      } else {
                        final data = item.legendContent[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute(
                                  builder: (_) {
                                    final contentType = ContentType.values
                                        .where((element) =>
                                            element.request == data.contentType)
                                        .first;

                                    return DetailsPage(
                                      id: data.id,
                                      contentType: contentType,
                                    );
                                  },
                                ),
                              );
                            },
                            child: ProfileLegendCell(
                              data.imageUrl,
                              data.titleEn,
                              timesFinished: data.timesFinished,
                              hoursPlayed: data.hoursPlayed,
                              isGame: data.contentType == "game",
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    ProfileSubMenuButton("AI Recommendations",
                        FontAwesomeIcons.robot, CupertinoColors.systemGrey, () {
                      Navigator.of(context, rootNavigator: true)
                          .push(CupertinoPageRoute(builder: (_) {
                        return const AIRecommendationPage();
                      }));
                    }),
                    ProfileSubMenuButton(
                        "Custom Lists",
                        FontAwesomeIcons.solidFolder,
                        CupertinoColors.activeOrange, () {
                      Navigator.of(context, rootNavigator: true)
                          .push(CupertinoPageRoute(builder: (_) {
                        return const CustomListPage();
                      }));
                    }),
                    ProfileSubMenuButton(
                        "Reviews",
                        FontAwesomeIcons.solidComments,
                        CupertinoColors.activeBlue, () {
                      Navigator.of(context, rootNavigator: true)
                          .push(CupertinoPageRoute(builder: (_) {
                        return ReviewProfileListPage(_fetchData);
                      }));
                    }),
                    ProfileSubMenuButton(
                        "Recommendations",
                        FontAwesomeIcons.solidLightbulb,
                        CupertinoColors.systemYellow, () {
                      Navigator.of(context, rootNavigator: true)
                          .push(CupertinoPageRoute(builder: (_) {
                        return const RecommendationProfileListPage();
                      }));
                    }),
                    ProfileSubMenuButton(
                        "Liked Reviews",
                        FontAwesomeIcons.solidHeart,
                        CupertinoColors.systemRed, () {
                      Navigator.of(context, rootNavigator: true)
                          .push(CupertinoPageRoute(builder: (_) {
                        return const ReviewInteractionListPage();
                      }));
                    }),
                    ProfileSubMenuButton(
                        "Liked Recommendations",
                        FontAwesomeIcons.solidHeart,
                        CupertinoColors.systemRed, () {
                      Navigator.of(context, rootNavigator: true)
                          .push(CupertinoPageRoute(builder: (_) {
                        return const RecommendationInteractionListPage();
                      }));
                    }),
                    ProfileSubMenuButton(
                        "Liked Custom Lists",
                        FontAwesomeIcons.solidHeart,
                        CupertinoColors.systemRed, () {
                      Navigator.of(context, rootNavigator: true)
                          .push(CupertinoPageRoute(builder: (_) {
                        return const CustomListInteractionListPage(
                            isBookmark: false);
                      }));
                    }),
                    ProfileSubMenuButton(
                        "Bookmarked Custom Lists",
                        FontAwesomeIcons.solidBookmark,
                        CupertinoColors.black, () {
                      Navigator.of(context, rootNavigator: true)
                          .push(CupertinoPageRoute(builder: (_) {
                        return const CustomListInteractionListPage();
                      }));
                    }),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 16)
            ],
          ),
        );
      case DetailState.error:
        return SliverFillRemaining(
            child: ErrorView(_error ?? "Unknown error", _fetchData));
      case DetailState.loading:
        return const SliverFillRemaining(child: LoadingView("Loading"));
      default:
        return const SliverFillRemaining(child: LoadingView("Loading"));
    }
  }
}
