import 'package:flutter/material.dart';
import 'package:skatguard/common/custom_scroll_behavior.dart';

import 'pages/login/view.dart';

void main() => runApp(App());

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
      home: LoginPage(),
    );
  }
}
