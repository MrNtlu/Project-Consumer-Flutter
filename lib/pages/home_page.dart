import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/providers/authentication_provider.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/providers/main/preview_provider.dart';
import 'package:watchlistfy/static/constants.dart';
import 'package:watchlistfy/widgets/common/content_selection.dart';
import 'package:watchlistfy/widgets/main/home/anonymous_header.dart';
import 'package:watchlistfy/widgets/main/home/genre_list.dart';
import 'package:watchlistfy/widgets/main/home/info_card.dart';
import 'package:watchlistfy/widgets/main/home/loggedin_header.dart';
import 'package:watchlistfy/widgets/main/home/preview_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticationProvider = Provider.of<AuthenticationProvider>(context);
    final contentProvider = Provider.of<ContentProvider>(context);

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
                const ContentSelection()
              ],
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoSearchTextField(
                keyboardType: TextInputType.name,
              ),
            ),
            const SizedBox(height: 8),
            _previewTitle("🔥 Popular"),
            SizedBox(
              height: 200,
              child: PreviewList(Constants.CONTENT_TAGS[0])
            ),
            const SizedBox(height: 20),
            const InfoCard(),
            const SizedBox(height: 20),
            const GenreList(),
            const SizedBox(height: 8),
            _previewTitle("📆 Upcoming"),
            SizedBox(
              height: 200,
              child: PreviewList(Constants.CONTENT_TAGS[1])
            ),
            const SizedBox(height: 8),
            _previewTitle("❤️ Top Rated"),
            SizedBox(
              height: 200,
              child: PreviewList(Constants.CONTENT_TAGS[2])
            ),
            const SizedBox(height: 8),
            if (contentProvider.selectedContent != ContentType.game)
            _previewTitle("🎭 In Theaters"),
            if (contentProvider.selectedContent != ContentType.game)
            SizedBox(
              height: 200,
              child: PreviewList(Constants.CONTENT_TAGS[3])
            ),
            const SizedBox(height: 8),
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