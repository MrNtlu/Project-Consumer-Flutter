import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/pages/details_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/profile/profile_display_details_provider.dart';
import 'package:watchlistfy/static/navigation_provider.dart';
import 'package:watchlistfy/static/refresh_rate_helper.dart';
import 'package:watchlistfy/utils/extensions.dart';
import 'package:watchlistfy/widgets/common/error_view.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';
import 'package:watchlistfy/widgets/common/message_dialog.dart';
import 'package:watchlistfy/widgets/common/see_all_title.dart';
import 'package:watchlistfy/widgets/main/profile/profile_custom_list_cell.dart';
import 'package:watchlistfy/widgets/main/profile/profile_legend_cell.dart';
import 'package:watchlistfy/widgets/main/profile/profile_level_bar.dart';
import 'package:watchlistfy/widgets/main/profile/profile_review_cell.dart';
import 'package:watchlistfy/widgets/main/profile/profile_stats.dart';
import 'package:watchlistfy/widgets/main/profile/profile_user_image.dart';

class ProfileDisplayPage extends StatefulWidget {
  final String username;

  const ProfileDisplayPage(this.username, {super.key});

  @override
  State<ProfileDisplayPage> createState() => _ProfileDisplayPageState();
}

class _ProfileDisplayPageState extends State<ProfileDisplayPage> {
  DetailState _state = DetailState.init;
  String? _error;

  late final ProfileDisplayDetailsProvider _provider;
  late final AuthenticationProvider _authProvider;

  void _fetchData() {
    setState(() {
      _state = DetailState.loading;
    });

    _provider.getProfileDetails(widget.username).then(
      (response) {
        _error = response.error;

        if (_state != DetailState.disposed) {
          setState(
            () {
              _state = response.error != null
                  ? DetailState.error
                  : (response.data != null
                      ? DetailState.view
                      : DetailState.error);
            },
          );
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    if (_state == DetailState.init) {
      _authProvider = Provider.of<AuthenticationProvider>(context);
      _fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _provider = ProfileDisplayDetailsProvider();
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
      child: Consumer<ProfileDisplayDetailsProvider>(
        builder: (context, provider, child) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: AutoSizeText(
                _provider.item?.username ?? "Profile",
                style: const TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            child: _authProvider.isAuthenticated
                ? CustomScrollView(
                    slivers: [_body(provider)],
                  )
                : const Center(
                    child: Text(
                      "You need to login to see the profile.",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _body(ProfileDisplayDetailsProvider provider) {
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
                      child: Stack(
                        children: [
                          ProfileUserImage(image, isProfileDisplay: true),
                          if (item.isPremium)
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Lottie.asset(
                                "assets/lottie/premium.json",
                                height: 36,
                                width: 36,
                                frameRate: FrameRate(
                                  RefreshRateHelper().getRefreshRate(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Member since ${DateTime.parse(item.createdAt).dateToHumanDate()}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ProfileLevelBar(item.level, streak: item.streak),
              const SizedBox(height: 16),
              ProfileStats(item),
              const SizedBox(height: 8),
              const SeeAllTitle("💬 Reviews"),
              SizedBox(
                height: item.reviews.isEmpty ? 100 : 200,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ListView.builder(
                    scrollDirection:
                        item.reviews.isEmpty ? Axis.vertical : Axis.horizontal,
                    physics: item.reviews.isEmpty
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                    itemCount: item.reviews.isEmpty ? 1 : item.reviews.length,
                    itemExtent: 300,
                    itemBuilder: (context, index) {
                      if (item.reviews.isEmpty) {
                        return const Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: 32),
                            child: Text("Nothing here."),
                          ),
                        );
                      } else {
                        final data = item.reviews[index];

                        return ProfileReviewCell(data, _fetchData);
                      }
                    },
                  ),
                ),
              ),
              const SeeAllTitle("🗂️ Lists"),
              SizedBox(
                height: item.customLists.isEmpty ? 100 : 125,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ListView.builder(
                    scrollDirection: item.customLists.isEmpty
                        ? Axis.vertical
                        : Axis.horizontal,
                    physics: item.customLists.isEmpty
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                    itemCount:
                        item.customLists.isEmpty ? 1 : item.customLists.length,
                    itemExtent: 300,
                    itemBuilder: (context, index) {
                      if (item.customLists.isEmpty) {
                        return const Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.only(top: 32),
                            child: Text("Nothing here."),
                          ),
                        );
                      } else {
                        final data = item.customLists[index];

                        return ProfileCustomListCell(data);
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "🥇️ Legend Content",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CupertinoButton(
                      minSize: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 4,
                      ),
                      onPressed: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (_) => const MessageDialog(
                              title: "Information",
                              "Legend content refers to movies, animes, games and tv series that users have watched and enjoyed multiple times."),
                        );
                      },
                      child: const Icon(
                        CupertinoIcons.info_circle,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: item.legendContent.isEmpty ? 100 : 200,
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
                    itemExtent: 200 * 2 / 3,
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
                                  maintainState:
                                      NavigationTracker().shouldMaintainState(),
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
              SizedBox(
                height: MediaQuery.of(context).viewPadding.bottom + 16,
              )
            ],
          ),
        );
      case DetailState.error:
        return SliverFillRemaining(
          child: ErrorView(_error ?? "Unknown error", _fetchData),
        );
      case DetailState.loading:
        return const SliverFillRemaining(child: LoadingView("Loading"));
      default:
        return const SliverFillRemaining(child: LoadingView("Loading"));
    }
  }
}
