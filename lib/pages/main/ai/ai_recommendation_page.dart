import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/pages/auth/login_page.dart';
import 'package:watchlistfy/pages/details_page.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/ai/ai_recommendations_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

import 'package:watchlistfy/widgets/main/ai/ai_suggestion_content_cell.dart';
import 'package:watchlistfy/widgets/main/settings/offers_sheet.dart';
import 'dart:async';

class AIRecommendationPage extends StatefulWidget {
  const AIRecommendationPage({super.key});

  @override
  State<AIRecommendationPage> createState() => _AIRecommendationPageState();
}

class _AIRecommendationPageState extends State<AIRecommendationPage>
    with TickerProviderStateMixin {
  ListState _state = ListState.init;

  late final AIRecommendationsProvider _recommendationsProvider;
  late final AuthenticationProvider _authProvider;
  late final CupertinoThemeData _cupertinoTheme;
  late final AnimationController _loadingAnimationController;
  late final AnimationController _pulseAnimationController;

  // Cache frequently accessed values
  late final Color _primaryColor;
  late final TextStyle _titleTextStyle;

  String? _createdAt;
  String? _error;

  void _fetchData() {
    setState(() {
      _state = ListState.loading;
    });

    _loadingAnimationController.repeat();
    _pulseAnimationController.repeat(reverse: true);

    _recommendationsProvider.getRecommendations().then((response) {
      _error = response.error;
      _createdAt = response.createdAt;

      if (_state != ListState.disposed) {
        _loadingAnimationController.stop();
        _pulseAnimationController.stop();
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
    _loadingAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _state = ListState.disposed;
    _loadingAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      // Cache theme and provider access
      _cupertinoTheme = CupertinoTheme.of(context);
      _authProvider = Provider.of<AuthenticationProvider>(context);

      // Cache frequently used values
      _primaryColor = AppColors().primaryColor;
      _titleTextStyle = TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _primaryColor,
      );

      if (_authProvider.isAuthenticated) {
        _fetchData();
      } else {
        _state = ListState.done;
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _recommendationsProvider,
      child: Consumer<AIRecommendationsProvider>(
        builder: (context, provider, child) {
          // Full screen loading
          if (_state == ListState.loading) {
            return CupertinoPageScaffold(
              child: _AILoadingWidget(
                loadingAnimationController: _loadingAnimationController,
                pulseAnimationController: _pulseAnimationController,
                primaryColor: _primaryColor,
              ),
            );
          }

          // Not authenticated state
          if (!_authProvider.isAuthenticated) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: const Text("Smart Recommendations"),
                backgroundColor: _cupertinoTheme.barBackgroundColor,
                brightness: _cupertinoTheme.brightness,
              ),
              child: _buildNotAuthenticatedState(),
            );
          }

          // Calculate dates once
          final startDate = DateTime.tryParse(_createdAt ?? '');
          final deadlineDayRange =
              _authProvider.basicUserInfo?.isPremium == true ? 3 : 10;
          final endDate = startDate?.add(Duration(days: deadlineDayRange));

          // Custom navigation bar for done state
          if (_state == ListState.done) {
            return CupertinoPageScaffold(
              navigationBar: _buildDoneStateNavigationBar(endDate),
              child: _buildMainContent(provider),
            );
          }

          // Default navigation bar for other states
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: const Text("Smart Recommendations"),
              backgroundColor: _cupertinoTheme.barBackgroundColor,
              brightness: _cupertinoTheme.brightness,
            ),
            child: Column(
              children: [
                // Header with AI chat bubble (only for non-done states)
                _buildHeader(endDate),

                // Main content
                Expanded(
                  child: _buildMainContent(provider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  CupertinoNavigationBar _buildDoneStateNavigationBar(DateTime? endDate) {
    return CupertinoNavigationBar(
      backgroundColor: _cupertinoTheme.barBackgroundColor,
      brightness: _cupertinoTheme.brightness,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _robotCircleAvatar(context, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              "Recommendations",
              style: _titleTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      middle: endDate != null ? _buildCompactCountdownTimer(endDate) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Info button
          CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 32,
            onPressed: () {
              showCupertinoModalBottomSheet(
                context: context,
                barrierColor: CupertinoColors.white.withValues(alpha: 0.1),
                builder: (_) => _buildInfoSheet(),
              );
            },
            child: const Icon(
              CupertinoIcons.info_circle,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotAuthenticatedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _robotCircleAvatar(context, size: 60),
            const SizedBox(height: 24),
            const Text(
              "🤖 AI Recommendations",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Get personalized recommendations based on your watch history and preferences.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: CupertinoColors.systemGrey,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _cupertinoTheme.onBgColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemGrey.withOpacity(0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    CupertinoIcons.lock_fill,
                    size: 32,
                    color: CupertinoColors.systemGrey,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Login Required",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "You need to be logged in to get AI-powered recommendations tailored to your taste.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CupertinoButton.filled(
                    child: const Text(
                      "Login Now",
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        CupertinoPageRoute(
                          builder: (_) => LoginPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(DateTime? endDate) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _robotCircleAvatar(context),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BubbleSpecialOne(
                  text: _state == ListState.done
                      ? "Here are your personalized recommendations! Tap the buttons to save for later or mark as not interested."
                      : (_state == ListState.error
                          ? _error!
                          : (_state == ListState.empty
                              ? "Cannot generate recommendations. Please try again later."
                              : "Analyzing your preferences...")),
                  color: _cupertinoTheme.onBgColor,
                  tail: true,
                  isSender: false,
                  textStyle: TextStyle(
                    color: _cupertinoTheme.bgTextColor,
                    fontSize: 15,
                  ),
                ),
                if (endDate != null && _state == ListState.done) ...[
                  const SizedBox(height: 12),
                  _buildCountdownTimer(endDate),
                ],
              ],
            ),
          ),
          CupertinoButton(
            child: const Icon(CupertinoIcons.info_circle),
            onPressed: () {
              showCupertinoModalBottomSheet(
                context: context,
                barrierColor: CupertinoColors.white.withValues(alpha: 0.1),
                builder: (_) => _buildInfoSheet(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownTimer(DateTime endDate) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cupertinoTheme.onBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.clock,
            size: 16,
            color: _primaryColor,
          ),
          const SizedBox(width: 8),
          const Text(
            "Next refresh in: ",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          _CustomCountdownTimer(
            key: ValueKey('main_timer_${endDate.millisecondsSinceEpoch}'),
            endDate: endDate,
            primaryColor: _primaryColor,
            fontSize: 13,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(AIRecommendationsProvider provider) {
    switch (_state) {
      case ListState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  size: 64,
                  color: CupertinoColors.systemRed,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Something went wrong",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _error ?? "Unknown error occurred",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                const SizedBox(height: 24),
                CupertinoButton.filled(
                  onPressed: _fetchData,
                  child: const Text(
                    "Try Again",
                    style: TextStyle(
                      color: CupertinoColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      case ListState.done:
        return Column(
          children: [
            // Premium promotion banner
            if (_authProvider.basicUserInfo?.isPremium != true)
              _buildPremiumPromoBanner(),

            // Recommendations grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GridView.builder(
                  itemCount: provider.items.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemBuilder: (context, index) {
                    final content = provider.items[index];
                    final contentType = ContentType.values
                        .where(
                          (element) => content.contentType == element.request,
                        )
                        .first;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 2,
                      ),
                      child: AISuggestionContentCell(
                        suggestion: content,
                        provider: provider,
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder: (_) {
                                return DetailsPage(
                                  id: content.id,
                                  contentType: contentType,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPremiumPromoBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _primaryColor.withValues(alpha: 0.1),
            _primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _primaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FaIcon(
              FontAwesomeIcons.crown,
              color: _primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upgrade to Premium",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Get recommendations every 3 days instead of 10",
                  style: TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: _primaryColor,
            borderRadius: BorderRadius.circular(8),
            child: const Text(
              "Upgrade",
              style: TextStyle(
                color: CupertinoColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                CupertinoPageRoute(
                  builder: (_) => const OffersSheet(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSheet() {
    final isPremium = _authProvider.basicUserInfo?.isPremium == true;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                _robotCircleAvatar(context, size: 30),
                const SizedBox(width: 12),
                const Text(
                  "AI Recommendations",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Smart Analysis
            _buildEnhancedInfoItem(
              CupertinoIcons.sparkles,
              "🧠 Smart Analysis",
              "Our AI analyzes your complete watch history, ratings, and viewing patterns to discover content that perfectly matches your taste.",
            ),
            const SizedBox(height: 20),

            // Refresh Schedule - More promotional
            _buildEnhancedInfoItem(
              CupertinoIcons.clock,
              isPremium ? "⚡ Premium Schedule" : "⏰ Refresh Schedule",
              isPremium
                  ? "You get fresh, personalized recommendations every 3 days! Premium users enjoy 2x faster updates for the latest discoveries."
                  : "Free users get new recommendations every 10 days. Upgrade to Premium for recommendations every 3 days - that's 2x more discoveries!",
              isPromotional: !isPremium,
            ),
            const SizedBox(height: 20),

            // Personalization
            _buildEnhancedInfoItem(
              CupertinoIcons.hand_thumbsup,
              "🎯 Smart Learning",
              "Use 'Later' and 'Not Interested' buttons to teach our AI your preferences. The more you interact, the better your recommendations become!",
            ),

            // Premium promotion for free users
            if (!isPremium) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _primaryColor.withValues(alpha: 0.15),
                      _primaryColor.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _primaryColor.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _primaryColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.crown,
                            color: _primaryColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Unlock Premium Benefits",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "• Get recommendations every 3 days instead of 10\n• Higher quality AI analysis\n• Priority processing for faster results\n• Unlimited watch later list",
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedInfoItem(
    IconData icon,
    String title,
    String description, {
    bool isPromotional = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPromotional
            ? _primaryColor.withValues(alpha: 0.05)
            : _cupertinoTheme.onBgColor,
        borderRadius: BorderRadius.circular(12),
        border: isPromotional
            ? Border.all(
                color: _primaryColor.withValues(alpha: 0.2),
                width: 1,
              )
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _primaryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: _primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isPromotional ? _primaryColor : null,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _robotCircleAvatar(BuildContext context, {int size = 26}) {
    return CircleAvatar(
      maxRadius: size.toDouble() + 2,
      backgroundColor: _cupertinoTheme.onBgColor,
      foregroundColor: _cupertinoTheme.onBgColor,
      child: FaIcon(
        FontAwesomeIcons.robot,
        color: _primaryColor,
        size: size.toDouble(),
      ),
    );
  }

  Widget _buildCompactCountdownTimer(DateTime endDate) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("Refresh Timer"),
            content: const Text(
              "This timer shows how long until your recommendations refresh with new suggestions based on your latest activity.",
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text("Got it"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _primaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.clock,
              size: 12,
              color: _primaryColor,
            ),
            const SizedBox(width: 4),
            _CustomCountdownTimer(
              key: ValueKey('compact_timer_${endDate.millisecondsSinceEpoch}'),
              endDate: endDate,
              primaryColor: _primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _AILoadingWidget extends StatefulWidget {
  final AnimationController loadingAnimationController;
  final AnimationController pulseAnimationController;
  final Color primaryColor;

  const _AILoadingWidget({
    required this.loadingAnimationController,
    required this.pulseAnimationController,
    required this.primaryColor,
  });

  @override
  State<_AILoadingWidget> createState() => _AILoadingWidgetState();
}

class _AILoadingWidgetState extends State<_AILoadingWidget> {
  int _currentStepIndex = 0;
  late List<String> _loadingSteps;

  @override
  void initState() {
    super.initState();
    _loadingSteps = [
      "🔍 Analyzing your watch history...",
      "🎯 Identifying your preferences...",
      "🤖 AI is processing patterns...",
      "🎬 Finding similar content...",
      "⭐ Calculating match scores...",
      "🎭 Curating recommendations...",
      "✨ Almost ready...",
    ];

    _startStepAnimation();
  }

  void _startStepAnimation() {
    Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      if (mounted && _currentStepIndex < _loadingSteps.length - 1) {
        setState(() {
          _currentStepIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Robot Icon
          AnimatedBuilder(
            animation: widget.pulseAnimationController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (widget.pulseAnimationController.value * 0.1),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.primaryColor.withValues(alpha: 0.8),
                        widget.primaryColor.withValues(alpha: 0.4),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: [
                      BoxShadow(
                        color: widget.primaryColor.withValues(alpha: 0.3),
                        offset: const Offset(0, 8),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(
                    FontAwesomeIcons.robot,
                    size: 60,
                    color: CupertinoColors.white,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          // Loading Progress Indicator
          AnimatedBuilder(
            animation: widget.loadingAnimationController,
            builder: (context, child) {
              return Container(
                width: 200,
                height: 6,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey5,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: widget.loadingAnimationController.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.primaryColor,
                          widget.primaryColor.withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Current Step Text
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Text(
              _loadingSteps[_currentStepIndex],
              key: ValueKey(_currentStepIndex),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Warning Message
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CupertinoColors.systemYellow.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: CupertinoColors.systemYellow.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.exclamationmark_triangle_fill,
                      color: CupertinoColors.systemYellow,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Please Wait",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.systemYellow,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "AI recommendation generation can take 30-60 seconds. Please don't close the app or navigate away until it's complete.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Rotating Loading Dots
          AnimatedBuilder(
            animation: widget.loadingAnimationController,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final delay = index * 0.3;
                  final animationValue =
                      (widget.loadingAnimationController.value + delay) % 1.0;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: widget.primaryColor.withValues(
                        alpha: 0.3 + (animationValue * 0.7),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Custom countdown timer widget that updates every second
class _CustomCountdownTimer extends StatefulWidget {
  final DateTime endDate;
  final Color primaryColor;
  final double fontSize;

  const _CustomCountdownTimer({
    super.key,
    required this.endDate,
    required this.primaryColor,
    this.fontSize = 11,
  });

  @override
  State<_CustomCountdownTimer> createState() => _CustomCountdownTimerState();
}

class _CustomCountdownTimerState extends State<_CustomCountdownTimer> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateTimeLeft();
    _startTimer();
  }

  @override
  void didUpdateWidget(_CustomCountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the end date changed, update the timer
    if (widget.endDate != oldWidget.endDate) {
      _updateTimeLeft();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        _updateTimeLeft();
      }
    });
  }

  void _updateTimeLeft() {
    final now = DateTime.now();
    final difference = widget.endDate.difference(now);

    if (mounted) {
      setState(() {
        _timeLeft = difference.isNegative ? Duration.zero : difference;
      });
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative || duration == Duration.zero) {
      return "Expired";
    }

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (widget.fontSize <= 11) {
      // Compact format for navigation bar
      if (days > 0) {
        return "${days}d ${hours}h ${minutes}m";
      } else if (hours > 0) {
        return "${hours}h ${minutes}m";
      } else if (minutes > 0) {
        return "${minutes}m";
      } else {
        return "${seconds}s";
      }
    } else {
      // Full format for main timer
      if (days > 0) {
        return "${days}d ${hours}h ${minutes}m ${seconds}s";
      } else if (hours > 0) {
        return "${hours}h ${minutes}m ${seconds}s";
      } else if (minutes > 0) {
        return "${minutes}m ${seconds}s";
      } else {
        return "${seconds}s";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(_timeLeft),
      style: TextStyle(
        fontSize: widget.fontSize,
        fontWeight: FontWeight.bold,
        color: widget.primaryColor,
      ),
    );
  }
}
