import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/models/main/common/trailer.dart';
import 'package:watchlistfy/pages/main/trailer_page.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/custom_divider.dart';

class TrailerSheet extends StatelessWidget {
  final List<Trailer> trailers;
  const TrailerSheet(this.trailers, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).bgColor,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Trailers", style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
                  if (trailers.length > 4)
                  Text("Scroll to See All", style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors().primaryColor
                  )),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 200,
              child: ListView.separated(
                separatorBuilder: (_, __) => const CustomDivider(height: 0.7),
                itemCount: trailers.length,
                itemBuilder: (context, index) {
                  final trailer = trailers[index];

                  return CupertinoListTile(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(builder: (_) {
                        return TrailerPage(trailerURL: "https://www.youtube.com/watch?v=${trailer.key ?? ''}");
                      }));
                    },
                    trailing: const Icon(CupertinoIcons.play_arrow_solid),
                    title: Text(
                      trailer.name ?? 'Trailer',
                      maxLines: 2,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15
                      ),
                    ),
                    subtitle: Text(
                      trailer.type ?? 'Trailer',
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 13
                      ),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}