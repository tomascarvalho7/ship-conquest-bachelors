import 'package:flutter/material.dart';
import 'package:ship_conquest/widgets/authentication/google_signin_api.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff92c4aa),
                  Color(0xff7ac29e),
                  Color(0xff70c299),
                  Color(0xff5ac18e),
                ]
            )
        ),
        alignment: Alignment.center,
        child: const ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Color(0xff92c4aa))
          ),
          onPressed: signIn,
          child: Text('Login with google'),
        )
    );
  }
}

Future signIn() async {
  final account = await GoogleSignInApi.login();
  print(account?.email);
  final userInfo = await GoogleSignInApi.getUserInfo(account!);
  print(userInfo);
}