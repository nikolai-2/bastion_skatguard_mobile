import 'package:flutter/material.dart';

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
      home: LoginPage(),
    );
  }
}
