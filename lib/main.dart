import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:skatguard/common/custom_scroll_behavior.dart';
import 'package:skatguard/dao/auth.dart';
import 'package:skatguard/dao/checkup.dart';
import 'package:skatguard/dao/place.dart';
import 'package:skatguard/dao/schedule.dart';
import 'package:skatguard/dao/user.dart';
import 'package:skatguard/pages/boss/view.dart';
import 'package:skatguard/pages/guard/view.dart';
import 'package:skatguard/service/http/error_client.dart';
import 'package:skatguard/service/http/http_client.dart';
import 'package:skatguard/service/http/token_client.dart';
import 'package:skatguard/service/notification_manager.dart';
import 'package:skatguard/service/uri_resolver.dart';
import 'package:skatguard/service/nfc_service.dart';
import 'package:skatguard/service/user_manager.dart';

import 'pages/login/view.dart';

Future<void> main() async {
  final userManager = UserManager();
  final uriResolver = UriResolver();
  final sessionTokenRefreshHandler = SessionTokenRefreshHandler(uriResolver);
  final httpClient = HttpClient(Client(), [
    (client) => TokenClient(
          client,
          userManager,
          tokenRefreshHandler: sessionTokenRefreshHandler,
        ),
    (client) => ErrorClient(client),
  ]);

  final authDao = AuthDao(httpClient, uriResolver);

  final providers = [
    Provider.value(value: userManager),
    Provider.value(value: uriResolver),
    Provider.value(value: sessionTokenRefreshHandler),
    Provider.value(value: httpClient),
    Provider.value(value: authDao),
    Provider(
      create: (c) => CheckupDao(c.read<HttpClient>(), c.read<UriResolver>()),
    ),
    Provider(
      create: (c) => PlaceDao(c.read<HttpClient>(), c.read<UriResolver>()),
    ),
    Provider(
      create: (c) => UserDao(c.read<HttpClient>(), c.read<UriResolver>()),
    ),
    Provider(
      create: (c) => ScheduleDao(c.read<HttpClient>(), c.read<UriResolver>()),
    ),
  ];

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final restored = await userManager.restoreToken();
  final nfcService = NfcService()..start();
  final notificationManager = NotificationManager();

  if (restored) {
    try {
      final currentUser = await authDao.getUser();
      userManager.setCurrentUser(currentUser);
    } catch (_) {
      final id = userManager.currentUser.valueWrapper?.value.user?.id;
      if (id != null) {
        await notificationManager.unsubscribe(id);
      }
      userManager.logOut();
    }
  }
  final app = MultiProvider(
    child: App(),
    providers: [
      ...providers,
      Provider.value(value: nfcService),
      Provider.value(value: notificationManager),
    ],
  );

  runApp(app);
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkatGuard',
      theme: ThemeData(
        primaryColor: Color(0xFF00B2FF),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: child!,
        );
      },
      home: StreamBuilder<UserState>(
        builder: (_, snap) {
          if (!snap.hasData || snap.data!.isLoading) return LoginPage();
          if (snap.data?.user == null) return LoginPage();
          final user = snap.data!.user!;
          if (user.role == 'guard') return GuardPage();
          if (user.role == 'boss') return BossPage();
          return Text('idk');
        },
        stream: context.watch<UserManager>().currentUser,
      ),
    );
  }
}
