import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';
import 'package:skatguard/dao/auth.dart';
import 'package:skatguard/service/nfc.dart';
import 'package:skatguard/service/nfc_service.dart';
import 'package:skatguard/service/notification_manager.dart';
import 'package:skatguard/service/user_manager.dart';
import 'package:skatguard/styles.dart';
import 'package:skatguard/verification.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = context.read<NfcService>().onTag.listen(loginByNfc);
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

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
        tagId: null,
      ),
    );

    userManager.setCurrentUser(info.user);
    subscribeNotification(info.user.id);
  }

  Future<void> loginByNfc(NfcTag nfcTag) async {
    final userManager = context.read<UserManager>();
    final authDao = context.read<AuthDao>();
    final info = await authDao.loginByTag(nfcToId(nfcTag));

    userManager.setCurrentToken(
      TokenInfo(
        token: info.access_token,
        tagId: nfcToId(nfcTag),
        username: null,
        password: null,
      ),
    );
    userManager.setCurrentUser(info.user);
    subscribeNotification(info.user.id);
  }

  Future<void> subscribeNotification(int userId) async {
    await context.read<NotificationManager>().subscribeByUser(userId);
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
                Spacer(flex: 5),
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
                          '?????????? ????????????????????,',
                          style: TextStyle(
                            color: Color(0xFF00B2FF),
                            fontWeight: FontWeight.w300,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          '??????????????, ?????????? ????????????????????',
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
                Spacer(flex: 6),
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
                          labelText: '????????????',
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
                      Text(
                        '?????? ?????????????????? ????????',
                        style: greyStyle,
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
                          child: Text('??????????'),
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
