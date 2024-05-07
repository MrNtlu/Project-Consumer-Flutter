import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/pages/main/content_list_page.dart';
import 'package:watchlistfy/pages/main/search_list_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/providers/main/preview_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/content_selection.dart';
import 'package:watchlistfy/widgets/common/see_all_title.dart';
import 'package:watchlistfy/widgets/main/home/anonymous_header.dart';
import 'package:watchlistfy/widgets/main/home/genre_list.dart';
import 'package:watchlistfy/widgets/main/home/info_card.dart';
import 'package:watchlistfy/widgets/main/home/loggedin_header.dart';
import 'package:watchlistfy/widgets/main/home/preview_actor_list.dart';
import 'package:watchlistfy/widgets/main/home/preview_company_list.dart';
import 'package:watchlistfy/widgets/main/home/preview_country_list.dart';
import 'package:watchlistfy/widgets/main/home/preview_list.dart';
import 'package:watchlistfy/widgets/main/home/preview_streaming_platforms_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isInit = false;

  TextEditingController? searchController;
  late final AuthenticationProvider authenticationProvider;
  late final ContentProvider contentProvider;
  late final GlobalProvider globalProvider;
  PreviewProvider? previewProvider;

  void onContentChange() {
    searchController?.text = "";
  }

  @override
  void didChangeDependencies() {
    if (!isInit) {
      searchController = TextEditingController();
      authenticationProvider = Provider.of<AuthenticationProvider>(context);
      contentProvider = Provider.of<ContentProvider>(context);
      globalProvider = Provider.of<GlobalProvider>(context);
      previewProvider = Provider.of<PreviewProvider>(context, listen: false);

      contentProvider.initContentType(globalProvider.contentType);

      previewProvider?.getPreviews(region: globalProvider.selectedCountryCode);
      contentProvider.addListener(onContentChange);

      isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    contentProvider.removeListener(onContentChange);
    searchController?.dispose();
    previewProvider?.networkState = NetworkState.disposed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMovieOrTVSeries = contentProvider.selectedContent == ContentType.movie || contentProvider.selectedContent == ContentType.tv;
    final isGame = contentProvider.selectedContent == ContentType.game;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: null,
        automaticallyImplyLeading: true,
        middle: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: authenticationProvider.isAuthenticated
                  ? const LoggedinHeader()
                  : const AnonymousHeader()
                ),
              ),
            ),
            const ContentSelection(),
          ],
        ),
        backgroundColor: CupertinoTheme.of(context).bgColor,
        brightness: CupertinoTheme.of(context).brightness,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // if (Platform.isAndroid)
            // const SizedBox(height: 8),
            // Row(
            //   children: [
            //     Expanded(
            //       child: Align(
            //         alignment: Alignment.centerLeft,
            //         child: Padding(
            //           padding: const EdgeInsets.only(left: 16, right: 8),
            //           child: authenticationProvider.isAuthenticated
            //           ? const LoggedinHeader()
            //           : const AnonymousHeader()
            //         ),
            //       ),
            //     ),
            //     const ContentSelection(),
            //   ],
            // ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoSearchTextField(
                controller: searchController,
                onSubmitted: (value) {
                  FocusManager.instance.primaryFocus?.unfocus();

                  if (value.isNotEmpty) {
                    Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (_) {
                      return SearchListPage(value);
                    }));
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            SeeAllTitle("🔥 Popular", () {
              Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (_) {
                return ContentListPage(contentProvider.selectedContent, Constants.ContentTags[0], "🔥 Popular");
              }));
            }),
            SizedBox(
              height: 200,
              child: PreviewList(Constants.ContentTags[0])
            ),
            const SizedBox(height: 20),
            if (!authenticationProvider.isAuthenticated)
            ...[
              const InfoCard(),
              const SizedBox(height: 20),
            ],
            if (!Platform.isAndroid)
            const SizedBox(height: 20),
            const GenreList(),
            const SizedBox(height: 12),
            SeeAllTitle("📆 Upcoming", () {
              Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (_) {
                return ContentListPage(contentProvider.selectedContent,Constants.ContentTags[1], "📆 Upcoming");
              }));
            }),
            SizedBox(
              height: 200,
              child: PreviewList(Constants.ContentTags[1])
            ),
            if (isMovieOrTVSeries)
            ...[
              const SizedBox(height: 8),
              SeeAllTitle("🌎 Countries", (){}, shouldHideSeeAllButton: true),
              PreviewCountryList(isMovie: contentProvider.selectedContent == ContentType.movie),
              SeeAllTitle("🧛‍♂️ Popular Actors", (){}, shouldHideSeeAllButton: true),
              const PreviewActorList(),
            ],
            const SizedBox(height: 12),
            SeeAllTitle("🍿 Top Rated", () {
              Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (_) {
                return ContentListPage(contentProvider.selectedContent, Constants.ContentTags[2], "🍿 Top Rated");
              }));
            }),
            SizedBox(
              height: 200,
              child: PreviewList(Constants.ContentTags[2])
            ),
            const SizedBox(height: 12),
            if (!isGame)
            ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("📺 Streaming Platforms", style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                    if (contentProvider.selectedContent != ContentType.anime)
                    Text(globalProvider.selectedCountryCode, style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                  ],
                ),
              ),
              PreviewStreamingPlatformsList(globalProvider.selectedCountryCode),
              const SizedBox(height: 12),
              SeeAllTitle(
                contentProvider.selectedContent == ContentType.movie
                    ? "🎭 In Theaters"
                    : "📺 Airing Today", () {
                  Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (_) {
                    return ContentListPage(contentProvider.selectedContent, Constants.ContentTags[3], "🎭 In Theaters");
                  }));
                },
                shouldHideSeeAllButton: contentProvider.selectedContent !=ContentType.movie
              ),
              SizedBox(
                height: 200,
                child: PreviewList(Constants.ContentTags[3])
              ),
              const SizedBox(height: 12),
            ],
            SeeAllTitle(
              "${contentProvider.selectedContent == ContentType.game ? '🎮' : '🎙️'} Popular ${contentProvider.selectedContent == ContentType.game ? 'Publishers' : 'Studios'}",
              (){},
              shouldHideSeeAllButton: true
            ),
            const PreviewCompanyList(),
            const SizedBox(height: 16),
          ],
        ),
      )
    );
  }
}
