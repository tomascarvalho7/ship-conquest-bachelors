import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/user_storage.dart';
import 'package:ship_conquest/services/google/google_signin_api.dart';
import 'package:ship_conquest/widgets/screens/game/game_screen.dart';

import '../../../services/ship_services/ship_services.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ShipServices services = Provider.of<ShipServices>(context, listen: false);
    UserStorage userStorage = Provider.of<UserStorage>(context, listen: false);

    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(198, 223, 255, 1.0),
                  Color.fromRGBO(87, 160, 255, 1.0)
                ]
            )
        ),
        alignment: Alignment.center,
        child: GoogleAuthButton(
              onClick: () => signIn(services, userStorage).then((_) => context.go("/game"))
            )
    );
  }
  Future signIn(ShipServices services, UserStorage userStorage) async {
    final account = await GoogleSignInApi.login();
    final userInfo = await GoogleSignInApi.getUserInfo(account!);
    final userToken = await services.signIn(userInfo);
    userStorage.setToken(userToken.token);
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


