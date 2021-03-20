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
}

class SessionTokenRefreshHandler implements TokenRefreshHandler {
  SessionTokenRefreshHandler(this.uriResolver);
  final UriResolver uriResolver;

  @override
  Future<String?> refresh(Client client, TokenInfo? tokenInfo) async {
    if (tokenInfo == null) return null;
    final authDao = AuthDao(client, uriResolver);
    final res = await authDao.login(tokenInfo.username, tokenInfo.password);
    return res.access_token;
  }
}
