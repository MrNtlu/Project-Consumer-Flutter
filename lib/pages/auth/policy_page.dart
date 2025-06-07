import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:watchlistfy/static/colors.dart';

class PolicyPage extends StatelessWidget {
  final bool _isPrivacyPolicy;

  const PolicyPage(this._isPrivacyPolicy, {super.key});

  Future<String> loadAsset(BuildContext context) async {
    var file = _isPrivacyPolicy ? "privacy_policy" : "terms_conditions";
    return await DefaultAssetBundle.of(context)
        .loadString("assets/policies/$file.md");
  }

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);
    loadAsset(context).then((value) => null);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: FutureBuilder(
        future: loadAsset(context),
        builder: (_, mdSnapshot) {
          if (mdSnapshot.connectionState == ConnectionState.done) {
            return SafeArea(
              child: Markdown(
                styleSheet:
                    MarkdownStyleSheet.fromCupertinoTheme(CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    textStyle: TextStyle(
                        color: cupertinoTheme.bgTextColor, fontSize: 14),
                  ),
                )),
                data: mdSnapshot.data as String,
              ),
            );
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }
}
