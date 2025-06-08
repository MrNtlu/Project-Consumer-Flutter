import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:watchlistfy/static/colors.dart';

class ImagePage extends StatefulWidget {
  final String imageUrl;
  final String? heroTag;
  final BoxFit? fit;

  const ImagePage(
    this.imageUrl, {
    super.key,
    this.heroTag,
    this.fit,
  });

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage>
    with SingleTickerProviderStateMixin {
  late final TransformationController _transformationController;
  late final AnimationController _animationController;
  late final CupertinoThemeData _theme;

  // Performance optimization: Cache the image key
  late final String _cacheKey;

  // Track loading state for better UX
  bool _hasError = false;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Pre-compute cache key for performance
    _cacheKey = widget.imageUrl.hashCode.toString();

    // Configure HTTP client to handle certificate issues
    _configureHttpOverrides();
  }

  void _configureHttpOverrides() {
    HttpOverrides.global = _CustomHttpOverrides();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _theme = CupertinoTheme.of(context);
    super.didChangeDependencies();
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  void _onDoubleTap() {
    final Matrix4 currentTransform = _transformationController.value;
    final bool isZoomed = currentTransform.getMaxScaleOnAxis() > 1.0;

    if (isZoomed) {
      _resetZoom();
    } else {
      _transformationController.value = Matrix4.identity()..scale(2.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: _theme.onBgColor,
        border: null,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _hasError ? null : _resetZoom,
          child: FaIcon(
            FontAwesomeIcons.arrowsRotate,
            color: _theme.bgTextColor,
            size: 20,
          ),
        ),
      ),
      backgroundColor: _theme.bgColor,
      child: SafeArea(
        child: _buildImageViewer(),
      ),
    );
  }

  Widget _buildImageViewer() {
    final imageWidget = _buildOptimizedImage();

    // Use Hero animation if heroTag is provided
    final Widget content = widget.heroTag != null
        ? Hero(
            tag: widget.heroTag!,
            child: imageWidget,
          )
        : imageWidget;

    return GestureDetector(
      onDoubleTap: _hasError ? null : _onDoubleTap,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: InteractiveViewer(
          transformationController: _transformationController,
          panEnabled: !_hasError,
          minScale: 0.5,
          maxScale: 4.0,
          clipBehavior: Clip.none,
          child: content,
        ),
      ),
    );
  }

  Widget _buildOptimizedImage() {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl.replaceAll(RegExp(r'w\d+'), 'original'),
      fit: widget.fit ?? BoxFit.contain,
      cacheKey: _cacheKey,

      // Optimized caching parameters
      maxWidthDiskCache: 1920,
      maxHeightDiskCache: 1920,
      memCacheWidth: 1080,
      memCacheHeight: 1080,

      // Custom HTTP client to handle certificate issues
      httpHeaders: const {
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      },

      // Performance: Use RepaintBoundary for better performance
      imageBuilder: (context, imageProvider) {
        // Mark as successfully loaded
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _isInitialLoad) {
            setState(() {
              _isInitialLoad = false;
              _hasError = false;
            });
          }
        });

        return RepaintBoundary(
          child: Image(
            image: imageProvider,
            fit: widget.fit ?? BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        );
      },

      errorWidget: (context, url, error) {
        // Only show error after initial load attempt
        if (_isInitialLoad) {
          return _buildInitialLoadingIndicator();
        }
        return _buildErrorWidget(error);
      },

      // Use only progressIndicatorBuilder (not placeholder)
      progressIndicatorBuilder: (context, url, progress) {
        return _buildProgressIndicator(progress);
      },
    );
  }

  Widget _buildInitialLoadingIndicator() {
    return Container(
      color: CupertinoColors.black,
      child: Center(
        child: SizedBox(
          width: 60,
          height: 60,
          child: Shimmer.fromColors(
            baseColor: CupertinoColors.systemGrey6,
            highlightColor: CupertinoColors.systemGrey4,
            child: Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(DownloadProgress progress) {
    return Container(
      color: CupertinoColors.black,
      child: Center(
        child: progress.totalSize == null
            ? SizedBox(
                width: 60,
                height: 60,
                child: Shimmer.fromColors(
                  baseColor: CupertinoColors.systemGrey6,
                  highlightColor: CupertinoColors.systemGrey4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CupertinoActivityIndicator(
                    color: CupertinoColors.white,
                    radius: 20,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    child: CupertinoProgressBar(
                      value: progress.downloaded / progress.totalSize!,
                      backgroundColor: CupertinoColors.systemGrey,
                      valueColor: CupertinoColors.activeBlue,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildErrorWidget(Object error) {
    // Only set error state if not already in error state to prevent flashing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasError) {
        setState(() {
          _hasError = true;
          _isInitialLoad = false;
        });
      }
    });

    return Container(
      color: CupertinoColors.black,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.exclamationmark_triangle,
                color: CupertinoColors.systemRed,
                size: 48,
              ),
              const SizedBox(height: 12),
              const Text(
                'Failed to load image',
                style: TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Please check your connection and try again',
                  style: TextStyle(
                    color: CupertinoColors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                    _isInitialLoad = true;
                  });
                  // Force reload the image
                  CachedNetworkImage.evictFromCache(widget.imageUrl);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension for better progress bar styling
class CupertinoProgressBar extends StatelessWidget {
  final double? value;
  final Color backgroundColor;
  final Color valueColor;
  final double height;

  const CupertinoProgressBar({
    super.key,
    this.value,
    required this.backgroundColor,
    required this.valueColor,
    this.height = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(valueColor),
        ),
      ),
    );
  }
}

// Custom HTTP overrides to handle certificate issues
class _CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
  }
}
