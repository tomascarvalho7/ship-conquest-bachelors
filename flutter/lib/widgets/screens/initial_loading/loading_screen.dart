import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_storage.dart';

class InitialLoadingScreen extends StatelessWidget {
  const InitialLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserStorage>(
        builder: (context, userStorage, _) {
          userStorage.getToken().then(
                  (value) => value == null ? context.go("/signIn") : context.go("/start")
          );

          return const CircularProgressIndicator();
        }
    );
  }
}