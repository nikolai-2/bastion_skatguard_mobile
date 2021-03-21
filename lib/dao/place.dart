import 'dart:convert';

import 'package:http/http.dart';
import 'package:skatguard/pages/boss/place_sheet.dart';
import 'package:skatguard/service/uri_resolver.dart';

import 'dao.dart';
import 'place.model.dart';

class PlaceDao extends Dao {
  PlaceDao(Client client, UriResolver uriResolver) : super(client, uriResolver);

  Future<List<ExtendedPlaceInfo>> getList() async {
    final res = await client.get(uri('/place/getList'));
    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((e) =>
            ExtendedPlaceInfo.fromMap((e as Map<dynamic, dynamic>).cast()))
        .toList();
  }

  Future<int> create(String placeName, List<ZoneDto> zones) async {
    final data = await client.post(
      uri('/place/create'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'place_name': placeName,
        'zones': zones
            .map((e) => {
                  'id': e.id,
                  'name': e.name,
                })
            .toList(),
      }),
    );
    return jsonDecode(data.body)['id'];
  }

  Future<void> update(int id, String placeName, List<ZoneDto> zones) async {
    await client.post(
      uri('/place/update'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'place_name': placeName,
        'zones': zones
            .map((e) => {
                  'id': e.id,
                  'name': e.name,
                })
            .toList(),
      }),
    );
  }
}
