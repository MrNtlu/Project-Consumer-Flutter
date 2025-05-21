import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCacheManager {
  static const key = 'customCacheKey'; // Or any unique key

  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 500,
      // You might also want to configure repo: FileSystemCacheRepo() or similar if needed
      // For now, default file system repo should be fine.
    ),
  );
}
