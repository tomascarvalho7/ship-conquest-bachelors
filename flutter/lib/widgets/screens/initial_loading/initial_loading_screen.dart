import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/user_storage.dart';
import 'package:ship_conquest/services/google/google_signin_api.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';
import 'package:ship_conquest/widgets/screens/wave_loading_screen/loading_screen.dart';


/// Loading screen that checks if the currently stored token is valid.
///
/// If it is valid, proceed to the home screen,
/// else send the user to the sign in screen.
class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({super.key});

  @override
  _InitialLoadingScreenState createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final userStorage = context.read<UserStorage>();
    final firstTime = await userStorage.getFirstTime();

    if (firstTime && mounted) {
      context.go("/onBoarding");
    } else {
      await _checkToken();
    }
  }

  Future<void> _checkToken() async {
    final userStorage = context.read<UserStorage>();
    final shipServices = context.read<ShipServices>();

    userStorage.getToken().then((token) async {
      if (token == null) {
        context.go("/signIn");
      } else {
        shipServices.checkTokenValidity(token).then((value) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
            if (value.isLeft) {
              GoogleSignInApi.logout();
              context.go("/signIn");
            } else {
              context.go("/home");
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LoadingScreen(),
        if (isLoading)
          Align(
            alignment: const Alignment(0.0, 0.3),
            child: Text(
              "Signing you in!",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
      ],
    );
  }
}
