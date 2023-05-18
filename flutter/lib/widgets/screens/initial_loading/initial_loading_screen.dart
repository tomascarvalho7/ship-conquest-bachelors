import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/widgets/screens/initial_loading/loading_screen.dart';

import '../../../providers/user_storage.dart';

class InitialLoadingScreen extends StatelessWidget {
  const InitialLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserStorage>(builder: (context, userStorage, _) {
      userStorage.getToken().then((value) =>
          value == null ? context.go("/signIn") : context.go("/home"));

      return Stack(children: [
        LoadingScreen(),
        Align(
          alignment: const Alignment(0.0, 0.3),
          child: Text("Signing you in!",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.secondary),),
        )
      ]);;
    });
  }
}
