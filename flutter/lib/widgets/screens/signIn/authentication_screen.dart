import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/user_storage.dart';
import 'package:ship_conquest/services/google/google_signin_api.dart';

import '../../../services/ship_services/ship_services.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool _isSignInVisible = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ShipServices services = Provider.of<ShipServices>(context, listen: false);
    UserStorage userStorage = Provider.of<UserStorage>(context, listen: false);

    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).colorScheme.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Stack(
                children: [
                  Container(
                      padding: const EdgeInsets.fromLTRB(39, 104, 39, 154),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Text('Authenticate with ',
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Container(
                              margin: const EdgeInsets.fromLTRB(4.5, 0, 0, 0),
                              width: 162,
                              height: 55,
                              child: Image.asset(
                                  'assets/images/google-full-logo.png',
                                  fit: BoxFit.fill)),
                        ],
                      )),
                  Align(
                    alignment: const Alignment(0, 0.5),
                    child: SizedBox(
                        width: double.infinity,
                        child: Image.asset('assets/images/menu_mountains.png',
                            fit: BoxFit.fill)),
                  ),
                  Column(children: [
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: _isSignInVisible
                            ? Align(
                                alignment: const Alignment(0.0, 0.7),
                                child: Wrap(
                                  direction: Axis.vertical,
                                  key: UniqueKey(),
                                  children: [
                                    DefaultButton(
                                      onClick: () => setState(() {
                                        _isSignInVisible = !_isSignInVisible;
                                      }),
                                      message: 'Sign Up',
                                    ),
                                    const SizedBox(height: 15),
                                    DefaultButton(
                                      onClick: () =>
                                          logIn(services, userStorage)
                                              .then((_) => context.go("/home")),
                                      message: 'Log In',
                                    ),
                                  ],
                                ))
                            : Align(
                                alignment: const Alignment(0.0, 0.7),
                                child: Wrap(
                                  direction: Axis.vertical,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  key: UniqueKey(),
                                  children: [
                                    SizedBox(
                                      width: 303,
                                      height: 70,
                                      child: TextField(
                                        controller: _usernameController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          hintText: 'Type in your username!',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontSize: 15,
                                                  color: Colors.black),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(35),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background),
                                        maxLines: 1,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        textAlign: TextAlign.start,
                                        cursorColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        cursorWidth: 2.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 303,
                                      height: 70,
                                      child: TextField(
                                        controller: _descriptionController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          hintText: 'Type in your description!',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                              fontSize: 15,
                                              color: Colors.black),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(35),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 2,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(35),
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background),
                                        maxLines: 1,
                                        textAlignVertical:
                                        TextAlignVertical.center,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.done,
                                        textAlign: TextAlign.start,
                                        cursorColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        cursorWidth: 2.0,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        final username =
                                            _usernameController.text;
                                        final description =
                                            _descriptionController.text;
                                        if (username.length >= 6 ) {
                                          // TODO limite por definir
                                          signIn(services, userStorage,
                                                  username, description.isEmpty ? null: description)
                                              .then((_) => context.go("/home"));
                                        } else {
                                          // TODO dizer que o nome tem que ser maior
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        minimumSize: const Size(118, 37),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: const Text(
                                        'Confirm',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    ClickableText(
                                      text: "Don't have an account?\nGo back.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                      onTap: () {
                                        setState(() {
                                          _isSignInVisible = !_isSignInVisible;
                                        });
                                      },
                                    ),
                                  ],
                                )),
                      ),
                    )
                  ])
                ],
              ))
            ],
          )),
    );
  }

  Future signIn(
      ShipServices services, UserStorage userStorage, String username, String? description) async {
    final account = await GoogleSignInApi.login();
    final userInfo = await GoogleSignInApi.getUserInfo(account!);
    final userToken = await services.signIn(userInfo, username, description);
    userStorage.setToken(userToken.token);
  }

  Future logIn(ShipServices services, UserStorage userStorage) async {
    final account = await GoogleSignInApi.login();
    final userInfo = await GoogleSignInApi.getUserInfo(account!);
    final userToken = await services.logIn(userInfo);
    userStorage.setToken(userToken.token);
  }
}

class DefaultButton extends StatelessWidget {
  final void Function() onClick;
  final String message;

  const DefaultButton(
      {super.key, required this.onClick, required this.message});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            minimumSize: MaterialStateProperty.all(const Size(231, 68)),
          ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class ClickableText extends StatelessWidget {
  final String text;
  final void Function() onTap;
  final TextStyle? style;

  const ClickableText({
    super.key,
    required this.text,
    required this.onTap,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: style,
      ),
    );
  }
}
