import 'dart:convert';

import 'package:http/http.dart';
import 'package:skatguard/service/uri_resolver.dart';

import 'dao.dart';

class ScheduleDao extends Dao {
  ScheduleDao(Client client, UriResolver uriResolver)
      : super(client, uriResolver);

  Future<int> create(
      int guardId, int placeId, DateTime date, List<int> repeatWhen) async {
    final data = await client.post(
      uri('/schedule/create'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'guard_id': guardId,
        'place_id': placeId,
        'date': date.toUtc().toIso8601String(),
        'repeat_when': repeatWhen,
      }),
    );
    return jsonDecode(data.body)['id'];
  }

  Future<void> update(int id, int guardId, int placeId, DateTime date,
      List<int> repeatWhen) async {
    await client.post(
      uri('/schedule/update'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'guard_id': guardId,
        'place_id': placeId,
        'date': date.toUtc().toIso8601String(),
        'repeat_when': repeatWhen,
      }),
    );
  }

  Future<void> delete(int id) async {
    await client.get(uri('/schedule/$id/delete'));
  }
}
