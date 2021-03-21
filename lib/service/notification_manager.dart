import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationManager {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> subscribeByUser(int userId) async {
    await messaging.subscribeToTopic('user-$userId');
  }

  Future<void> unsubscribe(int userId) async {
    messaging.unsubscribeFromTopic('user-$userId');
  }
}
