import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/lobby/complete_lobby.dart';
import 'package:ship_conquest/domain/utils/string_cap.dart';
import 'package:ship_conquest/providers/game/event_handlers/general_event.dart';

class LobbyTile extends StatefulWidget {
  final CompleteLobby lobby;
  final void Function() onClick;

  const LobbyTile({super.key,  required this.lobby, required this.onClick});

  @override
  _LobbyTileState createState() => _LobbyTileState();
}

class _LobbyTileState extends State<LobbyTile> {
  late bool isFavorite;

  @override
  void initState() {
    isFavorite = widget.lobby.isFavorite;
    super.initState();
  }

  @override
  void didUpdateWidget(LobbyTile oldWidget) {
    if (widget.lobby != oldWidget.lobby) {
      // Widget data has changed, perform initialization logic here
      // This code will be executed every time the widget is rebuilt with new data
      isFavorite = widget.lobby.isFavorite; // Reset the favorite state
      // Perform any other initialization tasks here
    }
    super.didUpdateWidget(oldWidget);
  }

  void toggleFavorite() {
    setState(() => isFavorite = !isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: Theme.of(context).colorScheme.secondary,
      child: ListTile(
        onTap: widget.onClick,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              iconSize: 40,
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.yellow : Colors.grey,
              ),
              onPressed: () {
                if (isFavorite) {
                  GeneralEvent.removeFavoriteLobby(context, widget.lobby.tag);
                } else {
                  GeneralEvent.setFavoriteLobby(context, widget.lobby.tag);
                }
                toggleFavorite(); // Update the state
              },
            ),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.titleLarge,
                children: [
                  TextSpan(
                    text: "${widget.lobby.name.cap(12)}\n",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 24),
                  ),
                  TextSpan(
                    text: widget.lobby.username,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context).textTheme.titleLarge,
                children: [
                  TextSpan(
                    text: "${widget.lobby.players}\n",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 40),
                  ),
                  TextSpan(
                    text: widget.lobby.players > 1 ? "players" : "player",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
