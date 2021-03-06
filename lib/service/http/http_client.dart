import 'dart:async';

import 'package:http/http.dart' as http;

class BadStatusCodeException implements Exception {
  const BadStatusCodeException(this.statusCode, this.body);
  final int statusCode;
  final String body;

  @override
  String toString() {
    return '$statusCode: $body';
  }
}

class HttpClient extends http.BaseClient {
  HttpClient._(this.innerClient);
  factory HttpClient(http.Client baseClient,
      List<http.Client Function(http.Client)> innerClients) {
    var curClient = baseClient;
    for (final constructor in innerClients) {
      curClient = constructor(curClient);
    }
    return HttpClient._(curClient);
  }

  http.Client innerClient;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return await innerClient.send(request);
  }
}
