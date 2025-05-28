import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/pages/auth/login_page.dart';
import 'package:watchlistfy/pages/main/anime/anime_details_page.dart';
import 'package:watchlistfy/pages/main/game/game_details_page.dart';
import 'package:watchlistfy/pages/main/movie/movie_details_page.dart';
import 'package:watchlistfy/pages/main/tv/tv_details_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/ai/ai_recommendations_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:watchlistfy/widgets/common/loading_view.dart';

class AIRecommendationPage extends StatefulWidget {
  const AIRecommendationPage({super.key});

  @override
  State<AIRecommendationPage> createState() => _AIRecommendationPageState();
}

class _AIRecommendationPageState extends State<AIRecommendationPage> {
  ListState _state = ListState.init;

  late final AIRecommendationsProvider _recommendationsProvider;
  late final AuthenticationProvider authProvider;
  late final CupertinoThemeData cupertinoTheme;

  String? createdAt;
  String? _error;

  void _fetchData() {
    setState(() {
      _state = ListState.loading;
    });

    _recommendationsProvider.getRecommendations().then((response) {
      _error = response.error;
      createdAt = response.createdAt;

      if (_state != ListState.disposed) {
        setState(() {
          _state = response.error != null
              ? ListState.error
              : (response.data.isEmpty ? ListState.empty : ListState.done);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _recommendationsProvider = AIRecommendationsProvider();
  }

  @override
  void dispose() {
    _state = ListState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      cupertinoTheme = CupertinoTheme.of(context);

      authProvider = Provider.of<AuthenticationProvider>(context);
      if (authProvider.isAuthenticated) {
        _fetchData();
      } else {
        _state = ListState.done;
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _recommendationsProvider,
      child: Consumer<AIRecommendationsProvider>(
        builder: (context, provider, child) {
          final startDate = DateTime.tryParse(createdAt ?? '');
          final deadlineDayRange =
              authProvider.basicUserInfo?.isPremium == true ? 7 : 30;
          final endDate = startDate?.add(Duration(days: deadlineDayRange));

          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text("Smart Recommendations"),
              backgroundColor: cupertinoTheme.bgColor,
              brightness: cupertinoTheme.brightness,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (authProvider.isAuthenticated) ...[
                        _robotCircleAvatar(context),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              BubbleSpecialOne(
                                text: _state == ListState.done
                                    ? (authProvider.isAuthenticated
                                        ? "This is what I recommend based on your activity."
                                        : "Sorry, I cannot help you right now. You need to be logged in to get recommendations.")
                                    : (_state == ListState.error
                                        ? _error!
                                        : (_state == ListState.empty
                                            ? "Cannot generate recommendations. Please try again later."
                                            : "This action can take a while to complete. Please wait...")),
                                color: cupertinoTheme.onBgColor,
                                tail: true,
                                isSender: false,
                                textStyle: TextStyle(
                                  color: cupertinoTheme.bgTextColor,
                                  fontSize: 15,
                                ),
                              ),
                              if (endDate != null) ...[
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "Until refresh ",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    TimerCountdown(
                                      spacerWidth: 3,
                                      enableDescriptions: false,
                                      format: CountDownTimerFormat
                                          .daysHoursMinutesSeconds,
                                      endTime: endDate,
                                      descriptionTextStyle: const TextStyle(
                                        fontSize: 10,
                                      ),
                                      colonsTextStyle: const TextStyle(
                                        fontSize: 10,
                                      ),
                                      timeTextStyle: const TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        CupertinoButton(
                          child: const Icon(CupertinoIcons.info_circle),
                          onPressed: () {
                            showCupertinoModalBottomSheet(
                              context: context,
                              builder: (_) {
                                return SafeArea(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 16,
                                    ),
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "🤖 AI Assistant",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          """Premium users can get recommendations every week. Free users can get recommendations every month.

✨ Spot-On Recommendations: Recommendations based on your user list. \n""",
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                if (_state == ListState.loading)
                  const Expanded(
                    child: LoadingView("Loading"),
                  ),
                if (_state == ListState.error)
                  Expanded(
                    child: Center(
                      child: CupertinoButton.filled(
                        child: const Text(
                          "Refresh",
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          _fetchData();
                        },
                      ),
                    ),
                  ),
                if (_state == ListState.done && authProvider.isAuthenticated)
                  Expanded(
                    child: GridView.builder(
                      itemCount: provider.items.length,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250,
                        childAspectRatio: 2 / 3,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                      ),
                      itemBuilder: (context, index) {
                        final content = provider.items[index];
                        final contentType = ContentType.values
                            .where(
                              (element) =>
                                  content.contentType == element.request,
                            )
                            .first;

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(CupertinoPageRoute(builder: (_) {
                              switch (contentType) {
                                case ContentType.movie:
                                  return MovieDetailsPage(content.id);
                                case ContentType.tv:
                                  return TVDetailsPage(content.id);
                                case ContentType.anime:
                                  return AnimeDetailsPage(content.id);
                                case ContentType.game:
                                  return GameDetailsPage(content.id);
                              }
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 2,
                            ),
                            child: ContentCell(
                              content.imageUrl,
                              content.titleEn,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                if (!authProvider.isAuthenticated)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _robotCircleAvatar(
                            context,
                            size: 40,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Sorry, I cannot help you right now.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "You need to be logged in to get recommendations.",
                            style: TextStyle(
                              fontSize: 16,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          CupertinoButton.filled(
                            child: const Text(
                              "Login Now!",
                              style: TextStyle(
                                color: CupertinoColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push(
                                CupertinoPageRoute(
                                  builder: (_) {
                                    return LoginPage();
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _robotCircleAvatar(BuildContext context, {int size = 26}) {
    return CircleAvatar(
      maxRadius: size.toDouble() + 2,
      backgroundColor: cupertinoTheme.onBgColor,
      foregroundColor: cupertinoTheme.onBgColor,
      child: FaIcon(
        FontAwesomeIcons.robot,
        color: AppColors().primaryColor,
        size: size.toDouble(),
      ),
    );
  }
}
