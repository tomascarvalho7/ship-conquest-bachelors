import 'package:flutter/cupertino.dart';

class AwaitBuilder<T> extends StatelessWidget {
  final Future<T>? future;
  final Widget Function(T value) onDone;
  final Widget Function() onLoading;
  const AwaitBuilder({super.key, required this.future, required this.onDone, required this.onLoading});

  @override
  Widget build(BuildContext context) =>
      FutureBuilder(
          future: future,
          builder: (_, snapshot) {
            final data = snapshot.data;
            if (snapshot.hasData && data != null) {
              return onDone(data);
            } else {
              return onLoading();
            }
          }
      );
}