import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/pages/main/search_list_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/providers/main/preview_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/banner_ad_widget.dart';
import 'package:watchlistfy/widgets/common/content_selection_chips.dart';
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
import 'package:watchlistfy/providers/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isInit = false;

  // Cache frequently accessed providers and values
  late final AuthenticationProvider _authenticationProvider;
  late final ContentProvider _contentProvider;
  late final GlobalProvider _globalProvider;
  late final CupertinoThemeData _cupertinoTheme;
  late final PreviewProvider? _previewProvider;

  // Cache computed values to avoid repeated calculations
  late final SystemUiOverlayStyle _lightSystemUI;
  late final SystemUiOverlayStyle _darkSystemUI;

  // Cache widget instances for better performance
  late final Widget _searchIcon;
  late final Widget _spacer;

  @override
  void didChangeDependencies() {
    if (!isInit) {
      // Cache all provider references
      _authenticationProvider = Provider.of<AuthenticationProvider>(context);
      _contentProvider = Provider.of<ContentProvider>(context);
      _globalProvider = Provider.of<GlobalProvider>(context);
      _previewProvider = Provider.of<PreviewProvider>(context, listen: false);
      _cupertinoTheme = CupertinoTheme.of(context);

      // Cache widget instances
      _searchIcon = FaIcon(
        FontAwesomeIcons.magnifyingGlass,
        size: 18,
        color: _cupertinoTheme.primaryColor,
      );
      _spacer = const Spacer();

      // Pre-compute system UI overlay styles
      _lightSystemUI = SystemUiOverlayStyle(
        statusBarColor: Platform.isIOS
            ? Colors.transparent
            : _cupertinoTheme.barBackgroundColor,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: _cupertinoTheme.barBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      );

      _darkSystemUI = SystemUiOverlayStyle(
        statusBarColor: Platform.isIOS
            ? Colors.transparent
            : _cupertinoTheme.barBackgroundColor,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: _cupertinoTheme.barBackgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      );

      _contentProvider.initContentType(_globalProvider.contentType);
      _previewProvider?.getPreviews(
          region: _globalProvider.selectedCountryCode);

      isInit = true;
    }

    // Optimized system UI update
    final isDark = _cupertinoTheme.brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(
        isDark ? _darkSystemUI : _lightSystemUI);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _previewProvider?.networkState = NetworkState.disposed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // Cache computed values to avoid repeated calculations
        final selectedContent = _contentProvider.selectedContent;
        final isMovieOrTVSeries = selectedContent == ContentType.movie ||
            selectedContent == ContentType.tv;
        final isGame = selectedContent == ContentType.game;
        final shouldShowAds = _authenticationProvider.basicUserInfo == null ||
            _authenticationProvider.basicUserInfo?.isPremium == false;
        final isAuthenticated = _authenticationProvider.isAuthenticated;
        final selectedCountryCode = _globalProvider.selectedCountryCode;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: _cupertinoTheme.brightness == Brightness.dark
              ? _darkSystemUI
              : _lightSystemUI,
          child: CupertinoPageScaffold(
            navigationBar:
                _buildOptimizedNavigationBar(themeProvider, isAuthenticated),
            child: _OptimizedScrollableContent(
              key: ValueKey(
                  'scrollable_${selectedContent.name}_$isAuthenticated'),
              isAuthenticated: isAuthenticated,
              isMovieOrTVSeries: isMovieOrTVSeries,
              isGame: isGame,
              shouldShowAds: shouldShowAds,
              selectedContent: selectedContent,
              selectedCountryCode: selectedCountryCode,
            ),
          ),
        );
      },
    );
  }

  // Optimized navigation bar builder method
  CupertinoNavigationBar _buildOptimizedNavigationBar(
      ThemeProvider themeProvider, bool isAuthenticated) {
    return CupertinoNavigationBar(
      key: ValueKey(
          'nav_bar_${themeProvider.isDarkTheme}_${_cupertinoTheme.brightness}'),
      leading: null,
      automaticallyImplyLeading: true,
      middle: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                  builder: (_) => const SearchListPage(null),
                ),
              );
            },
            icon: _searchIcon,
          ),
          _spacer,
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: isAuthenticated
                  ? const LoggedinHeader()
                  : const AnonymousHeader(),
            ),
          ),
        ],
      ),
      backgroundColor: _cupertinoTheme.barBackgroundColor,
      brightness: _cupertinoTheme.brightness,
    );
  }
}

