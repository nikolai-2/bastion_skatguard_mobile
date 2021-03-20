import 'package:http/http.dart';
import 'package:skatguard/service/uri_resolver.dart';

abstract class Dao {
  Dao(this.client, this.uriResolver);
  final Client client;
  final UriResolver uriResolver;

  Uri uri(String path, [List<QueryParam> queryParams = const []]) {
    return uriResolver.uri(path, queryParams);
  }
}
