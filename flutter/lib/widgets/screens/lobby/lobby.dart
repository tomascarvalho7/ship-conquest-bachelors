import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/lobby_storage.dart';
import 'package:ship_conquest/widgets/screens/start_menu/start_menu.dart';

import '../../../domain/lobby.dart';
import '../../../services/ship_services/ship_services.dart';

enum DateFilter {
  newer,
  older,
}

enum FilterType {
  all,
  favorites,
  recent,
}

extension DateFilterToString on DateFilter {
  String get valueAsString {
    switch (this) {
      case DateFilter.newer:
        return "Newer";
      case DateFilter.older:
        return "Older";
    }
  }
}

extension DateFilterToOrder on DateFilter {
  String get toRequestOrder {
    switch (this) {
      case DateFilter.newer:
        return "descending";
      case DateFilter.older:
        return "ascending";
    }
  }
}

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({Key? key}) : super(key: key);

  @override
  LobbyScreenState createState() => LobbyScreenState();
}

class LobbyScreenState extends State<LobbyScreen> {
  final TextEditingController _lobbySearchController = TextEditingController();
  final TextEditingController _createLobbyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  DateFilter _dateFilter = DateFilter.newer;
  FilterType _selectedFilterType = FilterType.all;
  List<Lobby>? lobbies;

  final int _limit = 10;
  int _skip = 0;

