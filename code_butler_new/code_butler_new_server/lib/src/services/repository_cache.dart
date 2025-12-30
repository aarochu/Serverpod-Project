import 'dart:io';
import 'dart:collection';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:code_butler_new_server/src/agents/navigator_agent.dart';

/// Cache entry for file content
class CacheEntry {
  final String hash;
  final DateTime cachedAt;
  final dynamic data;

  CacheEntry({
    required this.hash,
    required this.cachedAt,
    required this.data,
  });
}

/// Repository cache service for file content and dependency graphs
class RepositoryCache {
  final Session session;
  final int maxCacheSize;
  final int ttlSeconds;
  final LinkedHashMap<String, CacheEntry> _fileCache = LinkedHashMap();
  final Map<String, Map<String, List<String>>> _dependencyGraphCache = {};

  RepositoryCache(
    this.session, {
    this.maxCacheSize = 1000,
    this.ttlSeconds = 3600,
  });

  /// Calculates hash of file content
  String getFileHash(String filePath) {
    try {
      final file = File(filePath);
      if (!file.existsSync()) return '';
      
      final content = file.readAsBytesSync();
      final hash = sha256.convert(content);
      return hash.toString();
    } catch (e) {
      session.log('Error calculating file hash: $e', level: LogLevel.error);
      return '';
    }
  }

  /// Checks if file has changed since last cache
  bool isFileChanged(String filePath, String? cachedHash) {
    if (cachedHash == null) return true;
    final currentHash = getFileHash(filePath);
    return currentHash != cachedHash;
  }

  /// Caches dependency graph for a repository
  void cacheDependencyGraph(String repoUrl, Map<String, List<String>> graph) {
    _dependencyGraphCache[repoUrl] = Map.from(graph);
    session.log('Cached dependency graph for $repoUrl');
  }

  /// Retrieves cached dependency graph
  Map<String, List<String>>? getCachedGraph(String repoUrl) {
    final cached = _dependencyGraphCache[repoUrl];
    if (cached != null) {
      session.log('Retrieved cached dependency graph for $repoUrl');
    }
    return cached;
  }

  /// Gets cached file content if available
  String? getCachedFileContent(String filePath, String hash) {
    final key = '$filePath:$hash';
    final entry = _fileCache[key];
    
    if (entry == null) return null;
    
    // Check if expired
    final age = DateTime.now().difference(entry.cachedAt).inSeconds;
    if (age > ttlSeconds) {
      _fileCache.remove(key);
      return null;
    }
    
    // Move to end (LRU)
    _fileCache.remove(key);
    _fileCache[key] = entry;
    
    return entry.data as String?;
  }

  /// Caches file content
  void cacheFileContent(String filePath, String hash, String content) {
    final key = '$filePath:$hash';
    
    // Remove if exists
    _fileCache.remove(key);
    
    // Add to end
    _fileCache[key] = CacheEntry(
      hash: hash,
      cachedAt: DateTime.now(),
      data: content,
    );
    
    // Evict if over limit (LRU)
    while (_fileCache.length > maxCacheSize) {
      _fileCache.remove(_fileCache.keys.first);
    }
    
    session.log('Cached file content: $filePath');
  }

  /// Invalidates cache for a repository
  void invalidateRepository(String repoUrl) {
    _dependencyGraphCache.remove(repoUrl);
    _fileCache.removeWhere((key, _) => key.startsWith(repoUrl));
    session.log('Invalidated cache for $repoUrl');
  }

  /// Clears all caches
  void clear() {
    _fileCache.clear();
    _dependencyGraphCache.clear();
    session.log('Cleared all caches');
  }
}

