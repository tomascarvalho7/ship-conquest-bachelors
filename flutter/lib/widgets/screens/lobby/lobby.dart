import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/lobby_storage.dart';

import '../../../domain/lobby.dart';
import '../../../services/ship_services/ship_services.dart';
import '../bottom_navigation_bar/bottom_bar.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({Key? key}) : super(key: key);

  @override
  LobbyScreenState createState() => LobbyScreenState();
}

class LobbyScreenState extends State<LobbyScreen> {
  final TextEditingController _controller = TextEditingController();
  late Future<List<Lobby>> _lobbiesFuture;

  @override
  void initState() {
    super.initState();
    final services = Provider.of<ShipServices>(context, listen: false);
    _lobbiesFuture = services.getAllLobbies();
  }

  @override
  Widget build(BuildContext context) {
    final lobbyStorage = Provider.of<LobbyStorage>(context, listen: false);
    final services = Provider.of<ShipServices>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: const BottomBar(),
      floatingActionButton:
      Builder(builder: (context) =>
          FloatingActionButton(
            onPressed: () async {
              final name = await showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Enter lobby name'),
                  content: TextField(
                    autofocus: true,
                    controller: _controller,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, _controller.text),
                      child: const Text('Create!'),
                    ),
                  ],
                ),
              );
              if (name != null && name.isNotEmpty) {
                final String lobbyId = await services.createLobby(name);
                lobbyStorage.setLobbyId(lobbyId);
                if(!mounted) return;
                context.go("/game");
              }
            },
            child: const Icon(Icons.add),
          ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: FutureBuilder<List<Lobby>>(
        future: _lobbiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final lobbies = snapshot.data!;
            return Container(
                color: const Color.fromRGBO(60, 180, 135, 1.0),
                child: Column(
                  children: [
                    SizedBox(
                        height: screenHeight / 4,
                        width: screenWidth * 0.8,
                        child: const Center(
                          child: Text(
                            'Choose an existing lobby or create a new one!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        )),
                    Expanded(
                      child: ListView.builder(
                        itemCount: lobbies.length,
                        itemBuilder: (context, index) {
                          final lobby = lobbies[index];
                          return Card(
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    lobby.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final String lobbyId = await services.joinLobby(lobby.tag);
                                      lobbyStorage.setLobbyId(lobbyId);
                                      if(!mounted) return;
                                      context.go("/game");
                                    },
                                    child: const Text('Join!'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
            );
          }
        },
      ),
    );
  }
}
