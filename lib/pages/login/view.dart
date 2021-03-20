import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skatguard/dao/auth.dart';
import 'package:skatguard/service/user_manager.dart';
import 'package:skatguard/verification.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    final userManager = context.read<UserManager>();
    final authDao = context.read<AuthDao>();
    final info = await authDao.login(
      loginController.text,
      passwordController.text,
    );

    userManager.setCurrentToken(
      TokenInfo(
        token: info.access_token,
        username: loginController.text,
        password: passwordController.text,
      ),
    );
    userManager.setCurrentUser(info.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: FocusScope(
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
                      TextFormField(
                        controller: loginController,
                        validator: verifyEmail,
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
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        onFieldSubmitted: (_) => login(),
                        validator: verifyPassword,
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
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              Color(0xFF00B2FF),
                            ),
                          ),
                          onPressed: login,
                          child: Text('ВОЙТИ'),
                          autofocus: true,
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
        ),
      ),
    );
  }
}
