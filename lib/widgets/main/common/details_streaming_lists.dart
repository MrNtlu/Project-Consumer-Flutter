import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:watchlistfy/services/cache_manager_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watchlistfy/models/main/common/streaming.dart';
import 'package:watchlistfy/models/main/common/streaming_platform.dart';
import 'package:watchlistfy/providers/main/global_provider.dart';
import 'package:watchlistfy/static/colors.dart';
import 'package:watchlistfy/widgets/common/error_dialog.dart';
import 'package:watchlistfy/widgets/common/cupertino_chip.dart';

enum StreamingType { stream, buy, rent }

class DetailsStreamingLists extends StatefulWidget {
  final List<Streaming> streaming;
  final String tmdbId;
  final String contentType;

  const DetailsStreamingLists(
    this.streaming,
    this.tmdbId,
    this.contentType, {
    super.key,
  });

  @override
  State<DetailsStreamingLists> createState() => _DetailsStreamingListsState();
}

class _DetailsStreamingListsState extends State<DetailsStreamingLists> {
  StreamingType _selectedType = StreamingType.stream;
  late final List<StreamingType> _availableTypes;
  late final Streaming? _data;
  late final String _countryCode;
  late final AppColors _appColors;

  @override
  void initState() {
    super.initState();
    _appColors = AppColors();
    _initializeData();
  }

  void _initializeData() {
    final globalProvider = Provider.of<GlobalProvider>(context, listen: false);
    _countryCode = globalProvider.selectedCountryCode;

    _data = widget.streaming
        .where((element) => element.countryCode == _countryCode)
        .firstOrNull;

    _availableTypes = _computeAvailableTypes();

    if (_availableTypes.isNotEmpty &&
        !_availableTypes.contains(_selectedType)) {
      _selectedType = _availableTypes.first;
    }
  }

  List<StreamingType> _computeAvailableTypes() {
    final types = <StreamingType>[];
    if (_data?.streamingPlatforms?.isNotEmpty ?? false) {
      types.add(StreamingType.stream);
    }
    if (_data?.buyOptions?.isNotEmpty ?? false) {
      types.add(StreamingType.buy);
    }
    if (_data?.rentOptions?.isNotEmpty ?? false) {
      types.add(StreamingType.rent);
    }
    return types;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasAnyContent) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: _buildNoContentAvailable(context),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        _buildTypeSelector(context),
        const SizedBox(height: 16),
        _buildSelectedContent(context),
      ],
    );
  }

  bool get _hasAnyContent {
    if (_data == null) return false;

    return (_data.streamingPlatforms?.isNotEmpty ?? false) ||
        (_data.buyOptions?.isNotEmpty ?? false) ||
        (_data.rentOptions?.isNotEmpty ?? false);
  }

  Widget _buildTypeSelector(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _availableTypes.length,
        itemBuilder: (context, index) {
          final type = _availableTypes[index];
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 3, right: 3),
            child: CupertinoChip(
              isSelected: type == _selectedType,
              size: 14,
              cornerRadius: 12,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              selectedBGColor: cupertinoTheme.profileButton,
              selectedTextColor: _appColors.primaryColor,
              onSelected: (_) => _onTypeSelected(type),
              label: _getTypeLabel(type),
            ),
          );
        },
      ),
    );
  }

  void _onTypeSelected(StreamingType type) {
    if (type != _selectedType) {
      setState(() {
        _selectedType = type;
      });
    }
  }

  String _getTypeLabel(StreamingType type) {
    return switch (type) {
      StreamingType.stream => 'Stream',
      StreamingType.buy => 'Buy',
      StreamingType.rent => 'Rent',
    };
  }

  Widget _buildSelectedContent(BuildContext context) {
    final platforms = _getCurrentPlatforms();

    if (platforms.isEmpty) {
      return _buildEmptySection(context);
    }

    return _buildHorizontalPlatformList(platforms, context);
  }

  List<StreamingPlatform> _getCurrentPlatforms() {
    if (_data == null) return [];

    return switch (_selectedType) {
      StreamingType.stream => _data.streamingPlatforms ?? [],
      StreamingType.buy => _data.buyOptions ?? [],
      StreamingType.rent => _data.rentOptions ?? [],
    };
  }

  Widget _buildEmptySection(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(
            CupertinoIcons.tv,
            size: 24,
            color: cupertinoTheme.bgTextColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 8),
          Text(
            "No ${_getTypeLabel(_selectedType).toLowerCase()} options available",
            style: TextStyle(
              fontSize: 14,
              color: cupertinoTheme.bgTextColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoContentAvailable(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cupertinoTheme.onBgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: cupertinoTheme.bgTextColor.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.tv,
              size: 32,
              color: cupertinoTheme.bgTextColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              "No streaming options available",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: cupertinoTheme.bgTextColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Not available in your region",
              style: TextStyle(
                fontSize: 14,
                color: cupertinoTheme.bgTextColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalPlatformList(
      List<StreamingPlatform> platforms, BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: platforms.length,
        itemBuilder: (context, index) {
          final platform = platforms[index];
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 8, right: 8),
            child: _buildStreamingPlatformCard(platform, cupertinoTheme),
          );
        },
      ),
    );
  }

  Widget _buildStreamingPlatformCard(
      StreamingPlatform platform, CupertinoThemeData cupertinoTheme) {
    return GestureDetector(
      onTap: _launchPlatformURL,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: cupertinoTheme.onBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: cupertinoTheme.bgTextColor.withValues(alpha: 0.15),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPlatformLogo(platform, cupertinoTheme),
            const SizedBox(width: 8),
            Text(
              platform.name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: cupertinoTheme.bgTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformLogo(
      StreamingPlatform platform, CupertinoThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: platform.logo,
        fit: BoxFit.cover,
        key: ValueKey<String>(platform.logo),
        cacheKey: platform.logo,
        height: 28,
        width: 28,
        cacheManager: CustomCacheManager(),
        maxHeightDiskCache: 84,
        maxWidthDiskCache: 84,
        errorListener: (_) {},
        errorWidget: (context, url, error) => Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: theme.bgTextColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            CupertinoIcons.tv,
            size: 16,
            color: theme.bgTextColor.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Future<void> _launchPlatformURL() async {
    if (widget.tmdbId.isNotEmpty) {
      final url = Uri.parse(_buildPlatformURL());
      if (!await launchUrl(url)) {
        if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (_) => const ErrorDialog("Not available, sorry."),
          );
        }
      }
    }
  }

  String _buildPlatformURL() {
    return "https://www.themoviedb.org/${widget.contentType}/${widget.tmdbId}/watch?locale=$_countryCode";
  }
}
