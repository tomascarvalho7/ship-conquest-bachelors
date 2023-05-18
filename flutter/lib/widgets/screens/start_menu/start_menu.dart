import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';
import 'package:ship_conquest/widgets/screens/initial_loading/loading_screen.dart';

class StartMenuScreen extends StatefulWidget {
  const StartMenuScreen({Key? key}) : super(key: key);

  @override
  _StartMenuScreenState createState() => _StartMenuScreenState();
}

class _StartMenuScreenState extends State<StartMenuScreen> {
  String? userName;
  String? patchNotes;

  @override
  void initState() {
    super.initState();
    _getUserName();
    _getPatchNotes();
  }

  Future<void> _getUserName() async {
    final services = Provider.of<ShipServices>(context, listen: false);

    final userInfo = await services.getPersonalInfo();
    setState(() {
      userName = userInfo.name.split(' ').first;
    });
  }

  Future<void> _getPatchNotes() async {
    final services = Provider.of<ShipServices>(context, listen: false);

    const notes = "Combat update!";
    //await services.getPatchNotes();
    setState(() {
      patchNotes = notes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      color: Theme.of(context).colorScheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Stack(children: [
            if (userName != null && patchNotes != null) ...[
              Container(
                  padding: const EdgeInsets.fromLTRB(39, 60, 75, 9),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(bottom: 50),
                          width: double.infinity,
                          child: RichText(
                              text: TextSpan(
                                  style: Theme.of(context).textTheme.titleLarge,
                                  children: [
                                const TextSpan(text: "Welcome back\n"),
                                TextSpan(
                                  text: userName,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )
                              ]))),
                      SizedBox(
                        width: double.infinity,
                        child: Text('Patch Notes',
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                    ],
                  )),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: 0.3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double height = constraints.maxHeight * 0.25;
                  final double width = constraints.maxWidth * 0.9;

                  return Align(
                    alignment: const Alignment(0, -0.15),
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              begin: Alignment(-0, 1),
                              end: Alignment(-0, -1),
                              colors: [Color(0xffe65f57), Color(0x33e77271)],
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: RichText(
                              text: TextSpan(
                                text: patchNotes,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                          )),
                    ),
                  );
                },
              ),
              Align(
                alignment: const Alignment(0, 0.5),
                child: SizedBox(
                    child: Image.asset('assets/images/menu_mountains.png',
                        fit: BoxFit.fill)),
              ),
            ] else ...[
              const WaitForAsyncScreen(mountainsPath: 'assets/images/menu_mountains.png',)
            ]
          ])),
        ],
      ),
    ));
  }
}

class WaitForAsyncScreen extends StatelessWidget {
  final String mountainsPath;
  const WaitForAsyncScreen({super.key, required this.mountainsPath});

  @override
  Widget build(BuildContext context) {
    return Stack(
          children: [
            const Center(child: CircularProgressIndicator()),
            Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: 0.3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )),
            Align(
              alignment: const Alignment(0, 0.5),
              child: SizedBox(
                  child: Image.asset(mountainsPath,
                      fit: BoxFit.fill)),
            ),
          ],
        );
  }
}
