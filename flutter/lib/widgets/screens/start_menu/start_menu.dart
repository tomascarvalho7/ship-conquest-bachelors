import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/patch_notes/patch_notes.dart';
import '../../../providers/game/event_handlers/general_event.dart';

class StartMenuScreen extends StatefulWidget {
  const StartMenuScreen({Key? key}) : super(key: key);

  @override
  _StartMenuScreenState createState() => _StartMenuScreenState();
}

class _StartMenuScreenState extends State<StartMenuScreen> {
  String? userName;
  PatchNotes patchNotes = PatchNotes(notes: []);

  @override
  void initState() {
    super.initState();
    _getUserName();
    _getPatchNotes();
  }

  Future<void> _getUserName() async {
    GeneralEvent.getPersonalInfo(context, (userInfo) =>
        setState(() => userName = userInfo.name.split(' ').first)
    );
  }

  Future<void> _getPatchNotes() async {
    GeneralEvent.getPatchNotes(context, (notes) =>
        setState(() => patchNotes = notes)
    );
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
            if (userName != null && patchNotes.notes.isNotEmpty) ...[
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
                              colors: [Color.fromRGBO(230, 96, 87, 1), Color.fromRGBO(231, 114, 113, 0.2)],
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: RichText(
                              text: TextSpan(
                                text: patchNotes.notes.first, // TODO change to a list of texts
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
