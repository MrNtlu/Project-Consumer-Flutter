import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/main/preview_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';
import 'package:watchlistfy/widgets/main/home/anonymous_header.dart';
import 'package:watchlistfy/widgets/main/home/loggedin_header.dart';
import 'package:watchlistfy/widgets/main/home/preview_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthenticationProvider>(context);

    Provider.of<PreviewProvider>(context, listen: false).getPreviews();

    return CupertinoPageScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: authenticationProvider.isAuthenticated
                  ?  const LoggedinHeader()
                  : const AnonymousHeader()
                ),
                CupertinoButton(
                  child: Row(
                    children: [
                      Text(
                        "Movie",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: CupertinoTheme.of(context).bgTextColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        CupertinoIcons.arrowtriangle_down_circle_fill,
                        size: 13,
                        color: CupertinoTheme.of(context).bgTextColor,
                      )
                    ],
                  ), 
                  onPressed: () {
        
                  }
                )
              ],
            ),
            const SizedBox(height: 24),
            _previewTitle("🔥 Popular"),
            SizedBox(
              height: 200,
              child: PreviewList()
            ),
            _previewTitle("📆 Upcoming"),
            _previewTitle("❤️ Top Rated"),
            _previewTitle("🎭 In Theaters"),
          ],
        ),
      ),
    );
  }

  Widget _previewTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: GestureDetector(
      onTap: () {

      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
          const Icon(CupertinoIcons.chevron_right)
        ],
      ),
    ),
  );
}