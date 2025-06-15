import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:watchlistfy/models/common/base_responses.dart';
import 'package:watchlistfy/models/common/base_states.dart';
import 'package:watchlistfy/models/common/content_type.dart';
import 'package:watchlistfy/models/main/base_content.dart';
import 'package:watchlistfy/pages/details_page.dart';
import 'package:watchlistfy/providers/content_provider.dart';
import 'package:watchlistfy/providers/main/preview_provider.dart';
import 'package:watchlistfy/static/navigation_provider.dart';
import 'package:watchlistfy/widgets/common/content_cell.dart';

class PreviewList extends StatefulWidget {
  final String contentTag;

  const PreviewList(this.contentTag, {super.key});

  @override
  State<PreviewList> createState() => _PreviewListState();
}

class _PreviewListState extends State<PreviewList> {
  bool isInitialized = false;
  late final PreviewProvider _previewProvider;
  late final ContentProvider _contentProvider;
  late final ScrollController _scrollController;

  // Cache computed values to avoid repeated calculations
  BasePreviewResponse<BaseContent>? _cachedPreview;
  ContentType? _cachedContentType;
  List<BaseContent>? _cachedData;

  void onContentChange() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
    // Clear cache when content changes
    _cachedPreview = null;
    _cachedContentType = null;
    _cachedData = null;
  }

  @override
  void didChangeDependencies() {
    if (!isInitialized) {
      _scrollController = ScrollController();
      _previewProvider = Provider.of<PreviewProvider>(context);
      _contentProvider = Provider.of<ContentProvider>(context);
      _contentProvider.addListener(onContentChange);
      isInitialized = true;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _contentProvider.removeListener(onContentChange);
    _scrollController.dispose();
    super.dispose();
  }

  // Optimized method to get preview data with caching
  BasePreviewResponse<BaseContent> _getPreviewData() {
    final currentContentType = _contentProvider.selectedContent;

    if (_cachedPreview != null && _cachedContentType == currentContentType) {
      return _cachedPreview!;
    }

    BasePreviewResponse<BaseContent> preview;
    switch (currentContentType) {
      case ContentType.movie:
        preview = _previewProvider.moviePreview;
        break;
      case ContentType.tv:
        preview = _previewProvider.tvPreview;
        break;
      case ContentType.anime:
        preview = _previewProvider.animePreview;
        break;
      default:
        preview = _previewProvider.gamePreview;
        break;
    }

    _cachedPreview = preview;
    _cachedContentType = currentContentType;
    return preview;
  }

  // Optimized method to get list data with caching
  List<BaseContent> _getListData() {
    if (_cachedData != null) {
      return _cachedData!;
    }

    final preview = _getPreviewData();
    List<BaseContent> data;

    switch (widget.contentTag) {
      case "popular":
        data = preview.popular;
        break;
      case "upcoming":
        data = preview.upcoming;
        break;
      case "extra":
        data = preview.extra ?? [];
        break;
      default:
        data = preview.top;
        break;
    }

    _cachedData = data;
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = _previewProvider.networkState == NetworkState.success;

    if (!isSuccess) {
      return _buildHighPerformanceLoadingList();
    }

    final listData = _getListData();
    final listCount = listData.length;

    if (listCount == 0) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      itemCount: listCount,
      itemExtent: 140, // Fixed item width for better performance
      itemBuilder: (context, index) {
        final data = listData[index];
        return _OptimizedPreviewItem(
          key: ValueKey('${widget.contentTag}_${data.id}'),
          data: data,
          contentType: _contentProvider.selectedContent,
          index: index,
        );
      },
    );
  }

  Widget _buildHighPerformanceLoadingList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 20,
      itemExtent: 140,
      itemBuilder: (context, index) {
        return Padding(
          padding: index == 0
              ? const EdgeInsets.only(left: 8, right: 6)
              : const EdgeInsets.symmetric(horizontal: 6),
          child: SizedBox(
            height: 200,
            child: _HighPerformanceLoadingCell(
              aspectRatio: _contentProvider.selectedContent != ContentType.game
                  ? 2 / 3
                  : 16 / 9,
              index: index,
            ),
          ),
        );
      },
    );
  }
}

// Ultra-high performance loading cell - no animations, just static gradients
class _HighPerformanceLoadingCell extends StatelessWidget {
  final double aspectRatio;
  final int index;

  // Pre-computed gradient colors for different loading states
  static const List<Color> _gradientColors = [
    CupertinoColors.systemGrey6,
    CupertinoColors.systemGrey5,
    CupertinoColors.systemGrey4,
  ];

  const _HighPerformanceLoadingCell({
    required this.aspectRatio,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // Use index to create subtle variation without animation
    final colorIndex = index % 3;
    final baseColor = _gradientColors[colorIndex];

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: RepaintBoundary(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  baseColor,
                  baseColor.withValues(alpha: 0.7),
                  baseColor.withValues(alpha: 0.5),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Center(
              child: Icon(
                CupertinoIcons.photo,
                size: 24,
                color: CupertinoColors.systemGrey2.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Optimized preview item as separate widget to reduce rebuilds
class _OptimizedPreviewItem extends StatelessWidget {
  final BaseContent data;
  final ContentType contentType;
  final int index;

  const _OptimizedPreviewItem({
    required this.data,
    required this.contentType,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Pre-compute values to avoid repeated calculations
    final optimizedImageUrl = data.imageUrl.replaceFirst("original", "w300");
    final isFirstItem = index == 0;

    return RepaintBoundary(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute(
              builder: (_) => DetailsPage(
                id: data.id,
                contentType: contentType,
              ),
              maintainState: NavigationTracker().shouldMaintainState(),
            ),
          );
        },
        child: Padding(
          padding: isFirstItem
              ? const EdgeInsets.only(left: 8, right: 6)
              : const EdgeInsets.symmetric(horizontal: 6),
          child: SizedBox(
            height: 200,
            child: ContentCell(
              optimizedImageUrl,
              data.titleEn,
              cacheHeight: 600, // Reduced cache size for better memory usage
              cacheWidth: 400,
            ),
          ),
        ),
      ),
    );
  }
}
