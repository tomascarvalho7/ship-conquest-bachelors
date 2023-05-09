import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LeaveGameScreen extends StatefulWidget {
  const LeaveGameScreen({Key? key}) : super(key: key);

  @override
  _LeaveGameScreenState createState() => _LeaveGameScreenState();
}

class _LeaveGameScreenState extends State<LeaveGameScreen> {
  bool _isNavigated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then((_) {
      if (!_isNavigated) {
        context.go("/home");
        _isNavigated = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO meter bonito e que ta so para usar
    return Scaffold(
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            Text("Saving game info...")
          ],
        ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    // Set _isNavigated to true when the widget is disposed to prevent navigation
    // from being triggered if the user navigates back to this screen
    _isNavigated = true;
  }
}
