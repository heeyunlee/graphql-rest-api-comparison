class Result {
  Result({
    required this.statusCode,
    required this.body,
    required this.headers,
    this.responseBodySizeInBytes,
  });

  final int statusCode;
  final Object body;
  final Map<String, String> headers;
  final int? responseBodySizeInBytes;
}
