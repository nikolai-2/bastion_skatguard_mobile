import 'dart:convert';

import 'package:http/http.dart';
import 'package:skatguard/dao/auth.model.dart';
import 'package:skatguard/service/uri_resolver.dart';

import 'dao.dart';

class UserDao extends Dao {
  UserDao(Client client, UriResolver uriResolver) : super(client, uriResolver);

  Future<List<User>> getByRole([String role = 'guard']) async {
    final res = await client.get(uri('/user/getByRole/$role'));
    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((e) => User.fromMap((e as Map<dynamic, dynamic>).cast()))
        .toList();
  }
}
