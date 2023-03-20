import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/widgets/authentication/google_signin_api.dart';
import 'package:ship_conquest/widgets/screens/game_screen.dart';

import '../../domain/token.dart';
import '../../services/ship_services.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ShipServices services = Provider.of<ShipServices>(context, listen: false);

    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white70,
                  Colors.black,
                ]
            )
        ),
        alignment: Alignment.center,
        child: GoogleAuthButton(
              onClick: () async {
                signIn(services).then((value) {
                  /*Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => GameScreen())
                  );*/
                  //Providers dont get transported through new routes, so it doesnt work
                });
              }
            )
    );
  }
}

class GoogleAuthButton extends StatelessWidget {
  final void Function() onClick;

  const GoogleAuthButton({super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Colors.black)),
      onPressed: onClick,
      child: SizedBox(
          height: 100.0,
          width: 300.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Center(
                child: Text(
                  "Sign-In with Google!",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Image.asset(
                  "assets/images/google_logo.png",
                  height: 40,
                ),
              )
            ],
          )),
    );
  }
}

Future<Token> signIn(ShipServices services) async {
  final account = await GoogleSignInApi.login();
  final userInfo = await GoogleSignInApi.getUserInfo(account!);
  return await services.signIn(userInfo);
}
