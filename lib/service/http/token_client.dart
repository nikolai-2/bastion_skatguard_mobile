import 'dart:async';
import 'dart:developer';

import 'package:http/http.dart' as http;
import '../user_manager.dart';

abstract class TokenRefreshHandler {
  Future<String?> refresh(http.Client client, TokenInfo? tokenInfo);
}

class TokenClient extends http.BaseClient {
  TokenClient(
    this._inner,
    this.userManager, {
    required this.tokenRefreshHandler,
  });

  final http.Client _inner;
  final UserManager userManager;

  TokenRefreshHandler tokenRefreshHandler;

  Completer<void>? _refreshCompleter;

  Future<void> _waitRefresh() async {
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      await _refreshCompleter!.future;
    }
  }

  Future<bool> _refreshToken() async {
    _refreshCompleter = Completer();
    try {
      final newTokenRestored = await userManager.restoreToken();
      if (newTokenRestored) return true;
      final tokenInfo = userManager.currentToken.valueWrapper?.value;
      final newAccessToken =
          await tokenRefreshHandler.refresh(_inner, tokenInfo);
      userManager.setCurrentToken(
        tokenInfo?.copyWith(token: newAccessToken),
      );
      return true;
    } catch (e) {
      log('error received on token refreshing: $e');
      userManager
        ..setCurrentToken(null)
        ..setCurrentUser(null);
      return false;
    } finally {
      _refreshCompleter!.complete();
    }
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    await _waitRefresh();
    final tokenInfo = userManager.currentToken.valueWrapper?.value;
    if (tokenInfo != null) {
      request.headers['Authorization'] = 'Bearer ${tokenInfo.token}';
    }
    final response = await _inner.send(request);

    if (response.statusCode == 401 && tokenInfo != null) {
      final refreshed = await _refreshToken();
      if (refreshed && request is http.Request) {
        final req = http.Request(request.method, request.url)
          ..bodyBytes = request.bodyBytes
          ..encoding = request.encoding
          ..followRedirects = request.followRedirects
          ..persistentConnection = request.persistentConnection
          ..headers.addAll(request.headers);
        return await send(req);
      }
    }
    return response;
  }
}
