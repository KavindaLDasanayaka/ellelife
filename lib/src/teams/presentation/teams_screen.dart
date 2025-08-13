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

class TeamsScreen extends StatelessWidget {
  TeamsScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teams"),
        actions: [
          Row(
            children: [
              Text("Add team"),
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
                icon: Icon(Icons.add),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
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
                  ),
                  onChanged: (value) {
                    BlocProvider.of<TeamsBloc>(
                      context,
                    ).add(SearchTeam(query: value));
                  },
                ),
              ],
            ),
          ),
          BlocBuilder<TeamsBloc, TeamsState>(
            builder: (context, state) {
              if (state is SearchingTeams) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SearchedTeams) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.filteredTeams.length,
                    itemBuilder: (context, index) {
                      final Team? team = state.filteredTeams[index];
                      return ListTile(
                        onTap: () {
                          (context).pushNamed(
                            RouteNames.singletTeam,
                            extra: team,
                          );
                        },
                        title: Text(team!.teamName),
                        subtitle: Text(team!.village),
                        leading: team.teamPhoto.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  team.teamPhoto,
                                  fit: BoxFit.cover,
                                  width: 50,
                                  height: 50,
                                ),
                              )
                            : const CircleAvatar(
                                radius: 64,
                                backgroundColor: mainColor,
                                backgroundImage: NetworkImage(
                                  "https://i.stack.imgur.com/l60Hf.png",
                                ),
                              ),
                      );
                    },
                  ),
                );
              } else {
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

                    return ListView.builder(
                      itemCount: teams.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final Team? team = teams[index];
                        return ListTile(
                          onTap: () {
                            (context).pushNamed(
                              RouteNames.singletTeam,
                              extra: team,
                            );
                          },
                          title: Text(
                            team!.teamName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            team.village,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: team.teamPhoto.isEmpty
                              ? const CircleAvatar(
                                  radius: 64,
                                  backgroundColor: mainColor,
                                  backgroundImage: NetworkImage(
                                    "https://i.stack.imgur.com/l60Hf.png",
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 64,
                                  backgroundColor: mainColor,
                                  backgroundImage: NetworkImage(team.teamPhoto),
                                ),
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
