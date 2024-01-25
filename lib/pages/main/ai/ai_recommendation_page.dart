import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class AIRecommendationPage extends StatefulWidget {
  const AIRecommendationPage({super.key});

  @override
  State<AIRecommendationPage> createState() => _AIRecommendationPageState();
}

class _AIRecommendationPageState extends State<AIRecommendationPage> {
  ListState _state = ListState.init;

  late final AIRecommendationsProvider _recommendationsProvider;
  late final AuthenticationProvider authProvider;

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
            : (
              response.data.isEmpty
                ? ListState.empty
                : ListState.done
            );
        });
      }
    });
  }

  void _generateData() {
    setState(() {
      _state = ListState.loading;  
    });

    _recommendationsProvider.generateRecommendations().then((response) {
      _error = response.error;

      if (_state != ListState.disposed) {
        setState(() {
          _state = response.error != null
            ? ListState.error
            : (
              response.data.isEmpty
                ? ListState.empty
                : ListState.done
            );
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
          final deadlineDayRange = authProvider.basicUserInfo?.isPremium == true ? 7 : 30;
          final endDate = startDate?.add(Duration(days: deadlineDayRange));

          return CupertinoPageScaffold(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        maxRadius: 32,
                        backgroundColor: CupertinoTheme.of(context).onBgColor,
                        foregroundColor: CupertinoTheme.of(context).onBgColor,
                        child: const Text("🤖", style: TextStyle(fontSize: 32),),
                      ),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            BubbleSpecialOne(
                              text: _state == ListState.done
                              ? (
                                authProvider.isAuthenticated
                                ? "This is what I recommend based on your activity."
                                : "You need to be logged in to get recommendations."
                              )
                              : (_state == ListState.error
                                ? _error!
                                : (
                                  _state == ListState.empty
                                  ? "You can generate your recommendations now!"
                                  : "Please wait..."
                                )
                              ),
                              color: CupertinoTheme.of(context).bgTextColor,
                              tail: true,
                              isSender: false,
                              textStyle: TextStyle(color: CupertinoTheme.of(context).bgColor, fontSize: 15),
                            ),
                            if (endDate != null && authProvider.isAuthenticated)
                            const SizedBox(height: 6),
                            if (endDate != null && authProvider.isAuthenticated)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text("Until refresh ", style: TextStyle(fontSize: 13)),
                                TimerCountdown(
                                  spacerWidth: 3,
                                  enableDescriptions: false,
                                  format: CountDownTimerFormat.daysHoursMinutesSeconds,
                                  endTime: endDate,
                                  descriptionTextStyle: const TextStyle(fontSize: 10),
                                  colonsTextStyle: const TextStyle(fontSize: 10),
                                  timeTextStyle: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
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
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "🤖 Your AI Assistant",
                                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 16),
                                      Text("""Premium users can get recommendations every week. Free users can get recommendations every month.

Spot-On Recommendations: Recommendations based on your user list. \n
✨ Speedy Summaries: Get summary of a content and decide yourself. \n
✨ User Reviews Digest: Brief overview of the content based on other people. \n"""),
                                      Text("✨: Premium Features Only", style: TextStyle(fontSize: 11),)
                                    ],
                                  ),
                                ),
                              );
                            }
                          );
                        }
                      )
                    ],
                  ),
                ),
                if (_state == ListState.empty)
                Expanded(
                  child: Center(
                    child: CupertinoButton.filled(
                      child: const Text("Generate Now!", style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)), 
                      onPressed: () {
                        _generateData();
                      }
                    ),
                  ),
                ),
                if (_state == ListState.error)
                Expanded(
                  child: Center(
                    child: CupertinoButton.filled(
                      child: const Text("Refresh", style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)), 
                      onPressed: () {
                        _fetchData();
                      }
                    ),
                  ),
                ),
                if (_state == ListState.done && authProvider.isAuthenticated)
                Expanded(
                  child: GridView.builder(
                    itemCount: provider.items.length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250,
                      childAspectRatio: 2/3, 
                      crossAxisSpacing: 6, 
                      mainAxisSpacing: 6
                    ), 
                    itemBuilder: (context, index) {
                      final content = provider.items[index];
                      final contentType = ContentType.values.where((element) => content.contentType == element.request).first;
                  
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(builder: (_) {
                              switch (contentType) {
                                case ContentType.movie:
                                  return MovieDetailsPage(content.id);
                                case ContentType.tv:
                                  return TVDetailsPage(content.id);
                                case ContentType.anime:
                                  return AnimeDetailsPage(content.id);
                                case ContentType.game: 
                                  return GameDetailsPage(content.id);
                                default:
                                  return MovieDetailsPage(content.id);
                              }
                            })
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                          child: ContentCell(content.imageUrl, content.titleEn),
                        )
                      );
                    }
                  ),
                ),
                if (!authProvider.isAuthenticated)
                Expanded(
                  child: Center(
                    child: CupertinoButton.filled(
                      child: const Text("Login", style: TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)), 
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                          CupertinoPageRoute(builder: (_) {
                            return LoginPage();
                          })
                        );
                      }
                    ),
                  ),
                ),
              ],
            )
          );
        }
      ),
    );
  }


}