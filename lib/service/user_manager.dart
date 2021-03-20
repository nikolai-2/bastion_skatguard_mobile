import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:skatguard/dao/auth.model.dart';

class UserState {
  const UserState(this.user, this.isLoading);
  final User? user;
  final bool isLoading;
}

class TokenInfo {
  final String token;
  final String username;
  final String password;
  TokenInfo({
    required this.token,
    required this.username,
    required this.password,
  });

  TokenInfo copyWith({
    String? token,
    String? username,
    String? password,
  }) {
    return TokenInfo(
      token: token ?? this.token,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}

class UserManager {
  final BehaviorSubject<UserState> _userSubject =
      BehaviorSubject.seeded(const UserState(null, false));
  ValueStream<UserState> get currentUser => _userSubject.stream;

  final BehaviorSubject<TokenInfo?> _tokenSubject =
      BehaviorSubject.seeded(null);
  ValueStream<TokenInfo?> get currentToken => _tokenSubject.stream;

  void setCurrentUser(User? user) {
    _userSubject.add(UserState(user, false));
  }

  void setCurrentToken(TokenInfo? tokenInfo) {
    _tokenSubject.add(tokenInfo);
    saveToken(tokenInfo);
  }

  Future<bool> restoreToken() async {
    final instance = await SharedPreferences.getInstance();
    final token = instance.getString('token');
    final username = instance.getString('username');
    final password = instance.getString('password');
    if (token != null && username != null && password != null) {
      final tokenInfo =
          TokenInfo(token: token, username: username, password: password);
      if (tokenInfo != currentToken.value) {
        setCurrentToken(tokenInfo);
        return true;
      }
    } else {
      setCurrentToken(null);
    }
    return false;
  }

  Future<void> saveToken(TokenInfo? info) async {
    final instance = await SharedPreferences.getInstance();

    if (info?.token == null)
      await instance.remove('token');
    else
      await instance.setString('token', info!.token);

    if (info?.username == null)
      await instance.remove('username');
    else
      await instance.setString('username', info!.username);

    if (info?.username == null)
      await instance.remove('password');
    else
      await instance.setString('password', info!.password);
  }

  void logOut() {
    setCurrentUser(null);
    setCurrentToken(null);
  }
}
