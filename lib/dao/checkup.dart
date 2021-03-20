import 'dart:convert';

import 'package:http/http.dart';
import 'package:skatguard/service/uri_resolver.dart';

import 'checkup.model.dart';
import 'dao.dart';

class CheckupDao extends Dao {
  CheckupDao(Client client, UriResolver uriResolver)
      : super(client, uriResolver);

  Future<List<CheckupInfo>> getList(DateTime date) async {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final dateStr = '${date.year}-$month-$day';
    final res = await client.get(uri('/checkup/$dateStr/getList'));
    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((e) => CheckupInfo.fromMap((e as Map<dynamic, dynamic>).cast()))
        .toList();
  }

  Future<void> checked(
      int scheduleShiftId, String zoneId, String? comment) async {
    await client.post(
      uri('/checkup/checked', [
        QueryParam('schedule_shift_id', scheduleShiftId.toString()),
        QueryParam('zone_id', zoneId),
      ]),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'schedule_shift_id': scheduleShiftId,
        'zone_id': zoneId,
        'comment': comment,
      }),
    );
  }
}
