import 'package:watchlistfy/models/main/common/streaming_platform.dart';

class Streaming {
  final String countryCode;
  final List<StreamingPlatform>? buyOptions;
  final List<StreamingPlatform>? rentOptions;
  final List<StreamingPlatform>? streamingPlatforms;

  Streaming(
    this.countryCode,
    this.buyOptions,
    this.rentOptions,
    this.streamingPlatforms
  );
}