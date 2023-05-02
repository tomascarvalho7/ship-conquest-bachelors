import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/lobby_storage.dart';
import 'package:ship_conquest/services/ship_services/ship_services.dart';
import 'package:ship_conquest/widgets/screens/bottom_navigation_bar/bottom_bar.dart';

import '../../../domain/lobby.dart';

class StartMenuScreen extends StatefulWidget {
  const StartMenuScreen({Key? key}) : super(key: key);

  @override
  _StartMenuScreenState createState() => _StartMenuScreenState();
}

class _StartMenuScreenState extends State<StartMenuScreen> {
  Lobby? lobby;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final lobbyStorage = Provider.of<LobbyStorage>(context, listen: false);
    final services = Provider.of<ShipServices>(context, listen: false);

    final lid = await lobbyStorage.getLobbyId();
    if (lid != null) {
      final lobbyRes = await services.getLobby(lid);
      setState(() {
        lobby = lobbyRes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(60, 180, 135, 1.0),
        onPressed: () {
          //TODO open settings
        },
        child: const Icon(Icons.settings),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Ship Conquest',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: [
                Shadow(
                  offset: const Offset(2, 2),
                  blurRadius: 5,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ],
            ),
          ),
          Align(
            child: Column(
              children: [
                const Text(
                  'Lobby History',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
                Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(60, 180, 135, 1.0),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: lobby?.name != null
                        ? Text(
                      lobby!.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : const Text(
                      'No record',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
