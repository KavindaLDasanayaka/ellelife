import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ellelife/core/navigation/route_names.dart';
import 'package:ellelife/core/utils/colors.dart';
import 'package:ellelife/src/teams/data/teams_repo_impl.dart';
import 'package:ellelife/src/teams/domain/entities/team.dart';
import 'package:ellelife/src/teams/presentation/bloc/team_register_bloc.dart';
import 'package:ellelife/src/teams/presentation/bloc/teams_bloc.dart';
import 'package:ellelife/src/teams/presentation/team_register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TeamsScreen extends StatefulWidget {
  TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {}); // Trigger rebuild for suffix icon
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      BlocProvider.of<TeamsBloc>(context).add(SearchTeam(query: value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teams"),
        actions: [
          Row(
            children: [
              const Text("Add team"),
              IconButton(
                onPressed: () {
                  BlocProvider.of<TeamRegisterBloc>(
                    context,
                  ).add(TeamRegisterInitEvent());
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TeamRegister()),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search Team",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(width: 2, color: mainWhite),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                          BlocProvider.of<TeamsBloc>(
                            context,
                          ).add(TeamsInitEvent());
                        },
                      )
                    : const Icon(Icons.search),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          BlocBuilder<TeamsBloc, TeamsState>(
            builder: (context, state) {
              if (state is SearchingTeams) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchedTeams) {
                if (state.filteredTeams.isEmpty) {
                  return const Expanded(
                    child: Center(
                      child: Text(
                        "No teams found",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: state.filteredTeams.length,
                    itemBuilder: (context, index) {
                      final Team? team = state.filteredTeams[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Remove the unnecessary TeamsInitEvent call
                            context.pushNamed(
                              RouteNames.singletTeam,
                              extra: team,
                            );
                          },
                          child: Container(
                            child: Row(
                              children: [
                                team!.teamPhoto.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                          imageUrl: team.teamPhoto,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          "https://i.stack.imgur.com/l60Hf.png",
                                          fit: BoxFit.cover,
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      team.teamName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      team.village,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        // ignore: deprecated_member_use
                                        color: mainWhite.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is SearchingTeamsError) {
                return Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: TextStyle(fontSize: 16, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Clear search and return to initial state
                            setState(() {
                              _searchController.clear();
                            });
                            BlocProvider.of<TeamsBloc>(
                              context,
                            ).add(TeamsInitEvent());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is TeamsInitial) {
                return StreamBuilder(
                  stream: TeamsRepoImpl().getCurrentteams(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("Failed to fetch teams"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No teams available"));
                    }

                    final List<Team?> teams = snapshot.data!;

                    return Expanded(
                      child: ListView.builder(
                        itemCount: teams.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          final Team? team = teams[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                (context).pushNamed(
                                  RouteNames.singletTeam,
                                  extra: team,
                                );
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    team!.teamPhoto.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: team.teamPhoto,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                            child: Image.network(
                                              "https://i.stack.imgur.com/l60Hf.png",
                                              fit: BoxFit.cover,
                                              width: 50,
                                              height: 50,
                                            ),
                                          ),
                                    const SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          team.teamName,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          team.village,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            // ignore: deprecated_member_use
                                            color: mainWhite.withOpacity(0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text("Add Teams"));
              }
            },
          ),
        ],
      ),
    );
  }
}
