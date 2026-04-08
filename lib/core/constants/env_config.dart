class EnvConfig {
  static const String baseUrl = 'http://192.168.1.37:3000';

  /// Replaces a localhost origin in [url] with [baseUrl].
  /// Returns null for null or empty input.
  /// Remove this once file storage moves to S3.
  static String? normalizeUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    return url.replaceFirst(RegExp(r'^https?://localhost(:\d+)?'), baseUrl);
  }
}
