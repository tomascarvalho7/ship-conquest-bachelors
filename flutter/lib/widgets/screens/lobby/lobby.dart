import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/domain/immutable_collections/sequence.dart';
import 'package:ship_conquest/domain/lobby/complete_lobby.dart';
import 'package:ship_conquest/providers/game/event_handlers/general_event.dart';
import 'package:ship_conquest/providers/lobby_storage.dart';
import 'package:ship_conquest/widgets/screens/lobby/filter_button.dart';
import 'package:ship_conquest/widgets/screens/lobby/filters.dart';
import 'package:ship_conquest/widgets/screens/lobby/lobby_tile.dart';
import 'package:ship_conquest/widgets/screens/menu_utils/green_background.dart';
import 'package:ship_conquest/widgets/screens/menu_utils/mountains_background.dart';

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
  Sequence<CompleteLobby>? lobbies;

  final int _limit = 10;
  int _skip = 0;

  @override
  void initState() {
    super.initState();
    _getLobbies();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        _skip += _limit;
        _getLobbies();
      }
    });
  }

  Future<void> _getLobbies() async {
    final searchedLobby = _lobbySearchController.text;

    final queryResult = await GeneralEvent.getLobbies(context, _skip, _limit,
        _dateFilter.toRequestOrder, searchedLobby, _selectedFilterType.name);
    setState(() {
      final lobbyList = lobbies;
      if (lobbyList != null) {
        lobbies = lobbyList.plus(queryResult);
      } else {
        lobbies = queryResult;
      }
    });
  }

  void _handleFilter(FilterType filter) {
    setState(() {
      _selectedFilterType = filter;
    });
  }

  void _changeFilterAndUpdateLobbies(FilterType filter) async {
    setState(() {
      lobbies = null;
      _skip = 0;
    });

    _handleFilter(filter);
    _updateLobbies(filter);
  }

  void _updateLobbies(FilterType filter) async {
    final searchedLobby = _lobbySearchController.text;
    final queryResult = await GeneralEvent.getLobbies(context, _skip, _limit,
        _dateFilter.toRequestOrder, searchedLobby, filter.name);

    setState(() {
      lobbies = queryResult;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    backgroundColor:
                    Theme.of(context).colorScheme.background,
                    foregroundColor:
                    Theme.of(context).colorScheme.secondary,
                    onPressed: () async {
                      final name = await showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15))),
                          titleTextStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary),
                          backgroundColor:
                          Theme.of(context).colorScheme.background,
                          title: const Text('Enter lobby name'),
                          content: TextField(
                            autofocus: true,
                            controller: _createLobbyController,
                            onEditingComplete: () => Navigator.pop(
                                context, _createLobbyController.text),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                              Theme.of(context).colorScheme.secondary,
                              hintText: 'Choose a cool name!',
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
                            cursorColor:
                            Theme.of(context).colorScheme.background,
                            cursorWidth: 2.0,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _createLobbyController.clear();
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(
                                  context, _createLobbyController.text),
                              child: Text(
                                'Create!',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (name != null && name.isNotEmpty && mounted) {
                        GeneralEvent.createLobby(context, name,
                                (lid) {
                              lobbyStorage.setLobbyId(lid);
                              context.go("/loading-game");
                            }
                        );
                      }
                    },
                    child: const Icon(Icons.add),
                  ),
                )),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: Theme.of(context).colorScheme.background,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Stack(children: [
                        buildGreenBackgroundWidget(context),
                        buildMountainsBackgroundWidget(
                            context, 'assets/images/lobby_mountains.png'),
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
                                        _changeFilterAndUpdateLobbies(
                                            FilterType.all);
                                      }),
                                  const FractionallySizedBox(widthFactor: 0.02),
                                  FilterButton(
                                    content: "Favorites",
                                    isSelected:
                                    _selectedFilterType == FilterType.favorite,
                                    onClick: () {
                                      _changeFilterAndUpdateLobbies(
                                          FilterType.favorite);
                                    },
                                  ),
                                  const FractionallySizedBox(widthFactor: 0.02),
                                  FilterButton(
                                      content: "Recent",
                                      isSelected:
                                      _selectedFilterType == FilterType.recent,
                                      onClick: () {
                                        _changeFilterAndUpdateLobbies(
                                            FilterType.recent);
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
                                        fillColor:
                                        Theme.of(context).colorScheme.secondary,
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
                                            setState(() {
                                              lobbies = null;
                                              _skip = 0;
                                            } );
                                            // make search and update the list
                                            final queryResult =
                                            await GeneralEvent.getLobbies(
                                                context,
                                                _skip,
                                                _limit,
                                                _dateFilter.toRequestOrder,
                                                _lobbySearchController.text,
                                                _selectedFilterType.name);
                                            setState(() => lobbies = queryResult);
                                          },
                                        ),
                                      ),
                                      onEditingComplete: () async {
                                        setState(() {
                                          lobbies = null;
                                          _skip = 0;
                                        } );
                                        _focusNode.unfocus();
                                        // make search and update the list
                                        final queryResult =
                                        await GeneralEvent.getLobbies(
                                            context,
                                            _skip,
                                            _limit,
                                            _dateFilter.toRequestOrder,
                                            _lobbySearchController.text,
                                            _selectedFilterType.name);
                                        setState(() => lobbies = queryResult);
                                      },
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
                                      cursorColor:
                                      Theme.of(context).colorScheme.background,
                                      cursorWidth: 2.0,
                                    ),
                                  )),
                              Container(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Divider(
                                    color: Theme.of(context).colorScheme.secondary,
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
                                          setState(() => lobbies = null);
                                          // make search and update the list
                                          final queryResult =
                                          await GeneralEvent.getLobbies(
                                              context,
                                              0,
                                              _limit,
                                              _dateFilter.toRequestOrder,
                                              _lobbySearchController.text,
                                              _selectedFilterType.name);
                                          setState(() => lobbies = queryResult);
                                        }),
                                  ],
                                ),
                              ),
                              if (lobbies != null) ...[
                                Expanded(
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    itemCount: lobbies?.length,
                                    itemBuilder: (context, index) {
                                      final lobby = lobbies!.get(index);
                                      return LobbyTile(
                                        lobby: lobby,
                                        onClick: () {
                                          GeneralEvent.joinLobby(
                                              context,
                                              lobby.tag,
                                                  (lid) {
                                                lobbyStorage.setLobbyId(lid);
                                                context.go("/loading-game");
                                              }
                                          );
                                        },
                                      );
                                    },
                                  ),
                                )
                              ] else ...[
                                const Expanded(
                                    child: Align(
                                      alignment: Alignment(0.0, -0.5),
                                      child: CircularProgressIndicator(),
                                    ))
                              ]
                            ],
                          ),
                        ),
                      ])),
                ],
              ),
            )));
  }
}