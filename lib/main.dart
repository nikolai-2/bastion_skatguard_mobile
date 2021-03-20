import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:skatguard/common/custom_scroll_behavior.dart';
import 'package:skatguard/dao/auth.dart';
import 'package:skatguard/dao/auth.model.dart';
import 'package:skatguard/pages/boss/view.dart';
import 'package:skatguard/pages/guard/view.dart';
import 'package:skatguard/service/http/error_client.dart';
import 'package:skatguard/service/http/http_client.dart';
import 'package:skatguard/service/http/token_client.dart';
import 'package:skatguard/service/uri_resolver.dart';
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
  ];

  WidgetsFlutterBinding.ensureInitialized();
  final restored = await userManager.restoreToken();

  if (restored) {
    try {
      final currentUser = await authDao.getUser();
      userManager.setCurrentUser(currentUser);
    } catch (_) {
      userManager.logOut();
    }
  }
  final app = MultiProvider(
    child: App(),
    providers: providers,
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