// Optimized scrollable content as separate widget
class _OptimizedScrollableContent extends StatelessWidget {
  final bool isAuthenticated;
  final bool isMovieOrTVSeries;
  final bool isGame;
  final bool shouldShowAds;
  final ContentType selectedContent;
  final String selectedCountryCode;

  const _OptimizedScrollableContent({
    super.key,
    required this.isAuthenticated,
    required this.isMovieOrTVSeries,
    required this.isGame,
    required this.shouldShowAds,
    required this.selectedContent,
    required this.selectedCountryCode,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: RepaintBoundary(
        child: Column(
          children: [
            const SizedBox(height: 8),
            const RepaintBoundary(child: ContentSelectionChips()),
            const SizedBox(height: 8),

            // Popular section with optimized keys
            const SeeAllTitle("🔥 Popular"),
            RepaintBoundary(
              key: const ValueKey('popular_section'),
              child: SizedBox(
                height: 200,
                child: PreviewList(Constants.ContentTags[0]),
              ),
            ),
            const SizedBox(height: 20),

            // Info card for non-authenticated users
            if (!isAuthenticated) ...[
              const RepaintBoundary(
                key: ValueKey('info_card'),
                child: InfoCard(),
              ),
              const SizedBox(height: 20),
            ],

            if (!Platform.isAndroid) const SizedBox(height: 16),

            // Genre list with boundary
            const RepaintBoundary(
              key: ValueKey('genre_list'),
              child: GenreList(),
            ),

            // Ads section with boundary
            if (shouldShowAds) ...[
              const SizedBox(height: 20),
              const RepaintBoundary(
                key: ValueKey('banner_ad'),
                child: BannerAdWidget(),
              ),
            ],

            const SizedBox(height: 12),

            // Upcoming section with optimized keys
            const SeeAllTitle("📆 Upcoming"),
            RepaintBoundary(
              key: const ValueKey('upcoming_section'),
              child: SizedBox(
                height: 200,
                child: PreviewList(Constants.ContentTags[1]),
              ),
            ),

            // Movie/TV specific content with boundaries
            if (isMovieOrTVSeries) ...[
              const SizedBox(height: 8),
              const SeeAllTitle("🌎 Countries"),
              RepaintBoundary(
                key: ValueKey('countries_${selectedContent.name}'),
                child: PreviewCountryList(
                  isMovie: selectedContent == ContentType.movie,
                ),
              ),
              const SeeAllTitle("🧛‍♂️ Popular Actors"),
              const RepaintBoundary(
                key: ValueKey('actors_list'),
                child: PreviewActorList(),
              ),
            ],

            const SizedBox(height: 12),

            // Top Rated section with optimized keys
            const SeeAllTitle("🍿 Top Rated"),
            RepaintBoundary(
              key: const ValueKey('top_rated_section'),
              child: SizedBox(
                height: 200,
                child: PreviewList(Constants.ContentTags[2]),
              ),
            ),

            const SizedBox(height: 12),

            // Streaming platforms and additional content
            if (!isGame) ...[
              _OptimizedStreamingPlatformsSection(
                key: ValueKey(
                    'streaming_${selectedContent.name}_$selectedCountryCode'),
                selectedContent: selectedContent,
                selectedCountryCode: selectedCountryCode,
              ),
              const SizedBox(height: 12),
              SeeAllTitle(
                selectedContent == ContentType.movie
                    ? "🎭 In Theaters"
                    : "📺 Airing Today",
              ),
              RepaintBoundary(
                key: ValueKey('theaters_airing_${selectedContent.name}'),
                child: SizedBox(
                  height: 200,
                  child: PreviewList(Constants.ContentTags[3]),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Companies section with boundary
            SeeAllTitle(
              "${selectedContent == ContentType.game ? '🎮' : '🎙️'} Popular ${selectedContent == ContentType.game ? 'Publishers' : 'Studios'}",
            ),
            RepaintBoundary(
              key: ValueKey('companies_${selectedContent.name}'),
              child: const PreviewCompanyList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Optimized streaming platforms section
class _OptimizedStreamingPlatformsSection extends StatelessWidget {
  final ContentType selectedContent;
  final String selectedCountryCode;

  const _OptimizedStreamingPlatformsSection({
    super.key,
    required this.selectedContent,
    required this.selectedCountryCode,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "📺 Streaming Platforms",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (selectedContent != ContentType.anime)
                  Text(
                    selectedCountryCode,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          PreviewStreamingPlatformsList(selectedCountryCode),
        ],
      ),
    );
  }
}
