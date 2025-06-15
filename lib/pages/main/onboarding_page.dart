import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watchlistfy/pages/tabs_page.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/static/shared_pref.dart';

class OnboardingPage extends StatelessWidget {
  static const routeName = "onboarding";
  static const routePath = "/onboarding";

  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageIndexNotifier = ValueNotifier<int>(0);
    final pageController = PageController(initialPage: 0);

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ValueListenableBuilder<int>(
            valueListenable: pageIndexNotifier,
            builder: (context, pageIndex, child) {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  _ProgressIndicator(currentIndex: pageIndex),
                  const SizedBox(height: 40),
                  Expanded(
                    child: PageView.builder(
                      itemCount: onboardingList.length,
                      controller: pageController,
                      onPageChanged: (index) {
                        pageIndexNotifier.value = index;
                      },
                      itemBuilder: (context, index) {
                        final content = onboardingList[index];
                        return OnboardingContent(
                          icon: content.icon,
                          gradient: content.gradient,
                          title: content.title,
                          subtitle: content.subtitle,
                          description: content.description,
                          features: content.features,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _NavigationButtons(
                    pageIndex: pageIndex,
                    pageController: pageController,
                    totalPages: onboardingList.length,
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final int currentIndex;

  const _ProgressIndicator({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingList.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: index == currentIndex ? 32 : 8,
          decoration: BoxDecoration(
            color: index == currentIndex
                ? AppColors().primaryColor
                : AppColors().primaryColor.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  final int pageIndex;
  final PageController pageController;
  final int totalPages;

  const _NavigationButtons({
    required this.pageIndex,
    required this.pageController,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    final isLastPage = pageIndex == totalPages - 1;

    return Row(
      children: [
        if (pageIndex > 0)
          Expanded(
            child: CupertinoButton(
              onPressed: () {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.chevron_left,
                    size: 16,
                    color: CupertinoColors.systemGrey,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (pageIndex > 0) const SizedBox(width: 16),
        Expanded(
          flex: pageIndex > 0 ? 2 : 1,
          child: CupertinoButton.filled(
            onPressed: () {
              if (isLastPage) {
                SharedPref().setIsIntroductionPresented(true);
                context.goNamed(TabsPage.routeName);
              } else {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            borderRadius: BorderRadius.circular(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLastPage ? "Get Started" : "Continue",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isLastPage
                      ? CupertinoIcons.rocket_fill
                      : CupertinoIcons.chevron_right,
                  size: 18,
                  color: CupertinoColors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final IconData icon;
  final List<Color> gradient;
  final String title;
  final String subtitle;
  final String description;
  final List<String> features;

  const OnboardingContent({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.features,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          _IconContainer(
            icon: icon,
            gradient: gradient,
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: gradient.first,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 32),
          ...features.map(
            (feature) => _FeatureItem(
              feature: feature,
              color: gradient.first,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _IconContainer extends StatelessWidget {
  final IconData icon;
  final List<Color> gradient;

  const _IconContainer({
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withValues(alpha: 0.3),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 70,
        color: CupertinoColors.white,
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String feature;
  final Color color;

  const _FeatureItem({
    required this.feature,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              CupertinoIcons.checkmark,
              size: 14,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              feature,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingItem {
  final IconData icon;
  final List<Color> gradient;
  final String title;
  final String subtitle;
  final String description;
  final List<String> features;

  const OnboardingItem({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.features,
  });
}

const List<OnboardingItem> onboardingList = [
  OnboardingItem(
    icon: CupertinoIcons.sparkles,
    gradient: [
      Color(0xFF667eea),
      Color(0xFF764ba2),
    ],
    title: "Smart Recommendations",
    subtitle: "Powered by AI",
    description:
        "Our AI analyzes your viewing habits across movies, TV shows, anime, and games to suggest content you'll love.",
    features: [
      "Personalized suggestions based on your taste",
      "Cross-platform recommendations (Movies, TV, Anime, Games)",
      "Premium users get recommendations every 3 days",
      "Free users get weekly recommendations",
    ],
  ),
  OnboardingItem(
    icon: CupertinoIcons.list_bullet_below_rectangle,
    gradient: [
      Color(0xFF11998e),
      Color(0xFF38ef7d),
    ],
    title: "Your Personal Watchlist",
    subtitle: "Track Everything in One Place",
    description:
        "Organize your entertainment with detailed tracking for movies, TV series, anime episodes, and gaming hours.",
    features: [
      "Rate and review your content",
      "Track watch progress and episodes",
      "Mark as watching, completed, or dropped",
      "Sync across all your devices",
    ],
  ),
  // Custom Lists - Coming Soon
  // OnboardingItem(
  //   icon: CupertinoIcons.folder_fill,
  //   gradient: [
  //     Color(0xFFee0979),
  //     Color(0xFFff6a00),
  //   ],
  //   title: "Custom Collections",
  //   subtitle: "Create & Share Lists",
  //   description: "Build themed collections like 'Best Action Movies' or 'Must-Watch Anime'.",
  //   features: [
  //     "Create unlimited custom lists",
  //     "Organize by themes or genres",
  //     "Personal collection management",
  //     "Easy content discovery",
  //   ],
  // ),
  OnboardingItem(
    icon: CupertinoIcons.clock_fill,
    gradient: [
      Color(0xFF8360c3),
      Color(0xFF2ebf91),
    ],
    title: "Save for Later",
    subtitle: "Never Miss Great Content",
    description:
        "Bookmark interesting content to watch or play later. Perfect for managing your entertainment backlog.",
    features: [
      "Quick bookmark from any detail page",
      "Organize by content type",
      "Set reminders for upcoming releases",
      "Move directly to your active list",
    ],
  ),
  OnboardingItem(
    icon: CupertinoIcons.heart_fill,
    gradient: [
      Color(0xFFfc466b),
      Color(0xFF3f5efb),
    ],
    title: "Welcome to Watchlistfy!",
    subtitle: "Your Entertainment Hub",
    description:
        "Join users who trust Watchlistfy to manage their entertainment journey. Ready to discover your next favorite content?",
    features: [
      "Free to use with premium features available",
      "Regular updates with new content",
      "Cross-platform availability",
      "Smart tracking and recommendations",
    ],
  ),
];