  @override
  void initState() {
    super.initState();
    _getLobbies();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
        _skip += _limit;
        _getLobbies();
      }
    });
  }

  Future<void> _getLobbies() async {
    final services = Provider.of<ShipServices>(context, listen: false);
    final searchedLobby = _lobbySearchController.text;

    final result =
        await services.getLobbyList(_skip, _limit, _dateFilter.toRequestOrder, searchedLobby);
    setState(() {
      if (lobbies == null) {
        lobbies = result;
      } else {
        lobbies!.addAll(result);
      }
    });
  }

  void handleFilter(FilterType filter) {
    setState(() {
      _selectedFilterType = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final services = Provider.of<ShipServices>(context);
    final LobbyStorage lobbyStorage = Provider.of<LobbyStorage>(context);

    return GestureDetector(
        onPanDown: (dragDetails) {
          _focusNode.unfocus();
        },
        child: Scaffold(
            floatingActionButton: Builder(
              builder: (context) => Align(
                alignment: const Alignment(0.9, 0.7),
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  foregroundColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () async {
                    final name = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15))),
                        titleTextStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                            color: Theme.of(context).colorScheme.secondary),
                        backgroundColor: Theme.of(context).colorScheme.background,
                        title: const Text('Enter lobby name'),
                        content: TextField(
                          autofocus: true,
                          controller: _createLobbyController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.secondary,
                            hintText: 'Choose a cool name!',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(fontSize: 15),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(35),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1,
                              ),
                            ),
                          ),
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.background),
                          maxLines: 1,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          textAlign: TextAlign.start,
                          cursorColor: Theme.of(context).colorScheme.background,
                          cursorWidth: 2.0,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _lobbySearchController.clear();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(
                                context, _createLobbyController.text),
                            child: Text(
                              'Create!',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (name != null && name.isNotEmpty) {
                      final String lobbyId = await services.createLobby(name);
                      lobbyStorage.setLobbyId(lobbyId);
                      if (!mounted) return;
                      context.go("/loading/game");
                    }
                  },
                  child: const Icon(Icons.add),
                ),
              )


            ),
            //floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: Theme.of(context).colorScheme.background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Stack(children: [
                    if (lobbies != null) ...[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: 0.3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const Alignment(0, 0.5),
                        child: SizedBox(
                            child: Image.asset(
                                'assets/images/lobby_mountains.png',
                                fit: BoxFit.fill)),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(39, 60, 39, 9),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Search",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                FilterButton(
                                    content: "All",
                                    isSelected:
                                        _selectedFilterType == FilterType.all,
                                    onClick: () {
                                      handleFilter(FilterType.all);
                                    }),
                                const FractionallySizedBox(widthFactor: 0.02),
                                FilterButton(
                                  content: "Favorites",
                                  isSelected: _selectedFilterType ==
                                      FilterType.favorites,
                                  onClick: () {
                                    handleFilter(FilterType.favorites);
                                  },
                                ),
                                const FractionallySizedBox(widthFactor: 0.02),
                                FilterButton(
                                    content: "Recent",
                                    isSelected: _selectedFilterType ==
                                        FilterType.recent,
                                    onClick: () {
                                      handleFilter(FilterType.recent);
                                    })
                              ],
                            ),
                            Container(
                                padding: const EdgeInsets.only(top: 10),
                                child: FractionallySizedBox(
                                  child: TextField(
                                    focusNode: _focusNode,
                                    controller: _lobbySearchController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      hintText: 'Search',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(fontSize: 15),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(35),
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 2,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(35),
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          width: 1,
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.search,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                        ),
                                        onPressed: () async {
                                          // make search and update the list
                                          final result =
                                          await services.getLobbyList(0, _limit, _dateFilter.toRequestOrder, _lobbySearchController.text);
                                          setState(() {
                                            lobbies = result;
                                          });
                                        },
                                      ),
                                    ),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background),
                                    maxLines: 1,
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    textAlign: TextAlign.start,
                                    cursorColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    cursorWidth: 2.0,
                                  ),
                                )),
                            Container(
                                padding: const EdgeInsets.only(top: 20),
                                child: Divider(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  height: 1,
                                  thickness: 2,
                                )),
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Lobbies",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(fontSize: 24.0),
                                    ),
                                  ),
                                  FilterButton(
                                      content: _dateFilter.valueAsString,
                                      isSelected: false,
                                      onClick: () async {
                                        setState(() {
                                          if (_dateFilter == DateFilter.newer) {
                                              _dateFilter = DateFilter.older;
                                          } else {
                                              _dateFilter = DateFilter.newer;
                                          }
                                        });
                                        final result =
                                            await services.getLobbyList(0, _limit, _dateFilter.toRequestOrder, _lobbySearchController.text);
                                        setState(() {
                                          lobbies = result;
                                        });
                                      }),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: lobbies?.length,
                                itemBuilder: (context, index) {
                                  final lobby = lobbies![index];
                                  return LobbyTile(
                                    lobby: lobby,
                                    onClick: () async {
                                      final String lobbyId =
                                          await services.joinLobby(lobby.tag);
                                      lobbyStorage.setLobbyId(lobbyId);
                                      if (!mounted) return;
                                      context.go("/loading/game");
                                    },
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ] else ...[
                      const WaitForAsyncScreen(
                          mountainsPath: 'assets/images/lobby_mountains.png')
                    ]
                  ])),
                ],
              ),
            )));
  }
}

class FilterButton extends StatelessWidget {
  final String content;
  final bool isSelected;
  final void Function() onClick;

  const FilterButton(
      {super.key,
      required this.content,
      required this.isSelected,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.32,
      child: ElevatedButton(
        onPressed: onClick,
        style: isSelected
            ? Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  )),
                )
            : Theme.of(context).elevatedButtonTheme.style?.copyWith(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  )),
                ),
        child: isSelected
            ? Text(content,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 15.0, color: Colors.white))
            : Text(content,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 15.0)),
      ),
    );
  }
}

class LobbyTile extends StatelessWidget {
  final Lobby lobby;
  final void Function() onClick;

  const LobbyTile({super.key, required this.lobby, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: Theme.of(context).colorScheme.secondary,
      child: ListTile(
        onTap: onClick,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
                text: TextSpan(
                    style: Theme.of(context).textTheme.titleLarge,
                    children: [
                  TextSpan(
                      text: "${lobby.name}\n",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 24)),
                  TextSpan(
                    text: lobby.username,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ])),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: Theme.of(context).textTheme.titleLarge,
                    children: [
                      TextSpan(
                          text: "1\n" /*lobby.players*/,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 40)),
                      TextSpan(
                        text: "player",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ]))
          ],
        ),
      ),
    );
  }
}
