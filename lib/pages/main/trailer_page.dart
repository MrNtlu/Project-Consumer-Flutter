import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerPage extends StatelessWidget {
  final String trailerURL;
  const TrailerPage({required this.trailerURL, super.key});

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayer.convertUrlToId(trailerURL);

    final controller = YoutubePlayerController(
      initialVideoId: videoId ?? trailerURL.split("v=")[1],
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        showLiveFullscreenButton: false,
        controlsVisibleAtStart: true
      ),
    );

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
        aspectRatio: 16/9,
        bottomActions: [
          const SizedBox(width: 14.0),
          CurrentPosition(),
          const SizedBox(width: 8.0),
          ProgressBar(
            isExpanded: true,
            colors: ProgressBarColors(
              playedColor: CupertinoColors.systemRed,
              handleColor: AppColors().primaryColor,
            ),
          ),
          RemainingDuration(),
          const PlaybackSpeedButton(),
        ],
      ),
    );
  }
}