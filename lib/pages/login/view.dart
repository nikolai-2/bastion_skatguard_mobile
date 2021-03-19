import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skatguard/pages/boss/view.dart';
import 'package:skatguard/route.dart';

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
      body: SafeArea(
        child: Column(
          children: [
            Spacer(flex: 4),
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 30,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SvgPicture.asset(
                        'assets/shield.svg',
                        height: 30,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Добро пожаловать,',
                      style: TextStyle(
                        color: Color(0xFF00B2FF),
                        fontWeight: FontWeight.w300,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      'войдите, чтобы продолжить',
                      style: TextStyle(
                        color: Color(0xFFBEBEBE),
                        fontWeight: FontWeight.w300,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(flex: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  TextField(
                    controller: loginController,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      labelStyle: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      labelStyle: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(flex: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xFF00B2FF),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(route((_) => BossPage()));
                      },
                      child: Text('ВОЙТИ'),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
