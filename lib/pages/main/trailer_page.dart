import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerPage extends StatelessWidget {
  final String trailerURL;
  const TrailerPage({required this.trailerURL, super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final orientation = mediaQuery.orientation;

    final videoId = YoutubePlayer.convertUrlToId(trailerURL);

    final controller = YoutubePlayerController(
      initialVideoId: videoId ?? trailerURL.split("v=")[1],
      flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          showLiveFullscreenButton: false,
          controlsVisibleAtStart: true),
    );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        middle: orientation == Orientation.portrait
            ? const Text("Rotate for Better Experience",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14))
            : null,
      ),
      child: SafeArea(
        child: Center(
          child: YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
            aspectRatio: 16 / 9,
            bottomActions: [
              const SizedBox(width: 14.0),
              const CurrentPosition(),
              const SizedBox(width: 8.0),
              ProgressBar(
                isExpanded: true,
                colors: ProgressBarColors(
                  playedColor: CupertinoColors.systemRed,
                  handleColor: AppColors().primaryColor,
                ),
              ),
              const RemainingDuration(),
              const PlaybackSpeedButton(),
            ],
          ),
        ),
      ),
    );
  }
}
