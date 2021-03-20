import 'package:skatguard/constants.dart';

class QueryParam {
  QueryParam(this.key, this.value);
  final String key;
  final String value;
}

class UriResolver {
  Uri uri(String path, [List<QueryParam> queryParams = const []]) {
    var query = '?';
    for (final p in queryParams) {
      query += '${Uri.encodeComponent(p.key)}=${Uri.encodeComponent(p.value)}&';
    }
    if (scheme == 'https') {
      return Uri.parse(Uri.https(baseUrl, path).toString() + query);
    } else {
      return Uri.parse(Uri.http(baseUrl, path).toString() + query);
    }
  }
}
