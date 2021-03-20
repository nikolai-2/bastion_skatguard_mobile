import 'package:convert/convert.dart';
import 'package:nfc_manager/nfc_manager.dart';

String nfcToId(NfcTag tag) {
  final hexString = hex.encode(tag.data['nfca']['identifier']).toUpperCase();
  List<String> substrings = [];
  for (var i = 0; i < hexString.length / 2; i++) {
    final substring = hexString.substring(i * 2, i * 2 + 2);
    substrings.add(substring);
  }
  return substrings.join(':');
}
