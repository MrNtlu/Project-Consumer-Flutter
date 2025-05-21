import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/io_client.dart';

/// Debug-only override to accept any certificate.
class _DebugHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (_, __, ___) => true;
  }
}

/// A singleton cache manager that supports on-disk resizing
/// (via ImageCacheManager) and ignores self-signed cert errors
class CustomCacheManager extends CacheManager
    with ImageCacheManager {
  static const key = 'customImageKey';
  static CustomCacheManager? _instance;

  /// Returns the single instance
  factory CustomCacheManager() =>
      _instance ??= CustomCacheManager._internal();

  CustomCacheManager._internal()
      : super(
          Config(
            key,
            // How long until a file is considered "stale"
            stalePeriod: const Duration(days: 30),
            // Max number of objects to keep in cache
            maxNrOfCacheObjects: 200,
            // Use a custom FileService with an IOClient that ignores bad certs
            fileService: HttpFileService(
              httpClient: IOClient(
                HttpOverrides.runWithHttpOverrides(
                  () => HttpClient(),
                  _DebugHttpOverrides(),
                ),
              ),
            ),
          ),
        );
}
