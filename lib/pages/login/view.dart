import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: loginController,
            decoration: InputDecoration(labelText: 'Login'),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          TextButton(onPressed: () {}, child: Text('Дальше')),
        ],
      ),
    );
  }
}
