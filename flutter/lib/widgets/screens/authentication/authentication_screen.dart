import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/game/event_handlers/general_event.dart';
import 'package:ship_conquest/providers/user_storage.dart';
import 'package:ship_conquest/widgets/screens/authentication/auth_google.dart';
import 'package:ship_conquest/widgets/screens/authentication/clickable_text.dart';
import 'package:ship_conquest/widgets/screens/authentication/confirm_sign_in_button.dart';
import 'package:ship_conquest/widgets/screens/authentication/default_button.dart';
import 'package:ship_conquest/widgets/screens/menu_utils/mountains_background.dart';
import 'package:ship_conquest/widgets/screens/menu_utils/screen_template.dart';

/// Builds the whole authentication screen, by joining all the smaller parts together
///
/// Stateful because it needs to hold and manage the TextField's states.
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
    UserStorage userStorage = Provider.of<UserStorage>(context, listen: false);

    return buildScreenTemplateWidget(
      context,
      [
        buildAuthWithGoogleWidget(context),
        buildMountainsBackgroundWidget(
            context,
            'assets/images/menu_mountains.png'
        ),
        Column(children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
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
                          buildSignInButtonWidget(
                            context,
                            () => setState(
                                () => _isSignInVisible = !_isSignInVisible),
                            'Sign Up',
                          ),
                          const SizedBox(height: 15),
                          buildSignInButtonWidget(
                            context,
                            () => // login event
                                GeneralEvent.login(context, (token) {
                              userStorage.setToken(token.token);
                              context.go("/home");
                            }),
                            'Log In',
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
                                fillColor:
                                    Theme.of(context).colorScheme.secondary,
                                hintText: 'Type in your username!',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        fontSize: 15, color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(35),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(35),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 1,
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      Theme.of(context).colorScheme.background),
                              maxLines: 1,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              textAlign: TextAlign.start,
                              cursorColor:
                                  Theme.of(context).colorScheme.background,
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
                                fillColor:
                                    Theme.of(context).colorScheme.secondary,
                                hintText: 'Type in your description!',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        fontSize: 15, color: Colors.black),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(35),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(35),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 1,
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      Theme.of(context).colorScheme.background),
                              maxLines: 1,
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              textAlign: TextAlign.start,
                              cursorColor:
                                  Theme.of(context).colorScheme.background,
                              cursorWidth: 2.0,
                            ),
                          ),
                          buildConfirmSignInWidget(
                              context,
                              () {
                                final username = _usernameController.text;
                                final description = _descriptionController.text;
                                // signIn event
                                GeneralEvent.signIn(
                                    context, username, description, (token) {
                                  userStorage.setToken(token.token);
                                  context.go("/home");
                                });
                              },
                              'Confirm'
                          ),
                          buildClickableTextWidget(
                              context,
                              () => setState(
                                  () => _isSignInVisible = !_isSignInVisible),
                              "Don't have an account?\nGo back.")
                        ],
                      )),
            ),
          )
        ])
      ],
    );
  }
}
