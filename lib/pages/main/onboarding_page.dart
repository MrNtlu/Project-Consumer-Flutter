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
    ValueNotifier<int> pageIndexNotifier = ValueNotifier(0);
    final pageController = PageController(initialPage: 0);

    return CupertinoPageScaffold(
        child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
          valueListenable: pageIndexNotifier,
          builder: (context, pageIndex, child) {
            return Column(
              children: [
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
                        content.image,
                        content.title,
                        content.description,
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    ...List.generate(
                      onboardingList.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: DotIndicator(
                          isActive: index == pageIndex,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (pageIndex != 0)
                      CupertinoButton(
                        child: const Text(
                          "Previous",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.systemGrey2),
                        ),
                        onPressed: () {
                          pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                        },
                      ),
                    CupertinoButton(
                      child: Text(
                        pageIndex != onboardingList.length - 1
                            ? "Next"
                            : "Done",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        if (pageIndex != onboardingList.length - 1) {
                          pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                        } else {
                          SharedPref().setIsIntroductionPresented(true);
                          context.goNamed(TabsPage.routeName);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                )
              ],
            );
          },
        ),
      ),
    ));
  }
}

class DotIndicator extends StatelessWidget {
  final bool isActive;

  const DotIndicator({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isActive ? 16 : 8,
      width: 6,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors().primaryColor
            : AppColors().primaryColor.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}

class Onboard {
  final IconData image;
  final String title;
  final String description;

  Onboard({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<Onboard> onboardingList = [
  Onboard(
    image: Icons.assistant_rounded,
    title: "AI Assistant",
    description:
        "AI Assistant will suggest new content by analyzing your list.",
  ),
  Onboard(
    image: CupertinoIcons.list_bullet_below_rectangle,
    title: "User List",
    description:
        "Manage your list and mark, rate, and track your progress in one place!",
  ),
  Onboard(
    image: CupertinoIcons.folder_fill,
    title: "Custom List",
    description:
        "You can create your own lists and share with other people! e.g. Top 10 Action Content",
  ),
  Onboard(
    image: CupertinoIcons.time,
    title: "Watch Later",
    description: "Mark it and save it for later watching and playing.",
  ),
  Onboard(
    image: CupertinoIcons.folder_fill,
    title: "Enjoy 🤗",
    description:
        "Once you've signed in, you can access your Custom List, User List and Watch Later from Profile.",
  )
];

class OnboardingContent extends StatelessWidget {
  final IconData image;
  final String title;
  final String description;

  const OnboardingContent(
    this.image,
    this.title,
    this.description, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Icon(image, size: 200),
        const Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
