import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/pages/main/anime/anime_details_page.dart';
import 'package:watchlistfy/pages/main/game/game_details_page.dart';
import 'package:watchlistfy/pages/main/movie/movie_details_page.dart';
import 'package:watchlistfy/pages/main/tv/tv_details_page.dart';
import 'package:watchlistfy/providers/main/ai/ai_recommendations_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';

class AIRecommendationPage extends StatefulWidget {
  const AIRecommendationPage({super.key});

  @override
  State<AIRecommendationPage> createState() => _AIRecommendationPageState();
}

class _AIRecommendationPageState extends State<AIRecommendationPage> {
  ListState _state = ListState.init;

  late final AIRecommendationsProvider _recommendationsProvider;

  String? _error;

  void _fetchData() {
    setState(() {
      _state = ListState.loading;  
    });

    _recommendationsProvider.getRecommendations().then((response) {
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
      _fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _recommendationsProvider,
      child: Consumer<AIRecommendationsProvider>(
        builder: (context, provider, child) {

          return CupertinoPageScaffold(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        maxRadius: 32,
                        backgroundColor: CupertinoTheme.of(context).onBgColor,
                        foregroundColor: CupertinoTheme.of(context).onBgColor,
                        child: const Text("🤖", style: TextStyle(fontSize: 32),),
                      ),
                      Flexible(
                        child: BubbleSpecialOne(
                          text: _state == ListState.done
                          ? "This is what I recommend based on your activity."
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
                      ),
                      CupertinoButton(
                        child: const Icon(CupertinoIcons.info_circle), 
                        onPressed: () {
                          //TODO tell user what this page is and what can AI assistant do like summary etc.
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
                if (_state == ListState.done)
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
                )
              ],
            )
          );
        }
      ),
    );
  }


}