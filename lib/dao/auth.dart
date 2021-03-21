import 'dart:convert';

import 'package:http/http.dart';
import 'package:skatguard/service/http/token_client.dart';
import 'package:skatguard/service/uri_resolver.dart';
import 'package:skatguard/service/user_manager.dart';

import 'auth.model.dart';
import 'dao.dart';

class AuthDao extends Dao {
  AuthDao(Client client, UriResolver uriResolver) : super(client, uriResolver);

  Future<LoginDto> login(String username, String password) async {
    final res = await client.post(uri('/auth/login', [
      QueryParam('username', username),
      QueryParam('password', password),
    ]));
    return LoginDto.fromJson(res.body);
  }

  Future<User> getUser() async {
    final res = await client.get(uri('/auth/getUser'));
    return User.fromJson(res.body);
  }

  Future<LoginDto> loginByTag(String tagId) async {
    final res = await client.post(
      uri('/auth/loginByTag', [
        QueryParam('tag_id', tagId),
      ]),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'tag_id': tagId,
      }),
    );
    return LoginDto.fromJson(res.body);
  }
}

class SessionTokenRefreshHandler implements TokenRefreshHandler {
  SessionTokenRefreshHandler(this.uriResolver);
  final UriResolver uriResolver;

  @override
  Future<String?> refresh(Client client, TokenInfo? tokenInfo) async {
    if (tokenInfo == null) return null;
    final authDao = AuthDao(client, uriResolver);
    final res = tokenInfo.tagId != null
        ? await authDao.loginByTag(tokenInfo.tagId!)
        : await authDao.login(tokenInfo.username!, tokenInfo.password!);
    return res.access_token;
  }
}
