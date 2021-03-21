import 'dart:async';

import 'package:nfc_manager/nfc_manager.dart';

class NfcService {
  void start() {
    NfcManager.instance.startSession(
      onDiscovered: _onDiscovered,
    );
  }

  Future<void> _onDiscovered(NfcTag tag) async {
    _onTag.add(tag);
  }

  StreamController<NfcTag> _onTag = StreamController.broadcast();
  Stream<NfcTag> get onTag => _onTag.stream;
}
