import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/pages/home_page.dart';
import 'package:watchlistfy/pages/settings_page.dart';

class TabsPage extends StatefulWidget {
  static const routeName = "/";

  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _selectedPageIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SettingsPage(),
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        backgroundColor: CupertinoTheme.of(context).barBackgroundColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house_fill),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings_solid),
            label: "Settings",
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return SafeArea(
              child: _pages[index]
            );
          },
        );
      },
    );
  }
}
