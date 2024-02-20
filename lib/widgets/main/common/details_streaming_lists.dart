import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watchlistfy/models/main/common/streaming.dart';
import 'package:watchlistfy/models/main/common/streaming_platform.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/main/common/details_title.dart';

class DetailsStreamingLists extends StatelessWidget {
  final List<Streaming> streaming;
  final String tmdbId;
  final String contentType;

  const DetailsStreamingLists(this.streaming, this.tmdbId, this.contentType, {super.key});

  @override
  Widget build(BuildContext context) {
    final globalProvider = Provider.of<GlobalProvider>(context);
    final data = streaming.where((element) => element.countryCode == globalProvider.selectedCountryCode).firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetailsSubTitle("Streaming"),
        SizedBox(
          height: data != null && data.streamingPlatforms != null ? 90 : 50,
          child: _streamingList(
            data != null && data.streamingPlatforms != null, 
            data?.streamingPlatforms,
            globalProvider.selectedCountryCode,
          ),
        ),
        const DetailsSubTitle("Buy"),
        SizedBox(
          height: data != null && data.buyOptions != null ? 90 : 50,
          child: _streamingList(
            data != null && data.buyOptions != null, 
            data?.buyOptions,
            globalProvider.selectedCountryCode,
          ),
        ),
        const DetailsSubTitle("Rent"),
        SizedBox(
          height: data != null && data.rentOptions != null ? 90 : 50,
          child: _streamingList(
            data != null && data.rentOptions != null, 
            data?.rentOptions,
            globalProvider.selectedCountryCode,
          ),
        ),
      ],
    );
  }

  Widget _streamingList(
    bool isNotNull,
    List<StreamingPlatform>? data,
    String countryCode,
  ) => isNotNull
  ? ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: data!.length,
    itemBuilder: (context, index) {
      final item = data[index];
  
      return GestureDetector(
        onTap: () async {
          if (tmdbId.isNotEmpty) {
            final url = Uri.parse(platformURL(contentType, countryCode));
            if (!await launchUrl(url)) {
              if (context.mounted) {
                showCupertinoDialog(context: context, builder: (_) => const ErrorDialog("Not available, sorry."));
              }
            }
          }
        },
        child: _streamingCell(item),
      );
    },
  )
  : const Center(child: Text("Not available in your region."));

  Widget _streamingCell(StreamingPlatform item) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 100,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.logo,
              fit: BoxFit.cover,
              key: ValueKey<String>(item.logo),
              cacheKey: item.logo,
              height: 64,
              width: 64,
              maxHeightDiskCache: 190,
              maxWidthDiskCache: 190,
              errorListener: (_) {},
            ),
          ),
          const SizedBox(height: 6),
          AutoSizeText(
            item.name,
            maxLines: 1,
            maxFontSize: 16,
            minFontSize: 13,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );

  String platformURL(String contentType, String countryCode) => "https://www.themoviedb.org/$contentType/$tmdbId/watch?locale=$countryCode";
}
