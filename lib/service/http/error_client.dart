import 'dart:async';

import 'package:http/http.dart' as http;

import 'http_client.dart';

abstract class ErrorHandler {
  Future<void> showErrorMessage(http.Client client, Exception exception);
}

class ErrorClient extends http.BaseClient {
  ErrorClient(this._inner);

  final http.Client _inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final response = await _inner.send(request);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final bodyList = await response.stream.toStringStream().toList();
      throw BadStatusCodeException(response.statusCode, bodyList.join());
    }
    return response;
  }
}
